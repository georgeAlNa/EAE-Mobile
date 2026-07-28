import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordingHttpClientAdapter implements HttpClientAdapter {
  int protectedAttempts = 0;
  int refreshAttempts = 0;
  final protectedPayloads = <Object?>[];
  final protectedHeaders = <Map<String, dynamic>>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await requestStream?.drain<void>();

    if (options.path.endsWith(AppLinkUrl.refreshToken)) {
      refreshAttempts++;
      return ResponseBody.fromString(
        '{"data":{"token":"new-access-token","session_id":"session_001"}}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (options.path.endsWith(AppLinkUrl.questionsBulkImport)) {
      protectedAttempts++;
      protectedPayloads.add(options.data);
      protectedHeaders.add(Map<String, dynamic>.from(options.headers));

      if (protectedAttempts == 1) {
        return ResponseBody.fromString(
          '{"error":{"code":"unauthorized","message":"Expired token"}}',
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }

      return ResponseBody.fromString(
        '{"data":{"import_log_id":"import_001","total":1,"successful":1,"failed":0,"errors":[]}}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    return ResponseBody.fromString('{}', 404);
  }

  @override
  void close({bool force = false}) {}
}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'old-access-token',
  );
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.sessionId,
    'session_001',
  );
}

void main() {
  late Dio dio;
  late RecordingHttpClientAdapter adapter;
  late ApiServicesImpl apiServicesImpl;

  setUp(() async {
    await GetIt.I.reset();
    await resetPrefs();

    dio = Dio();
    adapter = RecordingHttpClientAdapter();
    dio.httpClientAdapter = adapter;
    GetIt.I.registerSingleton<Dio>(dio);

    apiServicesImpl = ApiServicesImpl();
    dio.interceptors.clear();
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test('multipart retry after token refresh rebuilds FormData', () async {
    var builderCalls = 0;

    final response = await apiServicesImpl.post(
      AppLinkUrl.questionsBulkImport,
      formDataBuilder: () {
        builderCalls++;
        return FormData.fromMap({
          'file': MultipartFile.fromBytes([
            builderCalls,
          ], filename: 'questions.csv'),
        });
      },
    );

    expect(response['data']['import_log_id'], 'import_001');
    expect(adapter.refreshAttempts, 1);
    expect(adapter.protectedAttempts, 2);
    expect(builderCalls, 2);
    expect(adapter.protectedPayloads[0], isA<FormData>());
    expect(adapter.protectedPayloads[1], isA<FormData>());
    expect(
      identical(adapter.protectedPayloads[0], adapter.protectedPayloads[1]),
      isFalse,
    );
    expect(adapter.protectedHeaders.first, isNot(contains('X-Tenant-ID')));
    expect(
      adapter.protectedHeaders.last['Authorization'],
      'Bearer new-access-token',
    );
  });
}

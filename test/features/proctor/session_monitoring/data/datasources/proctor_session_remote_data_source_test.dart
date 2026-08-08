import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/datasources/proctor_session_remote_data_source.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'access-token',
  );
}

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late ProctorSessionRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = ProctorSessionRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  test('session control endpoints use noauth token contract', () async {
    when(
      () => apiServicesImpl.post(
        AppLinkUrl.suspendExamSession('session_001'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => {'message': 'suspended'});
    when(
      () => apiServicesImpl.post(
        AppLinkUrl.resumeExamSession('session_001'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => {'message': 'resumed'});
    when(
      () => apiServicesImpl.post(
        AppLinkUrl.terminateExamSession('session_001'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => {'message': 'terminated'});

    expect(
      (await remoteDataSource.suspendExamSession('session_001')).message,
      'suspended',
    );
    expect(
      (await remoteDataSource.resumeExamSession('session_001')).message,
      'resumed',
    );
    expect(
      (await remoteDataSource.terminateExamSession('session_001')).message,
      'terminated',
    );

    verify(
      () => apiServicesImpl.post(
        AppLinkUrl.suspendExamSession('session_001'),
        token: '',
      ),
    ).called(1);
    verify(
      () => apiServicesImpl.post(
        AppLinkUrl.resumeExamSession('session_001'),
        token: '',
      ),
    ).called(1);
    verify(
      () => apiServicesImpl.post(
        AppLinkUrl.terminateExamSession('session_001'),
        token: '',
      ),
    ).called(1);
  });

  test('sanctions use stored token and proctor events use noauth', () async {
    when(
      () => apiServicesImpl.get(
        AppLinkUrl.examSessionSanctions('session_001'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => {'data': []});
    when(
      () => apiServicesImpl.post(
        AppLinkUrl.examSessionProctorEvents('session_001'),
        body: any(named: 'body'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => {'message': 'event submitted'});

    expect(
      (await remoteDataSource.getSessionSanctions('session_001')).data,
      isEmpty,
    );
    await remoteDataSource.submitProctoringEvent(
      'session_001',
      SubmitProctoringEventRequestBody(eventType: 'focus_lost'),
    );

    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.examSessionSanctions('session_001'),
        token: 'access-token',
      ),
    ).called(1);
    verify(
      () => apiServicesImpl.post(
        AppLinkUrl.examSessionProctorEvents('session_001'),
        body: any(named: 'body'),
        token: '',
      ),
    ).called(1);
  });
}

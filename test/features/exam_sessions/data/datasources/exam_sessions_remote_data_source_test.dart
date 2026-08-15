import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/features/exam_sessions/data/datasources/exam_sessions_remote_data_source.dart';
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

Map<String, dynamic> emptyResponse() => {
  'data': [],
  'meta': {'current_page': 1, 'per_page': 15, 'total': 0, 'last_page': 1},
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late ExamSessionsRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, String>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = ExamSessionsRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
    when(
      () => apiServicesImpl.get(
        AppLinkUrl.examSessions,
        queryParams: any(named: 'queryParams'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => emptyResponse());
  });

  test('tenant admin all sends empty query params and bearer token', () async {
    await remoteDataSource.getExamSessions();

    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.examSessions,
        queryParams: {},
        token: 'access-token',
      ),
    ).called(1);
  });

  test(
    'builds status, exam, candidate, combined, and pagination params',
    () async {
      await remoteDataSource.getExamSessions(status: 'in_progress');
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.examSessions,
          queryParams: {'status': 'in_progress'},
          token: 'access-token',
        ),
      ).called(1);

      await remoteDataSource.getExamSessions(examId: 'exam-uuid');
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.examSessions,
          queryParams: {'exam_id': 'exam-uuid'},
          token: 'access-token',
        ),
      ).called(1);

      await remoteDataSource.getExamSessions(candidateId: 'candidate-uuid');
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.examSessions,
          queryParams: {'candidate_id': 'candidate-uuid'},
          token: 'access-token',
        ),
      ).called(1);

      await remoteDataSource.getExamSessions(
        status: 'completed',
        examId: 'exam-uuid',
      );
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.examSessions,
          queryParams: {'status': 'completed', 'exam_id': 'exam-uuid'},
          token: 'access-token',
        ),
      ).called(1);

      await remoteDataSource.getExamSessions(page: 2, perPage: 50);
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.examSessions,
          queryParams: {'page': '2', 'per_page': '50'},
          token: 'access-token',
        ),
      ).called(1);
    },
  );
}

import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/datasources/live_sessions_and_enrollment_management_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/models/live_sessions_and_enrollment_management_request_body.dart';
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

Map<String, dynamic> enrollmentJson({String id = 'enrollment_001'}) => {
  'id': id,
  'exam_id': 'exam_001',
  'candidate_user_id': 'candidate_001',
  'tenant_id': 'tenant_001',
  'cohort_id': 'cohort_001',
  'enrollment_status': 'active',
  'enrollment_date': '2026-07-01T20:00:00.000Z',
  'start_window_date': '2026-07-02T20:00:00.000Z',
  'end_window_date': '2026-07-09T20:00:00.000Z',
  'can_retake_exam': true,
  'max_attempts_allowed': 3,
  'attempts_used': 1,
  'attempts_remaining': 2,
  'highest_score_achieved': 86,
  'highest_score_status': 'passed',
  'enrollment_notes': 'Priority candidate',
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

CreateEnrollmentRequestBody createEnrollmentRequest() =>
    CreateEnrollmentRequestBody(
      candidateUserId: 'candidate_001',
      cohortId: 'cohort_001',
      startWindowDate: '2026-07-02T20:00:00.000Z',
      endWindowDate: '2026-07-09T20:00:00.000Z',
      maxAttemptsAllowed: 3,
      enrollmentNotes: 'Priority candidate',
    );

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late LiveSessionsAndEnrollmentManagementRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = LiveSessionsAndEnrollmentManagementRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('LiveSessionsAndEnrollmentManagementRemoteDataSourceImpl', () {
    test('enrollment endpoints use stored token and expected body', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.examEnrollments('exam_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [enrollmentJson()],
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.examEnrollments('exam_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {'data': enrollmentJson(id: 'enrollment_created')},
      );
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.examEnrollmentDetails('exam_001', 'enrollment_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Enrollment deleted'});

      expect(
        (await remoteDataSource.enrollments('exam_001')).data.single.id,
        'enrollment_001',
      );
      expect(
        (await remoteDataSource.createEnrollment(
          'exam_001',
          createEnrollmentRequest(),
        )).data.id,
        'enrollment_created',
      );
      expect(
        (await remoteDataSource.deleteEnrollment(
          'exam_001',
          'enrollment_001',
        )).message,
        'Enrollment deleted',
      );

      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.examEnrollments('exam_001'),
          token: 'access-token',
        ),
      ).called(1);
      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.examEnrollments('exam_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(createCapture[0], {
        'candidate_user_id': 'candidate_001',
        'cohort_id': 'cohort_001',
        'start_window_date': '2026-07-02T20:00:00.000Z',
        'end_window_date': '2026-07-09T20:00:00.000Z',
        'max_attempts_allowed': 3,
        'enrollment_notes': 'Priority candidate',
      });
      expect(createCapture[1], 'access-token');
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.examEnrollmentDetails('exam_001', 'enrollment_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.examEnrollments('exam_001'),
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.enrollments('exam_001'),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}

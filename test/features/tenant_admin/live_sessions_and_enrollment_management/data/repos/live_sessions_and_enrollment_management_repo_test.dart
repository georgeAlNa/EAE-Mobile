import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/datasources/live_sessions_and_enrollment_management_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/models/live_sessions_and_enrollment_management_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/models/live_sessions_and_enrollment_management_response.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/repos/live_sessions_and_enrollment_management_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLiveSessionsEnrollmentRemoteDataSource extends Mock
    implements LiveSessionsAndEnrollmentManagementRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

EnrollmentItem enrollment({String id = 'enrollment_001'}) => EnrollmentItem(
  id: id,
  examId: 'exam_001',
  candidateUserId: 'candidate_001',
  tenantId: 'tenant_001',
  cohortId: 'cohort_001',
  enrollmentStatus: 'active',
  enrollmentDate: '2026-07-01T20:00:00.000Z',
  startWindowDate: '2026-07-02T20:00:00.000Z',
  endWindowDate: '2026-07-09T20:00:00.000Z',
  canRetakeExam: true,
  maxAttemptsAllowed: 3,
  attemptsUsed: 1,
  attemptsRemaining: 2,
  highestScoreAchieved: 86,
  highestScoreStatus: 'passed',
  enrollmentNotes: 'Priority candidate',
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

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
  late MockLiveSessionsEnrollmentRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late LiveSessionsAndEnrollmentManagementRepo repo;

  setUpAll(() {
    registerFallbackValue(createEnrollmentRequest());
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockLiveSessionsEnrollmentRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = LiveSessionsAndEnrollmentManagementRepo(
      liveSessionsAndEnrollmentManagementRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('LiveSessionsAndEnrollmentManagementRepo', () {
    test('enrollments returns response and handles offline/error', () async {
      final response = EnrollmentsResponse(data: [enrollment()]);
      connected();
      when(
        () => remoteDataSource.enrollments(any()),
      ).thenAnswer((_) async => response);

      expect(await repo.enrollments('exam_001'), same(response));

      offline();
      expect(
        () => repo.enrollments('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );

      connected();
      const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
      when(() => remoteDataSource.enrollments(any())).thenThrow(exception);
      expect(() => repo.enrollments('exam_001'), throwsA(exception));
    });

    test('create and delete enrollment call remote when connected', () async {
      connected();
      final createResponse = EnrollmentResponse(
        data: enrollment(id: 'enrollment_created'),
      );
      final actionResponse = EnrollmentActionResponse(
        message: 'Enrollment deleted',
      );
      when(
        () => remoteDataSource.createEnrollment(any(), any()),
      ).thenAnswer((_) async => createResponse);
      when(
        () => remoteDataSource.deleteEnrollment(any(), any()),
      ).thenAnswer((_) async => actionResponse);

      expect(
        await repo.createEnrollment('exam_001', createEnrollmentRequest()),
        same(createResponse),
      );
      expect(
        await repo.deleteEnrollment('exam_001', 'enrollment_001'),
        same(actionResponse),
      );
    });

    test('mutations throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.createEnrollment('exam_001', createEnrollmentRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deleteEnrollment('exam_001', 'enrollment_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });
}

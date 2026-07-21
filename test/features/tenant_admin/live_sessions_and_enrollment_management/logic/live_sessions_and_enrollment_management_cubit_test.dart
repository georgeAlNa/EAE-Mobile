import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/models/live_sessions_and_enrollment_management_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/models/live_sessions_and_enrollment_management_response.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/data/repos/live_sessions_and_enrollment_management_repo.dart';
import 'package:eae_mobile/features/tenant_admin/live_sessions_and_enrollment_management/logic/live_sessions_and_enrollment_management_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLiveSessionsAndEnrollmentManagementRepo extends Mock
    implements LiveSessionsAndEnrollmentManagementRepo {}

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

bool isLoading(LiveSessionsAndEnrollmentManagementState state) =>
    state.maybeWhen(loading: () => true, orElse: () => false);

String? stateError(LiveSessionsAndEnrollmentManagementState state) =>
    state.whenOrNull(error: (error) => error);

EnrollmentsResponse? loadedEnrollments(
  LiveSessionsAndEnrollmentManagementState state,
) => state.whenOrNull(loaded: (response) => response);

EnrollmentResponse? createSuccess(
  LiveSessionsAndEnrollmentManagementState state,
) => state.whenOrNull(createSuccess: (response) => response);

EnrollmentActionResponse? actionSuccess(
  LiveSessionsAndEnrollmentManagementState state,
) => state.whenOrNull(actionSuccess: (response) => response);

void main() {
  late MockLiveSessionsAndEnrollmentManagementRepo repo;
  late LiveSessionsAndEnrollmentManagementCubit cubit;

  setUpAll(() {
    registerFallbackValue(createEnrollmentRequest());
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockLiveSessionsAndEnrollmentManagementRepo();
    cubit = LiveSessionsAndEnrollmentManagementCubit(
      liveSessionsAndEnrollmentManagementRepo: repo,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('LiveSessionsAndEnrollmentManagementCubit', () {
    test('initial state is initial', () {
      expect(
        cubit.state.maybeWhen(initial: () => true, orElse: () => false),
        isTrue,
      );
    });

    test('getEnrollments emits loading then loaded', () async {
      when(
        () => repo.enrollments(any()),
      ).thenAnswer((_) async => EnrollmentsResponse(data: [enrollment()]));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<LiveSessionsAndEnrollmentManagementState>(isLoading),
          predicate<LiveSessionsAndEnrollmentManagementState>(
            (state) =>
                loadedEnrollments(state)?.data.single.id == 'enrollment_001',
          ),
        ]),
      );

      await cubit.getEnrollments('exam_001');
      await emission;
      verify(() => repo.enrollments('exam_001')).called(1);
    });

    test('getEnrollments emits network error message', () async {
      when(() => repo.enrollments(any())).thenAnswer(
        (_) async =>
            throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<LiveSessionsAndEnrollmentManagementState>(isLoading),
          predicate<LiveSessionsAndEnrollmentManagementState>(
            (state) => stateError(state) == 'Unauthorized',
          ),
        ]),
      );

      await cubit.getEnrollments('exam_001');
      await emission;
    });

    test('refreshCurrentExam reloads only after an exam is selected', () async {
      await cubit.refreshCurrentExam();
      verifyNever(() => repo.enrollments(any()));

      when(
        () => repo.enrollments(any()),
      ).thenAnswer((_) async => EnrollmentsResponse(data: [enrollment()]));
      await cubit.getEnrollments('exam_001');

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<LiveSessionsAndEnrollmentManagementState>(isLoading),
          predicate<LiveSessionsAndEnrollmentManagementState>(
            (state) =>
                loadedEnrollments(state)?.data.single.id == 'enrollment_001',
          ),
        ]),
      );

      await cubit.refreshCurrentExam();
      await emission;
      verify(() => repo.enrollments('exam_001')).called(2);
    });

    test('createEnrollment emits createSuccess and handles error', () async {
      final response = EnrollmentResponse(
        data: enrollment(id: 'enrollment_created'),
      );
      when(
        () => repo.createEnrollment(any(), any()),
      ).thenAnswer((_) async => response);

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<LiveSessionsAndEnrollmentManagementState>(isLoading),
          predicate<LiveSessionsAndEnrollmentManagementState>(
            (state) => createSuccess(state)?.data.id == 'enrollment_created',
          ),
        ]),
      );
      await cubit.createEnrollment('exam_001', createEnrollmentRequest());
      await emission;

      when(() => repo.createEnrollment(any(), any())).thenThrow(
        const NetworkExceptions.unprocessableEntity('Invalid enrollment'),
      );
      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<LiveSessionsAndEnrollmentManagementState>(isLoading),
          predicate<LiveSessionsAndEnrollmentManagementState>(
            (state) => stateError(state) == 'Invalid enrollment',
          ),
        ]),
      );
      await cubit.createEnrollment('exam_001', createEnrollmentRequest());
      await emission;
    });

    test('deleteEnrollment emits actionSuccess', () async {
      when(() => repo.deleteEnrollment(any(), any())).thenAnswer(
        (_) async => EnrollmentActionResponse(message: 'Enrollment deleted'),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<LiveSessionsAndEnrollmentManagementState>(isLoading),
          predicate<LiveSessionsAndEnrollmentManagementState>(
            (state) => actionSuccess(state)?.message == 'Enrollment deleted',
          ),
        ]),
      );

      await cubit.deleteEnrollment('exam_001', 'enrollment_001');
      await emission;
    });

    test('non-network exceptions emit fallback messages', () async {
      when(
        () => repo.deleteEnrollment(any(), any()),
      ).thenThrow(Exception('boom'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<LiveSessionsAndEnrollmentManagementState>(isLoading),
          predicate<LiveSessionsAndEnrollmentManagementState>(
            (state) => stateError(state) == 'Failed to delete enrollment',
          ),
        ]),
      );

      await cubit.deleteEnrollment('exam_001', 'enrollment_001');
      await emission;
    });
  });
}

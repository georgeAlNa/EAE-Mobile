import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/models/cohorts_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/models/cohorts_response.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/repos/cohorts_repo.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/logic/cohorts_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCohortsRepo extends Mock implements CohortsRepo {}

CohortItem cohort({String id = 'cohort_001'}) => CohortItem(
  id: id,
  tenantId: 'tenant_001',
  createdByUserId: 'user_001',
  parentCohortId: null,
  cohortName: 'Spring Cohort',
  cohortCode: 'SPR-2026',
  cohortType: 'training',
  cohortDescription: 'Spring assessment cohort',
  hierarchyLevel: 0,
  cohortAttributes: const {'region': 'Dubai'},
  isActive: true,
  createdAt: '2026-07-01T20:00:00.000Z',
  updatedAt: '2026-07-15T20:00:00.000Z',
);

CohortMember member({String id = 'member_001'}) => CohortMember(
  id: id,
  cohortId: 'cohort_001',
  userId: 'user_001',
  tenantId: 'tenant_001',
  membershipRole: 'candidate',
  addedAt: '2026-07-01T20:00:00.000Z',
  removedAt: null,
  isActiveMember: true,
);

CreateCohortRequestBody createCohortRequest() => CreateCohortRequestBody(
  cohortName: 'Spring Cohort',
  cohortCode: 'SPR-2026',
  cohortType: 'training',
  cohortDescription: 'Spring assessment cohort',
);

UpdateCohortRequestBody updateCohortRequest() => UpdateCohortRequestBody(
  cohortName: 'Updated Cohort',
  cohortCode: 'UPD-2026',
  cohortType: 'department',
  cohortDescription: 'Updated description',
  isActive: false,
);

AddCohortMemberRequestBody addMemberRequest() =>
    AddCohortMemberRequestBody(userId: 'user_001', membershipRole: 'candidate');

bool isLoading(CohortsState state) =>
    state.maybeWhen(loading: () => true, orElse: () => false);

String? stateError(CohortsState state) =>
    state.whenOrNull(error: (error) => error);

CohortsResponse? loadedCohorts(CohortsState state) =>
    state.whenOrNull(loaded: (response) => response);

CohortDetailsResponse? detailsLoaded(CohortsState state) =>
    state.whenOrNull(detailsLoaded: (response) => response);

CohortMembersResponse? membersLoaded(CohortsState state) =>
    state.whenOrNull(membersLoaded: (response) => response);

CohortDetailsResponse? saveSuccess(CohortsState state) =>
    state.whenOrNull(saveSuccess: (response) => response);

CohortMemberResponse? memberSaveSuccess(CohortsState state) =>
    state.whenOrNull(memberSaveSuccess: (response) => response);

CohortActionResponse? actionSuccess(CohortsState state) =>
    state.whenOrNull(actionSuccess: (response) => response);

Future<CohortsState> waitForLoadTerminal(CohortsCubit cubit) {
  return cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (_) => true,
      error: (_) => true,
      orElse: () => false,
    ),
  );
}

void main() {
  late MockCohortsRepo repo;

  setUpAll(() {
    registerFallbackValue(createCohortRequest());
    registerFallbackValue(updateCohortRequest());
    registerFallbackValue(addMemberRequest());
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockCohortsRepo();
  });

  CohortsCubit createCubit() {
    final cubit = CohortsCubit(cohortsRepo: repo);
    addTearDown(cubit.close);
    return cubit;
  }

  void stubLoadSuccess() {
    when(
      () => repo.cohorts(),
    ).thenAnswer((_) async => CohortsResponse(data: [cohort()]));
  }

  Future<CohortsCubit> loadedCubit() async {
    stubLoadSuccess();
    final cubit = createCubit();
    await waitForLoadTerminal(cubit);
    return cubit;
  }

  group('CohortsCubit', () {
    test('loads cohorts on creation', () async {
      stubLoadSuccess();

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(loadedCohorts(state)?.data.single.id, 'cohort_001');
      verify(() => repo.cohorts()).called(1);
    });

    test('emits error when initial cohorts request fails', () async {
      when(() => repo.cohorts()).thenAnswer(
        (_) async =>
            throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      );

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(stateError(state), 'Unauthorized');
    });

    test('getCohorts emits loading then loaded on retry', () async {
      final cubit = await loadedCubit();

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => loadedCohorts(state)?.data.single.id == 'cohort_001',
          ),
        ]),
      );

      await cubit.getCohorts();
      await emission;
    });

    test('getCohortDetails emits detailsLoaded', () async {
      final cubit = await loadedCubit();
      when(
        () => repo.cohortDetails(any()),
      ).thenAnswer((_) async => CohortDetailsResponse(data: cohort()));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => detailsLoaded(state)?.data.id == 'cohort_001',
          ),
        ]),
      );

      await cubit.getCohortDetails('cohort_001');
      await emission;
    });

    test('create and update cohort emit saveSuccess', () async {
      final cubit = await loadedCubit();
      final response = CohortDetailsResponse(data: cohort(id: 'cohort_saved'));
      when(() => repo.createCohort(any())).thenAnswer((_) async => response);
      when(
        () => repo.updateCohort(any(), any()),
      ).thenAnswer((_) async => response);

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => saveSuccess(state)?.data.id == 'cohort_saved',
          ),
        ]),
      );
      await cubit.createCohort(createCohortRequest());
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => saveSuccess(state)?.data.id == 'cohort_saved',
          ),
        ]),
      );
      await cubit.updateCohort('cohort_001', updateCohortRequest());
      await emission;
    });

    test('deleteCohort emits actionSuccess and handles error', () async {
      final cubit = await loadedCubit();
      when(() => repo.deleteCohort(any())).thenAnswer(
        (_) async => CohortActionResponse(message: 'Cohort deleted'),
      );

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => actionSuccess(state)?.message == 'Cohort deleted',
          ),
        ]),
      );
      await cubit.deleteCohort('cohort_001');
      await emission;

      when(
        () => repo.deleteCohort(any()),
      ).thenThrow(const NetworkExceptions.notFound('Cohort not found'));
      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => stateError(state) == 'Cohort not found',
          ),
        ]),
      );
      await cubit.deleteCohort('missing_cohort');
      await emission;
    });

    test('member methods emit membersLoaded and memberSaveSuccess', () async {
      final cubit = await loadedCubit();
      when(
        () => repo.cohortMembers(any()),
      ).thenAnswer((_) async => CohortMembersResponse(data: [member()]));
      when(
        () => repo.addCohortMember(any(), any()),
      ).thenAnswer((_) async => CohortMemberResponse(data: member()));

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => membersLoaded(state)?.data.single.id == 'member_001',
          ),
        ]),
      );
      await cubit.getCohortMembers('cohort_001');
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => memberSaveSuccess(state)?.data.id == 'member_001',
          ),
        ]),
      );
      await cubit.addCohortMember('cohort_001', addMemberRequest());
      await emission;
    });

    test('removeCohortMember emits actionSuccess', () async {
      final cubit = await loadedCubit();
      when(() => repo.removeCohortMember(any(), any())).thenAnswer(
        (_) async => CohortActionResponse(message: 'Member removed'),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => actionSuccess(state)?.message == 'Member removed',
          ),
        ]),
      );

      await cubit.removeCohortMember('cohort_001', 'user_001');
      await emission;
    });

    test('non-network exceptions emit fallback messages', () async {
      final cubit = await loadedCubit();
      when(() => repo.cohortDetails(any())).thenThrow(Exception('boom'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CohortsState>(isLoading),
          predicate<CohortsState>(
            (state) => stateError(state) == 'Failed to load cohort details',
          ),
        ]),
      );

      await cubit.getCohortDetails('cohort_001');
      await emission;
    });
  });
}

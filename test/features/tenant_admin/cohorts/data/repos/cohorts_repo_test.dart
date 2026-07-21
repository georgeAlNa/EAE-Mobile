import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/datasources/cohorts_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/models/cohorts_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/models/cohorts_response.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/repos/cohorts_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCohortsRemoteDataSource extends Mock
    implements CohortsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

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

void main() {
  late MockCohortsRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late CohortsRepo repo;

  setUpAll(() {
    registerFallbackValue(createCohortRequest());
    registerFallbackValue(updateCohortRequest());
    registerFallbackValue(addMemberRequest());
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockCohortsRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = CohortsRepo(
      cohortsRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('CohortsRepo', () {
    test('cohorts returns response and handles offline/error', () async {
      final response = CohortsResponse(data: [cohort()]);
      connected();
      when(() => remoteDataSource.cohorts()).thenAnswer((_) async => response);

      expect(await repo.cohorts(), same(response));

      offline();
      expect(
        () => repo.cohorts(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );

      connected();
      const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
      when(() => remoteDataSource.cohorts()).thenThrow(exception);
      expect(() => repo.cohorts(), throwsA(exception));
    });

    test('cohort detail and mutations call remote when connected', () async {
      connected();
      final details = CohortDetailsResponse(data: cohort());
      final action = CohortActionResponse(message: 'Cohort deleted');
      when(
        () => remoteDataSource.cohortDetails(any()),
      ).thenAnswer((_) async => details);
      when(
        () => remoteDataSource.createCohort(any()),
      ).thenAnswer((_) async => details);
      when(
        () => remoteDataSource.updateCohort(any(), any()),
      ).thenAnswer((_) async => details);
      when(
        () => remoteDataSource.deleteCohort(any()),
      ).thenAnswer((_) async => action);

      expect(await repo.cohortDetails('cohort_001'), same(details));
      expect(await repo.createCohort(createCohortRequest()), same(details));
      expect(
        await repo.updateCohort('cohort_001', updateCohortRequest()),
        same(details),
      );
      expect(await repo.deleteCohort('cohort_001'), same(action));
    });

    test('member methods call remote when connected', () async {
      connected();
      final members = CohortMembersResponse(data: [member()]);
      final saved = CohortMemberResponse(data: member(id: 'member_created'));
      final action = CohortActionResponse(message: 'Member removed');
      when(
        () => remoteDataSource.cohortMembers(any()),
      ).thenAnswer((_) async => members);
      when(
        () => remoteDataSource.addCohortMember(any(), any()),
      ).thenAnswer((_) async => saved);
      when(
        () => remoteDataSource.removeCohortMember(any(), any()),
      ).thenAnswer((_) async => action);

      expect(await repo.cohortMembers('cohort_001'), same(members));
      expect(
        await repo.addCohortMember('cohort_001', addMemberRequest()),
        same(saved),
      );
      expect(
        await repo.removeCohortMember('cohort_001', 'user_001'),
        same(action),
      );
    });

    test('all actions throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.cohortDetails('cohort_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.createCohort(createCohortRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.updateCohort('cohort_001', updateCohortRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.deleteCohort('cohort_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.cohortMembers('cohort_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.addCohortMember('cohort_001', addMemberRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.removeCohortMember('cohort_001', 'user_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });
}

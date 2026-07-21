import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/datasources/cohorts_remote_data_source.dart';
import 'package:eae_mobile/features/tenant_admin/cohorts/data/models/cohorts_request_body.dart';
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

Map<String, dynamic> cohortJson({String id = 'cohort_001'}) => {
  'id': id,
  'tenant_id': 'tenant_001',
  'created_by_user_id': 'user_001',
  'parent_cohort_id': null,
  'cohort_name': 'Spring Cohort',
  'cohort_code': 'SPR-2026',
  'cohort_type': 'training',
  'cohort_description': 'Spring assessment cohort',
  'hierarchy_level': 0,
  'cohort_attributes': {'region': 'Dubai'},
  'is_active': true,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> memberJson({String id = 'member_001'}) => {
  'id': id,
  'cohort_id': 'cohort_001',
  'user_id': 'user_001',
  'tenant_id': 'tenant_001',
  'membership_role': 'candidate',
  'added_at': '2026-07-01T20:00:00.000Z',
  'removed_at': null,
  'is_active_member': true,
};

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
  late MockApiServicesImpl apiServicesImpl;
  late CohortsRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = CohortsRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('CohortsRemoteDataSourceImpl', () {
    test('cohort endpoints use stored token and expected bodies', () async {
      when(
        () =>
            apiServicesImpl.get(AppLinkUrl.cohorts, token: any(named: 'token')),
      ).thenAnswer(
        (_) async => {
          'data': [cohortJson()],
        },
      );
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.cohortDetails('cohort_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': cohortJson()});
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.cohorts,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': cohortJson(id: 'cohort_created')});
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.cohortDetails('cohort_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': cohortJson(id: 'cohort_updated')});
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.cohortDetails('cohort_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Cohort deleted'});

      expect((await remoteDataSource.cohorts()).data.single.id, 'cohort_001');
      expect(
        (await remoteDataSource.cohortDetails('cohort_001')).data.id,
        'cohort_001',
      );
      expect(
        (await remoteDataSource.createCohort(createCohortRequest())).data.id,
        'cohort_created',
      );
      expect(
        (await remoteDataSource.updateCohort(
          'cohort_001',
          updateCohortRequest(),
        )).data.id,
        'cohort_updated',
      );
      expect(
        (await remoteDataSource.deleteCohort('cohort_001')).message,
        'Cohort deleted',
      );

      verify(
        () => apiServicesImpl.get(AppLinkUrl.cohorts, token: 'access-token'),
      ).called(1);
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.cohortDetails('cohort_001'),
          token: 'access-token',
        ),
      ).called(1);
      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.cohorts,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(createCapture[0], {
        'cohort_name': 'Spring Cohort',
        'cohort_code': 'SPR-2026',
        'cohort_type': 'training',
        'cohort_description': 'Spring assessment cohort',
        'parent_cohort_id': null,
      });
      expect(createCapture[1], 'access-token');
      final updateCapture = verify(
        () => apiServicesImpl.patch(
          AppLinkUrl.cohortDetails('cohort_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(updateCapture[0], {
        'cohort_name': 'Updated Cohort',
        'cohort_code': 'UPD-2026',
        'cohort_type': 'department',
        'cohort_description': 'Updated description',
        'is_active': false,
      });
      expect(updateCapture[1], 'access-token');
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.cohortDetails('cohort_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('member endpoints use stored token and expected body', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.cohortMembers('cohort_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [memberJson()],
        },
      );
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.cohortMembers('cohort_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': memberJson(id: 'member_created')});
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.cohortMember('cohort_001', 'user_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Member removed'});

      expect(
        (await remoteDataSource.cohortMembers('cohort_001')).data.single.id,
        'member_001',
      );
      expect(
        (await remoteDataSource.addCohortMember(
          'cohort_001',
          addMemberRequest(),
        )).data.id,
        'member_created',
      );
      expect(
        (await remoteDataSource.removeCohortMember(
          'cohort_001',
          'user_001',
        )).message,
        'Member removed',
      );

      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.cohortMembers('cohort_001'),
          token: 'access-token',
        ),
      ).called(1);
      final addCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.cohortMembers('cohort_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(addCapture[0], {
        'user_id': 'user_001',
        'membership_role': 'candidate',
      });
      expect(addCapture[1], 'access-token');
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.cohortMember('cohort_001', 'user_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () =>
            apiServicesImpl.get(AppLinkUrl.cohorts, token: any(named: 'token')),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.cohorts(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}

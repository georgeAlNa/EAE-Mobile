import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/datasources/result_publication_remote_data_source.dart';
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

Map<String, dynamic> publishedResultJson() => {
  'result_id': 'result_001',
  'session_id': 'session_001',
  'candidate_id': 'candidate_001',
  'exam_id': 'exam_001',
  'tenant_id': 'tenant_001',
  'status': {'result_status': 'final', 'publication_status': 'published'},
  'summary': {
    'raw_score': 95,
    'max_score': 100,
    'percentage': 95,
    'grade_letter': 'A',
    'is_passing': true,
    'is_final': true,
    'totals': {
      'evaluations': 5,
      'pending_evaluations': 0,
      'correct': 4,
      'incorrect': 1,
    },
    'breakdown': const [],
  },
  'timestamps': {
    'calculated_at': '2026-07-21T03:09:07+00:00',
    'published_at': '2026-07-21T03:09:34+00:00',
  },
  'metadata': null,
};

Map<String, dynamic> statusJson() => {
  'session_id': 'session_001',
  'result_id': 'result_001',
  'result_status': 'provisional',
  'publication_status': 'unpublished',
  'published_at': null,
  'result_calculated_at': '2026-07-21T03:02:50+00:00',
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late ResultPublicationRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = ResultPublicationRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('ResultPublicationRemoteDataSource', () {
    test(
      'publishSessionResult uses expected endpoint and stored token',
      () async {
        when(
          () => apiServicesImpl.post(
            AppLinkUrl.publishSessionResult('session_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'data': publishedResultJson()});

        final response = await remoteDataSource.publishSessionResult(
          'session_001',
        );

        expect(response.data.resultId, 'result_001');
        verify(
          () => apiServicesImpl.post(
            AppLinkUrl.publishSessionResult('session_001'),
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test(
      'getResultPublicationStatus uses expected endpoint and token',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.resultPublicationStatus('session_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'data': statusJson()});

        final response = await remoteDataSource.getResultPublicationStatus(
          'session_001',
        );

        expect(response.data.publicationStatus, 'unpublished');
        verify(
          () => apiServicesImpl.get(
            AppLinkUrl.resultPublicationStatus('session_001'),
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.resultPublicationStatus('session_001'),
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getResultPublicationStatus('session_001'),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}

import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/datasources/assessment_results_remote_data_source.dart';
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

Map<String, dynamic> resultJson() => {
  'result_id': 'result_001',
  'session_id': 'session_001',
  'candidate_id': 'candidate_001',
  'exam_id': 'exam_001',
  'tenant_id': 'tenant_001',
  'status': {'result_status': 'final', 'publication_status': 'published'},
  'summary': {
    'raw_score': 1,
    'max_score': 1,
    'percentage': 100,
    'grade_letter': 'A',
    'is_passing': true,
    'is_final': true,
    'totals': {
      'evaluations': 1,
      'pending_evaluations': 0,
      'correct': 0,
      'incorrect': 0,
    },
    'breakdown': const [],
  },
  'timestamps': {
    'calculated_at': '2026-07-21T03:09:07+00:00',
    'published_at': '2026-07-21T03:09:34+00:00',
  },
  'metadata': null,
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late AssessmentResultsRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = AssessmentResultsRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('AssessmentResultsRemoteDataSource', () {
    test(
      'getAssessmentResult uses expected endpoint and stored token',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.examSessionResult('session_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'data': resultJson()});

        final response = await remoteDataSource.getAssessmentResult(
          'session_001',
        );

        expect(response.data.resultId, 'result_001');
        verify(
          () => apiServicesImpl.get(
            AppLinkUrl.examSessionResult('session_001'),
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.examSessionResult('session_001'),
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getAssessmentResult('session_001'),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}

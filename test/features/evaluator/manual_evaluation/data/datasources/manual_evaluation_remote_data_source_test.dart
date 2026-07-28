import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/datasources/manual_evaluation_remote_data_source.dart';
import 'package:eae_mobile/features/evaluator/manual_evaluation/data/models/manual_evaluation_request_body.dart';
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

Map<String, dynamic> scoreBodyJson() => {
  'score_awarded': 1,
  'max_score_possible': 1,
  'evaluator_comments': ['Correct answer selected.'],
};

Map<String, dynamic> answerEvaluationJson() => {
  'id': 'eval_001',
  'session_id': 'session_001',
  'question_id': 'question_001',
  'tenant_id': 'tenant_001',
  'evaluator_user_id': 'usr_eval',
  'rubric_id': null,
  'evaluation_type': 'manual',
  'evaluation_status': 'scored',
  'score_awarded': 1,
  'max_score_possible': 1,
  'rubric_criteria_json': null,
  'evaluator_comments': ['Correct answer selected.'],
  'evaluation_metadata': {'reason': 'requires_human_evaluation'},
  'requires_secondary_review': false,
  'secondary_reviewer_id': null,
  'evaluated_at': '2026-07-21T03:09:07+00:00',
  'secondary_reviewed_at': null,
  'created_at': '2026-07-21T03:01:22+00:00',
};

Map<String, dynamic> publicationStatusJson() => {
  'session_id': 'session_001',
  'result_id': 'result_001',
  'result_status': 'provisional',
  'publication_status': 'unpublished',
  'published_at': null,
  'result_calculated_at': '2026-07-21T03:02:50+00:00',
};

Map<String, dynamic> publishedResultJson() => {
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
    'breakdown': [],
  },
  'timestamps': {
    'calculated_at': '2026-07-21T03:09:07+00:00',
    'published_at': '2026-07-21T03:09:34+00:00',
  },
  'metadata': {'grade_letter': 'A'},
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late ManualEvaluationRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = ManualEvaluationRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('ManualEvaluationRemoteDataSourceImpl', () {
    test('getPendingEvaluations gets endpoint with stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.pendingEvaluations('session_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': []});

      final response = await remoteDataSource.getPendingEvaluations(
        'session_001',
      );

      expect(response.data, isEmpty);
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.pendingEvaluations('session_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('scoreEvaluation patches endpoint with body and token', () async {
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.answerEvaluationScore('eval_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': answerEvaluationJson()});

      final response = await remoteDataSource.scoreEvaluation(
        'eval_001',
        ScoreEvaluationRequestBody.fromJson(scoreBodyJson()),
      );

      expect(response.data.id, 'eval_001');
      final captured = verify(
        () => apiServicesImpl.patch(
          AppLinkUrl.answerEvaluationScore('eval_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(captured[0], scoreBodyJson());
      expect(captured[1], 'access-token');
    });

    test('publishSessionResult posts endpoint with stored token', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.publishSessionResult('session_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': publishedResultJson()});

      final response = await remoteDataSource.publishSessionResult(
        'session_001',
      );

      expect(response.data.status.publicationStatus, 'published');
      verify(
        () => apiServicesImpl.post(
          AppLinkUrl.publishSessionResult('session_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test(
      'getResultPublicationStatus gets endpoint with stored token',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.resultPublicationStatus('session_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'data': publicationStatusJson()});

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
          AppLinkUrl.pendingEvaluations('session_001'),
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getPendingEvaluations('session_001'),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}

import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/datasources/assessment_session_remote_data_source.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_request_body.dart';
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

Map<String, dynamic> sessionResponse({String state = 'in_progress'}) => {
  'data': {
    'session_id': 'session_001',
    'tenant_id': 'tenant_001',
    'exam_id': 'exam_001',
    'candidate_id': 'candidate_001',
    'enrollment_id': 'enrollment_001',
    'state': state,
    'current': {
      'session_item_id': null,
      'question_version_id': null,
      'section_id': null,
      'question_index': 0,
    },
    'progress': {
      'total_questions_responded': 0,
      'total_questions_flagged': 0,
      'progress_data': {},
    },
    'timestamps': {
      'started_at': '2026-06-25T14:03:03Z',
      'resumed_at': null,
      'ended_at': null,
      'last_heartbeat_at': null,
    },
    'total_session_duration_seconds': 0,
    'version_lock': 0,
  },
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late AssessmentSessionRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = AssessmentSessionRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  test('starts exam session with stored token and exam id body', () async {
    when(
      () => apiServicesImpl.post(
        AppLinkUrl.examSessions,
        body: any(named: 'body'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => sessionResponse());

    final response = await remoteDataSource.startExamSession(
      StartExamSessionRequestBody(examId: 'exam_001'),
    );

    expect(response.data.sessionId, 'session_001');
    final captured = verify(
      () => apiServicesImpl.post(
        AppLinkUrl.examSessions,
        body: captureAny(named: 'body'),
        token: captureAny(named: 'token'),
      ),
    ).captured;
    expect(captured[0], {'exam_id': 'exam_001'});
    expect(captured[1], 'access-token');
  });

  test('submits answer and completes session with stored token', () async {
    when(
      () => apiServicesImpl.post(
        AppLinkUrl.examSessionResponses('session_001'),
        body: any(named: 'body'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => sessionResponse());
    when(
      () => apiServicesImpl.post(
        AppLinkUrl.completeExamSession('session_001'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => sessionResponse(state: 'completed'));

    await remoteDataSource.submitExamAnswer(
      'session_001',
      SubmitExamAnswerRequestBody(
        sessionItemId: 'item_001',
        responseType: 'mcq',
        selectedOptions: const ['option_001'],
        timeSpentSeconds: 15,
        timeElapsedFromStartSeconds: 15,
        expectedItemVersionLock: 0,
      ),
    );
    final complete = await remoteDataSource.completeExamSession('session_001');

    expect(complete.data.state, 'completed');
    final submitBody =
        verify(
              () => apiServicesImpl.post(
                AppLinkUrl.examSessionResponses('session_001'),
                body: captureAny(named: 'body'),
                token: 'access-token',
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(submitBody['session_item_id'], 'item_001');
    expect(submitBody['selected_options'], ['option_001']);
    expect(submitBody['expected_item_version_lock'], 0);
    verify(
      () => apiServicesImpl.post(
        AppLinkUrl.completeExamSession('session_001'),
        token: 'access-token',
      ),
    ).called(1);
  });

  test('gets exam session state with stored token', () async {
    when(
      () => apiServicesImpl.get(
        AppLinkUrl.examSession('session_001'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => sessionResponse(state: 'paused'));

    final response = await remoteDataSource.getExamSessionState('session_001');

    expect(response.data.state, 'paused');
    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.examSession('session_001'),
        token: 'access-token',
      ),
    ).called(1);
  });
}

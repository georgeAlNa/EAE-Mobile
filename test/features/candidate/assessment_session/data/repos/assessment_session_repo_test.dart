import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/datasources/assessment_session_remote_data_source.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_request_body.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_response.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/repos/assessment_session_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentSessionRemoteDataSource extends Mock
    implements AssessmentSessionRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

ExamSessionResponse sessionResponse({String state = 'in_progress'}) =>
    ExamSessionResponse(
      data: ExamSessionData(
        sessionId: 'session_001',
        tenantId: 'tenant_001',
        examId: 'exam_001',
        candidateId: 'candidate_001',
        enrollmentId: 'enrollment_001',
        state: state,
        current: ExamSessionCurrent(questionIndex: 0),
        progress: ExamSessionProgress(
          totalQuestionsResponded: 0,
          totalQuestionsFlagged: 0,
          progressData: const [],
        ),
        timestamps: ExamSessionTimestamps(startedAt: '2026-06-25T14:03:03Z'),
        totalSessionDurationSeconds: 0,
        versionLock: 0,
      ),
    );

void main() {
  late MockAssessmentSessionRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late AssessmentSessionRepo repo;

  setUpAll(() {
    registerFallbackValue(StartExamSessionRequestBody(examId: ''));
    registerFallbackValue(
      SubmitExamAnswerRequestBody(
        sessionItemId: '',
        responseType: '',
        timeSpentSeconds: 0,
        timeElapsedFromStartSeconds: 0,
      ),
    );
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockAssessmentSessionRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = AssessmentSessionRepo(
      assessmentSessionRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('AssessmentSessionRepo', () {
    test('session lifecycle methods call remote when connected', () async {
      connected();
      final response = sessionResponse();
      when(
        () => remoteDataSource.startExamSession(any()),
      ).thenAnswer((_) async => response);
      when(
        () => remoteDataSource.submitExamAnswer(any(), any()),
      ).thenAnswer((_) async => response);
      when(
        () => remoteDataSource.completeExamSession(any()),
      ).thenAnswer((_) async => sessionResponse(state: 'completed'));
      when(
        () => remoteDataSource.heartbeat(any()),
      ).thenAnswer((_) async => response);

      expect(
        await repo.startExamSession(
          StartExamSessionRequestBody(examId: 'exam_001'),
        ),
        same(response),
      );
      expect(
        await repo.submitExamAnswer(
          'session_001',
          SubmitExamAnswerRequestBody(
            sessionItemId: 'item_001',
            responseType: 'mcq',
            timeSpentSeconds: 15,
            timeElapsedFromStartSeconds: 15,
          ),
        ),
        same(response),
      );
      expect(
        (await repo.completeExamSession('session_001')).data.state,
        'completed',
      );
      expect(await repo.heartbeat('session_001'), same(response));
    });

    test('raw session methods call remote when connected', () async {
      connected();
      when(
        () => remoteDataSource.getExamSessionState(any()),
      ).thenAnswer((_) async => {'message': ''});
      when(
        () => remoteDataSource.getCurrentQuestion(any()),
      ).thenAnswer((_) async => {'message': ''});

      expect(await repo.getExamSessionState('session_001'), {'message': ''});
      expect(await repo.getCurrentQuestion('session_001'), {'message': ''});
    });

    test('throws noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.startExamSession(
          StartExamSessionRequestBody(examId: 'exam_001'),
        ),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.completeExamSession('session_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.startExamSession(any()));
      verifyNever(() => remoteDataSource.completeExamSession(any()));
    });
  });
}

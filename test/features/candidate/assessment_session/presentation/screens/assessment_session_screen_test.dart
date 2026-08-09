import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_request_body.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/models/assessment_session_response.dart';
import 'package:eae_mobile/features/candidate/assessment_session/data/repos/assessment_session_repo.dart';
import 'package:eae_mobile/features/candidate/assessment_session/logic/assessment_session_cubit.dart';
import 'package:eae_mobile/features/candidate/assessment_session/presentation/screens/assessment_session_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockAssessmentSessionRepo extends Mock implements AssessmentSessionRepo {}

void main() {
  late MockAssessmentSessionRepo repo;
  late AssessmentSessionCubit cubit;

  setUp(() async {
    await resetWidgetTestPreferences();
    repo = MockAssessmentSessionRepo();
    registerFallbackValue(StartExamSessionRequestBody(examId: ''));
    when(() => repo.startExamSession(any())).thenAnswer(
      (_) async => ExamSessionResponse(
        data: ExamSessionData(
          sessionId: 'session_001',
          tenantId: 'tenant_001',
          examId: 'exam_001',
          candidateId: 'candidate_001',
          enrollmentId: 'enrollment_001',
          state: 'in_progress',
          current: ExamSessionCurrent(
            sessionItemId: 'session_item_001',
            questionVersionId: 'question_version_001',
            questionIndex: 1,
          ),
          progress: ExamSessionProgress(
            totalQuestionsResponded: 0,
            totalQuestionsFlagged: 0,
            progressData: const {},
          ),
          timestamps: ExamSessionTimestamps(),
          totalSessionDurationSeconds: 300,
          versionLock: 0,
        ),
      ),
    );
    when(() => repo.getCurrentQuestion(any())).thenAnswer(
      (_) async => CurrentQuestionResponse(
        data: CandidateQuestion(
          questionVersionId: 'question_version_001',
          questionType: 'mcq',
          questionText: 'Choose the best option',
          choices: [
            CandidateQuestionChoice(
              optionId: 'option_001',
              optionText: 'Option A',
              optionSequence: 1,
            ),
          ],
        ),
      ),
    );
    cubit = AssessmentSessionCubit(assessmentSessionRepo: repo);
  });

  tearDown(() async {
    if (!cubit.isClosed) {
      await cubit.close();
    }
  });

  testWidgets('renders assessment session question UI from cubit state', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const AssessmentSessionScreen(),
      ),
    );

    await cubit.startExamSession('exam_001');
    await tester.pump();

    expect(
      cubit.state.maybeWhen(ready: (_) => true, orElse: () => false),
      isTrue,
    );
    expect(find.text('Choose the best option'), findsWidgets);
    expect(find.text('Submit Answer'), findsOneWidget);
    await cubit.close();
  });
}

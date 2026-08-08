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
    cubit = AssessmentSessionCubit(assessmentSessionRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
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

    expect(find.textContaining('QUESTION'), findsWidgets);
    expect(find.text('Risk Mitigation Analysis'), findsWidgets);
    expect(find.text('Submit Exam'), findsOneWidget);
  });
}

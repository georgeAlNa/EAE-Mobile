import 'package:eae_mobile/features/proctor/session_monitoring/data/repos/proctor_session_repo.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/logic/proctor_session_cubit.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/presentation/screens/proctor_session_monitoring_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class MockProctorSessionRepo extends Mock implements ProctorSessionRepo {}

void main() {
  late MockProctorSessionRepo repo;
  late ProctorSessionCubit cubit;

  setUp(() async {
    await resetWidgetTestPreferences();
    repo = MockProctorSessionRepo();
    cubit = ProctorSessionCubit(proctorSessionRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  testWidgets('renders proctor session monitoring controls', (tester) async {
    await pumpTestApp(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const ProctorSessionMonitoringScreen(),
      ),
    );

    expect(find.text('Proctor Session Monitoring'), findsOneWidget);
    expect(find.text('Session ID'), findsOneWidget);
    expect(find.text('Suspend'), findsOneWidget);
    expect(find.text('Void Sanction'), findsNWidgets(2));
    expect(find.text('Submit Event'), findsOneWidget);
  });
}

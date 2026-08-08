import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_request_body.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_response.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/repos/proctor_session_repo.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/logic/proctor_session_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProctorSessionRepo extends Mock implements ProctorSessionRepo {}

bool isLoading(ProctorSessionState state) =>
    state.maybeWhen(loading: () => true, orElse: () => false);

String? actionMessage(ProctorSessionState state) =>
    state.maybeWhen(actionSuccess: (message) => message, orElse: () => null);

String? stateError(ProctorSessionState state) =>
    state.maybeWhen(error: (error) => error, orElse: () => null);

void main() {
  late MockProctorSessionRepo repo;
  late ProctorSessionCubit cubit;

  setUpAll(() {
    registerFallbackValue(VoidSanctionRequestBody(reason: ''));
    registerFallbackValue(SubmitProctoringEventRequestBody());
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockProctorSessionRepo();
    cubit = ProctorSessionCubit(proctorSessionRepo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('ProctorSessionCubit', () {
    test('requires session id for session actions', () async {
      await cubit.suspendExamSession();

      expect(stateError(cubit.state), 'Session ID is required');
      verifyNever(() => repo.suspendExamSession(any()));
    });

    test('suspendExamSession emits loading then success', () async {
      cubit.sessionIdController.text = 'session_001';
      when(
        () => repo.suspendExamSession(any()),
      ).thenAnswer((_) async => ProctorActionResponse(message: 'suspended'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ProctorSessionState>(isLoading),
          predicate<ProctorSessionState>(
            (state) => actionMessage(state) == 'suspended',
          ),
        ]),
      );

      await cubit.suspendExamSession();
      await emission;
      verify(() => repo.suspendExamSession('session_001')).called(1);
    });

    test('getSessionSanctions emits loaded sanctions', () async {
      cubit.sessionIdController.text = 'session_001';
      when(
        () => repo.getSessionSanctions(any()),
      ).thenAnswer((_) async => SessionSanctionsResponse(data: const []));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ProctorSessionState>(isLoading),
          predicate<ProctorSessionState>(
            (state) => state.maybeWhen(
              sanctionsLoaded: (response) => response.data.isEmpty,
              orElse: () => false,
            ),
          ),
        ]),
      );

      await cubit.getSessionSanctions();
      await emission;
    });

    test('voidSanction validates required fields', () async {
      await cubit.voidSanction();

      expect(stateError(cubit.state), 'Sanction ID and reason are required');
      verifyNever(() => repo.voidSanction(any(), any()));
    });

    test('submitProctoringEvent emits network error message', () async {
      cubit.sessionIdController.text = 'session_001';
      when(
        () => repo.submitProctoringEvent(any(), any()),
      ).thenThrow(const NetworkExceptions.unprocessableEntity('Invalid event'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ProctorSessionState>(isLoading),
          predicate<ProctorSessionState>(
            (state) => stateError(state) == 'Invalid event',
          ),
        ]),
      );

      await cubit.submitProctoringEvent();
      await emission;
    });
  });
}

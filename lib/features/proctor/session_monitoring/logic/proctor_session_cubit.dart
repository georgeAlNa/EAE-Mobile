import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/proctor_session_request_body.dart';
import '../data/models/proctor_session_response.dart';
import '../data/repos/proctor_session_repo.dart';

part 'proctor_session_state.dart';

class ProctorSessionCubit extends Cubit<ProctorSessionState> {
  final ProctorSessionRepo proctorSessionRepo;

  ProctorSessionCubit({required this.proctorSessionRepo})
    : super(const ProctorSessionState.initial()) {
    sessionIdController = TextEditingController();
    sanctionIdController = TextEditingController();
    voidReasonController = TextEditingController();
    eventTypeController = TextEditingController();
    eventCategoryController = TextEditingController();
  }

  late final TextEditingController sessionIdController;
  late final TextEditingController sanctionIdController;
  late final TextEditingController voidReasonController;
  late final TextEditingController eventTypeController;
  late final TextEditingController eventCategoryController;

  String get _sessionId => sessionIdController.text.trim();

  Future<void> suspendExamSession() async {
    if (_sessionId.isEmpty) {
      emit(const ProctorSessionState.error(error: 'Session ID is required'));
      return;
    }

    await _runAction(
      () => proctorSessionRepo.suspendExamSession(_sessionId),
      fallbackMessage: 'Session suspended',
    );
  }

  Future<void> resumeExamSession() async {
    if (_sessionId.isEmpty) {
      emit(const ProctorSessionState.error(error: 'Session ID is required'));
      return;
    }

    await _runAction(
      () => proctorSessionRepo.resumeExamSession(_sessionId),
      fallbackMessage: 'Session resumed',
    );
  }

  Future<void> terminateExamSession() async {
    if (_sessionId.isEmpty) {
      emit(const ProctorSessionState.error(error: 'Session ID is required'));
      return;
    }

    await _runAction(
      () => proctorSessionRepo.terminateExamSession(_sessionId),
      fallbackMessage: 'Session terminated',
    );
  }

  Future<void> getSessionSanctions() async {
    if (_sessionId.isEmpty) {
      emit(const ProctorSessionState.error(error: 'Session ID is required'));
      return;
    }

    emit(const ProctorSessionState.loading());

    try {
      final response = await proctorSessionRepo.getSessionSanctions(_sessionId);
      emit(ProctorSessionState.sanctionsLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        ProctorSessionState.error(error: NetworkExceptions.getErrorMessage(e)),
      );
    } catch (e) {
      emit(const ProctorSessionState.error(error: 'Failed to load sanctions'));
    }
  }

  Future<void> voidSanction() async {
    final sanctionId = sanctionIdController.text.trim();
    if (sanctionId.isEmpty || voidReasonController.text.trim().isEmpty) {
      emit(
        const ProctorSessionState.error(
          error: 'Sanction ID and reason are required',
        ),
      );
      return;
    }

    await _runAction(
      () => proctorSessionRepo.voidSanction(
        sanctionId,
        VoidSanctionRequestBody(reason: voidReasonController.text.trim()),
      ),
      fallbackMessage: 'Sanction voided',
    );
  }

  Future<void> submitProctoringEvent() async {
    if (_sessionId.isEmpty) {
      emit(const ProctorSessionState.error(error: 'Session ID is required'));
      return;
    }

    await _runAction(
      () => proctorSessionRepo.submitProctoringEvent(
        _sessionId,
        SubmitProctoringEventRequestBody(
          eventType: eventTypeController.text.trim().isEmpty
              ? null
              : eventTypeController.text.trim(),
          eventTimestamp: DateTime.now().toIso8601String(),
          eventCategory: eventCategoryController.text.trim().isEmpty
              ? null
              : eventCategoryController.text.trim(),
          severityLevel: 'info',
        ),
      ),
      fallbackMessage: 'Proctoring event submitted',
    );
  }

  Future<void> getProctoringEvents() async {
    if (_sessionId.isEmpty) {
      emit(const ProctorSessionState.error(error: 'Session ID is required'));
      return;
    }

    emit(const ProctorSessionState.loading());

    try {
      final response = await proctorSessionRepo.getProctoringEvents(_sessionId);
      emit(ProctorSessionState.eventsLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        ProctorSessionState.error(error: NetworkExceptions.getErrorMessage(e)),
      );
    } catch (e) {
      emit(
        const ProctorSessionState.error(
          error: 'Failed to load proctoring events',
        ),
      );
    }
  }

  Future<void> _runAction(
    Future<ProctorActionResponse> Function() action, {
    required String fallbackMessage,
  }) async {
    emit(const ProctorSessionState.loading());

    try {
      final response = await action();
      emit(
        ProctorSessionState.actionSuccess(
          response.message.isEmpty ? fallbackMessage : response.message,
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        ProctorSessionState.error(error: NetworkExceptions.getErrorMessage(e)),
      );
    } catch (e) {
      emit(const ProctorSessionState.error(error: 'Proctor action failed'));
    }
  }

  @override
  Future<void> close() {
    sessionIdController.dispose();
    sanctionIdController.dispose();
    voidReasonController.dispose();
    eventTypeController.dispose();
    eventCategoryController.dispose();
    return super.close();
  }
}

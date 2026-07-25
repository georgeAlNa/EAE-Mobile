import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/manual_evaluation_request_body.dart';
import '../data/models/manual_evaluation_response.dart';
import '../data/repos/manual_evaluation_repo.dart';

part 'manual_evaluation_state.dart';

class ManualEvaluationCubit extends Cubit<ManualEvaluationState> {
  final ManualEvaluationRepo manualEvaluationRepo;

  ManualEvaluationCubit({required this.manualEvaluationRepo})
    : super(const ManualEvaluationState.initial());

  PendingEvaluationsResponse? pendingEvaluationsResponse;
  ResultPublicationStatusResponse? resultPublicationStatusResponse;
  ResultPublicationResponse? resultPublicationResponse;

  Future<void> getPendingEvaluations(String sessionId) async {
    emit(const ManualEvaluationState.pendingLoading());

    try {
      final response = await manualEvaluationRepo.getPendingEvaluations(
        sessionId,
      );
      pendingEvaluationsResponse = response;
      emit(ManualEvaluationState.pendingLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        ManualEvaluationState.pendingError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ManualEvaluationState.pendingError(
          error: 'Failed to load pending evaluations',
        ),
      );
    }
  }

  Future<void> scoreEvaluation(
    String evaluationId,
    ScoreEvaluationRequestBody requestBody,
  ) async {
    emit(const ManualEvaluationState.scoreLoading());

    try {
      final response = await manualEvaluationRepo.scoreEvaluation(
        evaluationId,
        requestBody,
      );
      emit(ManualEvaluationState.scoreSubmitted(response));
    } on NetworkExceptions catch (e) {
      emit(
        ManualEvaluationState.scoreError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ManualEvaluationState.scoreError(
          error: 'Failed to submit evaluation score',
        ),
      );
    }
  }

  Future<void> publishSessionResult(String sessionId) async {
    emit(const ManualEvaluationState.publishLoading());

    try {
      final response = await manualEvaluationRepo.publishSessionResult(
        sessionId,
      );
      resultPublicationResponse = response;
      emit(ManualEvaluationState.published(response));
    } on NetworkExceptions catch (e) {
      emit(
        ManualEvaluationState.publishError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ManualEvaluationState.publishError(
          error: 'Failed to publish result',
        ),
      );
    }
  }

  Future<void> getResultPublicationStatus(String sessionId) async {
    emit(const ManualEvaluationState.statusLoading());

    try {
      final response = await manualEvaluationRepo.getResultPublicationStatus(
        sessionId,
      );
      resultPublicationStatusResponse = response;
      emit(ManualEvaluationState.statusLoaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        ManualEvaluationState.statusError(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const ManualEvaluationState.statusError(
          error: 'Failed to load publication status',
        ),
      );
    }
  }
}

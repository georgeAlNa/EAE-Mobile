import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/assessment_results_response.dart';
import '../data/repos/assessment_results_repo.dart';

part 'assessment_results_state.dart';

class AssessmentResultsCubit extends Cubit<AssessmentResultsState> {
  final AssessmentResultsRepo assessmentResultsRepo;

  AssessmentResultsCubit({required this.assessmentResultsRepo})
      : super(const AssessmentResultsState.initial());

  AssessmentResultsResponse? assessmentResultsResponse;

  Future<void> getAssessmentResult(String sessionId) async {
    emit(const AssessmentResultsState.loading());

    try {
      final response = await assessmentResultsRepo.getAssessmentResult(
        sessionId,
      );
      assessmentResultsResponse = response;
      emit(AssessmentResultsState.success(response));
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentResultsState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentResultsState.error(
          error: 'Failed to load assessment result',
        ),
      );
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../data/models/assessment_inventory/assessment_inventory_response.dart';
import '../../data/models/assessment_models.dart';
import '../../data/repos/assessment_inventory_repo.dart';

part 'assessment_inventory_state.dart';
part 'assessment_inventory_cubit.freezed.dart';

class AssessmentInventoryCubit extends Cubit<AssessmentInventoryState> {
  final AssessmentInventoryRepo assessmentInventoryRepo;

  AssessmentInventoryCubit({required this.assessmentInventoryRepo})
    : super(const AssessmentInventoryState.loading()) {
    getAssessmentInventory();
  }

  Future<void> getAssessmentInventory() async {
    emit(const AssessmentInventoryState.loading());

    try {
      final response = await assessmentInventoryRepo.assessmentInventory();
      emit(
        AssessmentInventoryState.ready(
          viewData: _mapResponseToViewData(response),
        ),
      );
    } on NetworkExceptions catch (e) {
      emit(
        AssessmentInventoryState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const AssessmentInventoryState.error(
          error: 'Failed to load assessments',
        ),
      );
    }
  }

  AssessmentInventoryViewData _mapResponseToViewData(
    AssessmentInventoryResponse response,
  ) {
    final assessments = response.data.map(_mapExamToAvailable).toList();
    final primaryAssessment = response.data.isEmpty
        ? null
        : _mapExamToActive(response.data.first);

    return AssessmentInventoryViewData(
      primaryActiveAssessment: primaryAssessment,
      availableAssessments: assessments,
    );
  }

  ActiveAssessment _mapExamToActive(AssessmentExam exam) {
    return ActiveAssessment(
      id: exam.id,
      title: exam.examName,
      statusLabel: exam.examStatus,
      durationMinutes: exam.totalDurationMinutes,
      progress: 0,
      proctorsAvailable: 0,
      actionLabel: AppStrings.startAssessment,
      isPrimaryAction: true,
    );
  }

  AvailableAssessment _mapExamToAvailable(AssessmentExam exam) {
    return AvailableAssessment(
      id: exam.id,
      title: exam.examName,
      badgeLabel: exam.examStatus,
      durationLabel: '${exam.totalDurationMinutes} ${AppStrings.minutes}',
      description: exam.examDescription,
      difficultyLabel:
          '${AppStrings.difficultyLabel} ${exam.difficultyTierLevel}',
      sectionsLabel: '${exam.totalQuestions} ${AppStrings.questionLabel}',
    );
  }
}

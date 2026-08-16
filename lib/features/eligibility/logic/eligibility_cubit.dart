import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../tenant_admin/assessment_governance/data/models/assessment_governance_request_body.dart';
import '../../tenant_admin/assessment_governance/data/models/assessment_governance_response.dart';
import '../../tenant_admin/assessment_governance/data/repos/assessment_governance_repo.dart';

part 'eligibility_state.dart';

class EligibilityCubit extends Cubit<EligibilityState> {
  final AssessmentGovernanceRepo assessmentGovernanceRepo;
  final String examId;

  EligibilityCubit({
    required this.assessmentGovernanceRepo,
    required this.examId,
  }) : super(const EligibilityState.initial()) {
    loadEligibilityChains();
  }

  EligibilityChainsResponse? eligibilityChainsResponse;

  List<EligibilityChain> get chains =>
      eligibilityChainsResponse?.data ?? const <EligibilityChain>[];

  Future<void> loadEligibilityChains() async {
    if (examId.trim().isEmpty) {
      emit(const EligibilityState.failure('Select an exam'));
      return;
    }

    emit(const EligibilityState.loading());

    try {
      final response = await assessmentGovernanceRepo.getEligibilityChains(
        examId: examId,
      );
      final ordered = [...response.data]
        ..sort((a, b) => a.chainStepNumber.compareTo(b.chainStepNumber));
      eligibilityChainsResponse = EligibilityChainsResponse(data: ordered);

      if (ordered.isEmpty) {
        emit(const EligibilityState.empty());
      } else {
        emit(EligibilityState.loaded(eligibilityChainsResponse!));
      }
    } on NetworkExceptions catch (e) {
      emit(EligibilityState.failure(NetworkExceptions.getErrorMessage(e)));
    } catch (_) {
      emit(const EligibilityState.failure('Unable to load eligibility rules'));
    }
  }

  Future<void> refresh() => loadEligibilityChains();

  Future<EligibilityChain?> getEligibilityChainDetails(String chainId) async {
    emit(const EligibilityState.loading());

    try {
      final response = await assessmentGovernanceRepo
          .getEligibilityChainDetails(chainId);
      _upsert(response.data);
      _emitCurrentList();
      return response.data;
    } on NetworkExceptions catch (e) {
      emit(EligibilityState.failure(NetworkExceptions.getErrorMessage(e)));
    } catch (_) {
      emit(const EligibilityState.failure('Unable to load eligibility rules'));
    }
    return null;
  }

  Future<void> createEligibilityChain(
    EligibilityChainRequestBody requestBody,
  ) async {
    if (_hasDuplicateStep(requestBody.chainStepNumber)) {
      emit(const EligibilityState.failure('Step already exists for this exam'));
      return;
    }

    emit(const EligibilityState.saving());

    try {
      final response = await assessmentGovernanceRepo.createEligibilityChain(
        requestBody,
      );
      _upsert(response.data);
      emit(EligibilityState.saved(response));
      _emitCurrentList();
    } on NetworkExceptions catch (e) {
      emit(EligibilityState.failure(NetworkExceptions.getErrorMessage(e)));
    } catch (_) {
      emit(const EligibilityState.failure('Failed to save eligibility rule'));
    }
  }

  Future<void> updateEligibilityChain(
    String chainId,
    UpdateEligibilityChainRequestBody requestBody,
  ) async {
    final nextStep = requestBody.chainStepNumber;
    if (nextStep != null &&
        _hasDuplicateStep(nextStep, exceptChainId: chainId)) {
      emit(const EligibilityState.failure('Step already exists for this exam'));
      return;
    }

    emit(const EligibilityState.saving());

    try {
      final response = await assessmentGovernanceRepo.updateEligibilityChain(
        chainId,
        requestBody,
      );
      _upsert(response.data);
      emit(EligibilityState.saved(response));
      _emitCurrentList();
    } on NetworkExceptions catch (e) {
      emit(EligibilityState.failure(NetworkExceptions.getErrorMessage(e)));
    } catch (_) {
      emit(const EligibilityState.failure('Failed to update eligibility rule'));
    }
  }

  Future<void> deleteEligibilityChain(String chainId) async {
    emit(const EligibilityState.deleting());

    try {
      await assessmentGovernanceRepo.deleteEligibilityChain(chainId);
      final remaining =
          chains.where((chain) => chain.chainId != chainId).toList()
            ..sort((a, b) => a.chainStepNumber.compareTo(b.chainStepNumber));
      eligibilityChainsResponse = EligibilityChainsResponse(data: remaining);
      emit(EligibilityState.deleted(chainId));
      _emitCurrentList();
    } on NetworkExceptions catch (e) {
      emit(EligibilityState.failure(NetworkExceptions.getErrorMessage(e)));
    } catch (_) {
      emit(const EligibilityState.failure('Failed to delete eligibility rule'));
    }
  }

  bool _hasDuplicateStep(int step, {String? exceptChainId}) {
    return chains.any(
      (chain) =>
          chain.chainStepNumber == step && chain.chainId != exceptChainId,
    );
  }

  void _upsert(EligibilityChain chain) {
    final updated = [...chains];
    final index = updated.indexWhere((item) => item.chainId == chain.chainId);
    if (index == -1) {
      updated.add(chain);
    } else {
      updated[index] = chain;
    }
    updated.sort((a, b) => a.chainStepNumber.compareTo(b.chainStepNumber));
    eligibilityChainsResponse = EligibilityChainsResponse(data: updated);
  }

  void _emitCurrentList() {
    final current = eligibilityChainsResponse;
    if (current == null || current.data.isEmpty) {
      emit(const EligibilityState.empty());
    } else {
      emit(EligibilityState.loaded(current));
    }
  }
}

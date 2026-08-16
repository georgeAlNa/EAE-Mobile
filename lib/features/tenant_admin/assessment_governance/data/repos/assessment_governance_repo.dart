import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../../core/networking/network_info.dart';
import '../datasources/assessment_governance_remote_data_source.dart';
import '../models/assessment_governance_request_body.dart';
import '../models/assessment_governance_response.dart';

class AssessmentGovernanceRepo {
  final AssessmentGovernanceRemoteDataSource
  assessmentGovernanceRemoteDataSource;
  final NetworkInfo networkInfo;

  AssessmentGovernanceRepo({
    required this.assessmentGovernanceRemoteDataSource,
    required this.networkInfo,
  });

  Future<PenaltyRulesResponse> getPenaltyRules() async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource.getPenaltyRules();
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<PenaltyRuleResponse> createPenaltyRule(
    PenaltyRuleRequestBody penaltyRuleRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource.createPenaltyRule(
          penaltyRuleRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<PenaltyRuleResponse> getPenaltyRuleDetails(String ruleId) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource.getPenaltyRuleDetails(
          ruleId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<PenaltyRuleResponse> updatePenaltyRule(
    String ruleId,
    PenaltyRuleRequestBody penaltyRuleRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource.updatePenaltyRule(
          ruleId,
          penaltyRuleRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<AssessmentGovernanceActionResponse> deletePenaltyRule(
    String ruleId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource.deletePenaltyRule(
          ruleId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<PenaltyRuleResponse> activatePenaltyRule(String ruleId) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource.activatePenaltyRule(
          ruleId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<PenaltyRuleResponse> deactivatePenaltyRule(String ruleId) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource.deactivatePenaltyRule(
          ruleId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<EligibilityChainsResponse> getEligibilityChains({
    String? examId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource.getEligibilityChains(
          examId: examId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<EligibilityChainResponse> createEligibilityChain(
    EligibilityChainRequestBody eligibilityChainRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource
            .createEligibilityChain(eligibilityChainRequestBody);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<EligibilityChainResponse> getEligibilityChainDetails(
    String chainId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource
            .getEligibilityChainDetails(chainId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<EligibilityChainResponse> updateEligibilityChain(
    String chainId,
    UpdateEligibilityChainRequestBody updateEligibilityChainRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await assessmentGovernanceRemoteDataSource
            .updateEligibilityChain(chainId, updateEligibilityChainRequestBody);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<void> deleteEligibilityChain(String chainId) async {
    if (await networkInfo.isConnected) {
      try {
        await assessmentGovernanceRemoteDataSource.deleteEligibilityChain(
          chainId,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}

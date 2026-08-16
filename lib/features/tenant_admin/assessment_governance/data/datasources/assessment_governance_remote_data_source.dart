import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/assessment_governance_request_body.dart';
import '../models/assessment_governance_response.dart';

abstract class AssessmentGovernanceRemoteDataSource {
  Future<PenaltyRulesResponse> getPenaltyRules();
  Future<PenaltyRuleResponse> createPenaltyRule(
    PenaltyRuleRequestBody penaltyRuleRequestBody,
  );
  Future<PenaltyRuleResponse> getPenaltyRuleDetails(String ruleId);
  Future<PenaltyRuleResponse> updatePenaltyRule(
    String ruleId,
    PenaltyRuleRequestBody penaltyRuleRequestBody,
  );
  Future<AssessmentGovernanceActionResponse> deletePenaltyRule(String ruleId);
  Future<PenaltyRuleResponse> activatePenaltyRule(String ruleId);
  Future<PenaltyRuleResponse> deactivatePenaltyRule(String ruleId);

  Future<EligibilityChainsResponse> getEligibilityChains({String? examId});
  Future<EligibilityChainResponse> createEligibilityChain(
    EligibilityChainRequestBody eligibilityChainRequestBody,
  );
  Future<EligibilityChainResponse> getEligibilityChainDetails(String chainId);
  Future<EligibilityChainResponse> updateEligibilityChain(
    String chainId,
    UpdateEligibilityChainRequestBody updateEligibilityChainRequestBody,
  );
  Future<void> deleteEligibilityChain(String chainId);
}

class AssessmentGovernanceRemoteDataSourceImpl
    implements AssessmentGovernanceRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  AssessmentGovernanceRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<PenaltyRulesResponse> getPenaltyRules() async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.penaltyRules,
        token: _token,
      );

      return PenaltyRulesResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<PenaltyRuleResponse> createPenaltyRule(
    PenaltyRuleRequestBody penaltyRuleRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.penaltyRules,
        body: penaltyRuleRequestBody.toJson(),
        token: _token,
      );

      return PenaltyRuleResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<PenaltyRuleResponse> getPenaltyRuleDetails(String ruleId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.penaltyRuleDetails(ruleId),
        token: _token,
      );

      return PenaltyRuleResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<PenaltyRuleResponse> updatePenaltyRule(
    String ruleId,
    PenaltyRuleRequestBody penaltyRuleRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.penaltyRuleDetails(ruleId),
        body: penaltyRuleRequestBody.toJson(),
        token: _token,
      );

      return PenaltyRuleResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<AssessmentGovernanceActionResponse> deletePenaltyRule(
    String ruleId,
  ) async {
    try {
      final request = await apiServicesImpl.delete(
        AppLinkUrl.penaltyRuleDetails(ruleId),
        token: _token,
      );

      return AssessmentGovernanceActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<PenaltyRuleResponse> activatePenaltyRule(String ruleId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.activatePenaltyRule(ruleId),
        token: _token,
      );

      return PenaltyRuleResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<PenaltyRuleResponse> deactivatePenaltyRule(String ruleId) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.deactivatePenaltyRule(ruleId),
        token: _token,
      );

      return PenaltyRuleResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<EligibilityChainsResponse> getEligibilityChains({
    String? examId,
  }) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.eligibilityChains,
        queryParams: examId == null || examId.isEmpty
            ? null
            : {'exam_id': examId},
        token: _token,
      );

      return EligibilityChainsResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<EligibilityChainResponse> createEligibilityChain(
    EligibilityChainRequestBody eligibilityChainRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.eligibilityChains,
        body: eligibilityChainRequestBody.toJson(),
        token: _token,
      );

      return EligibilityChainResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<EligibilityChainResponse> getEligibilityChainDetails(
    String chainId,
  ) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.eligibilityChainDetails(chainId),
        token: _token,
      );

      return EligibilityChainResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<EligibilityChainResponse> updateEligibilityChain(
    String chainId,
    UpdateEligibilityChainRequestBody updateEligibilityChainRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.patch(
        AppLinkUrl.eligibilityChainDetails(chainId),
        body: updateEligibilityChainRequestBody.toJson(),
        token: _token,
      );

      return EligibilityChainResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<void> deleteEligibilityChain(String chainId) async {
    try {
      await apiServicesImpl.delete(
        AppLinkUrl.eligibilityChainDetails(chainId),
        token: _token,
      );
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }
}

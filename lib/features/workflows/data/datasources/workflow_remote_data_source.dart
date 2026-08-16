import 'package:dio/dio.dart';

import '../../../../core/constants/shared_pref_keys.dart';
import '../../../../core/helpers/app_shared_preferences.dart';
import '../../../../core/networking/api_services_impl.dart';
import '../../../../core/networking/app_link_url.dart';
import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/workflow_request_body.dart';
import '../models/workflow_response.dart';

abstract class WorkflowRemoteDataSource {
  Future<ApprovalWorkflowsListResponse> getWorkflows({
    String? status,
    String? workflowType,
    String? resourceType,
    String? resourceId,
    int? page,
    int? perPage,
  });

  Future<ApprovalWorkflowActionResponse> createWorkflow(
    CreateApprovalWorkflowRequestBody createApprovalWorkflowRequestBody,
  );

  Future<ApprovalWorkflowActionResponse> getWorkflow(String workflowId);

  Future<ApprovalWorkflowActionResponse> approveWorkflow(String workflowId);
}

class WorkflowRemoteDataSourceImpl implements WorkflowRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  WorkflowRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<ApprovalWorkflowsListResponse> getWorkflows({
    String? status,
    String? workflowType,
    String? resourceType,
    String? resourceId,
    int? page,
    int? perPage,
  }) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: _queryParams(
          status: status,
          workflowType: workflowType,
          resourceType: resourceType,
          resourceId: resourceId,
          page: page,
          perPage: perPage,
        ),
        token: _token,
      );

      return ApprovalWorkflowsListResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ApprovalWorkflowActionResponse> createWorkflow(
    CreateApprovalWorkflowRequestBody createApprovalWorkflowRequestBody,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.workflows,
        body: createApprovalWorkflowRequestBody.toJson(),
        token: _token,
      );

      return ApprovalWorkflowActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ApprovalWorkflowActionResponse> getWorkflow(String workflowId) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.workflowDetails(workflowId),
        token: _token,
      );

      return ApprovalWorkflowActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ApprovalWorkflowActionResponse> approveWorkflow(
    String workflowId,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.approveWorkflow(workflowId),
        token: _token,
      );

      return ApprovalWorkflowActionResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  Map<String, String> _queryParams({
    String? status,
    String? workflowType,
    String? resourceType,
    String? resourceId,
    int? page,
    int? perPage,
  }) {
    final params = <String, String>{};

    void addString(String key, String? value) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        params[key] = trimmed;
      }
    }

    void addInt(String key, int? value) {
      if (value != null) params[key] = value.toString();
    }

    addString('status', status);
    addString('workflow_type', workflowType);
    addString('resource_type', resourceType);
    addString('resource_id', resourceId);
    addInt('page', page);
    addInt('per_page', perPage);

    return params;
  }
}

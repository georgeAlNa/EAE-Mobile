import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../datasources/workflow_remote_data_source.dart';
import '../models/workflow_request_body.dart';
import '../models/workflow_response.dart';

class WorkflowRepo {
  final WorkflowRemoteDataSource workflowRemoteDataSource;
  final NetworkInfo networkInfo;

  WorkflowRepo({
    required this.workflowRemoteDataSource,
    required this.networkInfo,
  });

  Future<ApprovalWorkflowsListResponse> getWorkflows({
    String? status,
    String? workflowType,
    String? resourceType,
    String? resourceId,
    int? page,
    int? perPage,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        return await workflowRemoteDataSource.getWorkflows(
          status: status,
          workflowType: workflowType,
          resourceType: resourceType,
          resourceId: resourceId,
          page: page,
          perPage: perPage,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ApprovalWorkflowActionResponse> createWorkflow(
    CreateApprovalWorkflowRequestBody createApprovalWorkflowRequestBody,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await workflowRemoteDataSource.createWorkflow(
          createApprovalWorkflowRequestBody,
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ApprovalWorkflowActionResponse> getWorkflow(String workflowId) async {
    if (await networkInfo.isConnected) {
      try {
        return await workflowRemoteDataSource.getWorkflow(workflowId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ApprovalWorkflowActionResponse> approveWorkflow(
    String workflowId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await workflowRemoteDataSource.approveWorkflow(workflowId);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}

import 'package:dio/dio.dart';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';
import '../../../../../core/networking/api_services_impl.dart';
import '../../../../../core/networking/app_link_url.dart';
import '../../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../models/result_publication_request_body.dart';
import '../models/result_publication_response.dart';

abstract class ResultPublicationRemoteDataSource {
  Future<ResultPublicationResponse> publishSessionResult(String sessionId);
  Future<ResultPublicationStatusResponse> getResultPublicationStatus(
    String sessionId,
  );
  Future<ApprovalWorkflowActionResponse> createApprovalWorkflow(
    CreateApprovalWorkflowRequestBody createApprovalWorkflowRequestBody,
  );
  Future<ApprovalWorkflowActionResponse> getApprovalWorkflow(String workflowId);
  Future<ApprovalWorkflowActionResponse> approveWorkflow(String workflowId);
}

class ResultPublicationRemoteDataSourceImpl
    implements ResultPublicationRemoteDataSource {
  final ApiServicesImpl apiServicesImpl;

  ResultPublicationRemoteDataSourceImpl({required this.apiServicesImpl});

  String? get _token {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  @override
  Future<ResultPublicationResponse> publishSessionResult(
    String sessionId,
  ) async {
    try {
      final request = await apiServicesImpl.post(
        AppLinkUrl.publishSessionResult(sessionId),
        token: _token,
      );

      return ResultPublicationResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ResultPublicationStatusResponse> getResultPublicationStatus(
    String sessionId,
  ) async {
    try {
      final request = await apiServicesImpl.get(
        AppLinkUrl.resultPublicationStatus(sessionId),
        token: _token,
      );

      return ResultPublicationStatusResponse.fromJson(request);
    } on DioException catch (e) {
      throw NetworkExceptions.getException(e);
    } catch (e) {
      throw NetworkExceptions.getException(e);
    }
  }

  @override
  Future<ApprovalWorkflowActionResponse> createApprovalWorkflow(
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
  Future<ApprovalWorkflowActionResponse> getApprovalWorkflow(
    String workflowId,
  ) async {
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
}

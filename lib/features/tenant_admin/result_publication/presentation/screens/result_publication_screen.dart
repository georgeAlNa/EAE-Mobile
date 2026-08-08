import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/result_publication_request_body.dart';
import '../../data/models/result_publication_response.dart';
import '../../logic/result_publication_cubit.dart';

part '../widgets/result_publication_widgets.dart';

class ResultPublicationScreen extends StatelessWidget {
  const ResultPublicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<ResultPublicationCubit, ResultPublicationState>(
          listener: _listenToState,
          builder: (context, state) {
            final cubit = context.read<ResultPublicationCubit>();
            final status = cubit.resultPublicationStatusResponse;
            final published = cubit.resultPublicationResponse;
            final workflow = cubit.approvalWorkflowActionResponse;
            final isLoading = state.maybeWhen(
              statusLoading: () => true,
              publishLoading: () => true,
              workflowLoading: () => true,
              orElse: () => false,
            );

            return Stack(
              children: [
                ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 18.h,
                  ),
                  children: [
                    Text(
                      'Result publication',
                      style: AppTextStyles.font32DarkGreyMedium.copyWith(
                        color: AppColors.primaryColor9,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                      ),
                    ),
                    verticalSpace(12),
                    _ResultPublicationCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldWidget(
                            controller: cubit.sessionIdController,
                            hintText: 'exam session id',
                            labelText: 'Session ID',
                            obscureText: false,
                          ),
                          verticalSpace(12),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              FilledButton.icon(
                                onPressed: () => _checkStatus(context),
                                icon: const Icon(Icons.verified_outlined),
                                label: const Text('Status'),
                                style: _filledActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _publishResult(context),
                                icon: const Icon(Icons.publish_outlined),
                                label: const Text('Publish'),
                                style: _outlinedActionButtonStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(14),
                    _ResultPublicationCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Approval workflow',
                            style: AppTextStyles.font14DarkGreySemiBold
                                .copyWith(color: AppColors.primaryColor9),
                          ),
                          verticalSpace(12),
                          TextFieldWidget(
                            controller: cubit.workflowResourceIdController,
                            hintText: 'assessment result resource id',
                            labelText: 'Resource ID',
                            obscureText: false,
                          ),
                          verticalSpace(12),
                          TextFieldWidget(
                            controller: cubit.workflowIdController,
                            hintText: 'workflow id',
                            labelText: 'Workflow ID',
                            obscureText: false,
                          ),
                          verticalSpace(12),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              FilledButton.icon(
                                onPressed: () => _createWorkflow(context),
                                icon: const Icon(Icons.account_tree_outlined),
                                label: const Text('Create'),
                                style: _filledActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _getWorkflow(context),
                                icon: const Icon(Icons.search_rounded),
                                label: const Text('Get'),
                                style: _outlinedActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _approveWorkflow(context),
                                icon: const Icon(Icons.verified_outlined),
                                label: const Text('Approve'),
                                style: _outlinedActionButtonStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (workflow != null) ...[
                      verticalSpace(14),
                      _ResultPublicationCard(
                        child: Text(
                          const JsonEncoder.withIndent(
                            '  ',
                          ).convert(workflow.toJson()),
                          style: AppTextStyles.font11DarkGreyLight.copyWith(
                            color: AppColors.primaryColor9,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                    verticalSpace(14),
                    if (status != null)
                      _PublicationStatusCard(status: status.data),
                    if (published != null) ...[
                      if (status != null) verticalSpace(14),
                      _PublishedResultCard(result: published.data),
                    ],
                    if (status == null &&
                        published == null &&
                        workflow == null) ...[
                      TenantAdminEmptyState(
                        icon: Icons.publish_outlined,
                        title: 'No session loaded',
                        message:
                            'Enter a session id to check or publish a result.',
                      ),
                    ],
                  ],
                ),
                if (isLoading)
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 14.h,
                    child: _ResultPublicationActionBanner(state: state),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _listenToState(BuildContext context, ResultPublicationState state) {
    state.maybeWhen(
      published: (_) {
        showAppSnackBar(context, 'Result published successfully');
        _checkStatus(context);
      },
      statusError: (error) => showAppSnackBar(context, error),
      publishError: (error) => showAppSnackBar(context, error),
      workflowLoaded: (_) => showAppSnackBar(context, 'Workflow updated'),
      workflowError: (error) => showAppSnackBar(context, error),
      orElse: () {},
    );
  }

  void _checkStatus(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final sessionId = cubit.sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    cubit.getResultPublicationStatus(sessionId);
  }

  void _publishResult(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final sessionId = cubit.sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    cubit.publishSessionResult(sessionId);
  }

  void _createWorkflow(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final resourceId = cubit.workflowResourceIdController.text.trim();
    if (resourceId.isEmpty) {
      showAppSnackBar(context, 'Enter resource id first');
      return;
    }

    cubit.createApprovalWorkflow(
      CreateApprovalWorkflowRequestBody(
        resourceType: 'assessment_result',
        resourceId: resourceId,
        workflowType: 'result_publication',
      ),
    );
  }

  void _getWorkflow(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final workflowId = cubit.workflowIdController.text.trim();
    if (workflowId.isEmpty) {
      showAppSnackBar(context, 'Enter workflow id first');
      return;
    }

    cubit.getApprovalWorkflow(workflowId);
  }

  void _approveWorkflow(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final workflowId = cubit.workflowIdController.text.trim();
    if (workflowId.isEmpty) {
      showAppSnackBar(context, 'Enter workflow id first');
      return;
    }

    cubit.approveWorkflow(workflowId);
  }
}

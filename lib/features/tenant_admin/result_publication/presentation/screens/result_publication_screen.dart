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
import 'package:eae_mobile/core/constants/app_strings.dart';

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
            final examWorkflow = cubit.examPublicationWorkflowResponse;
            final publishedExam = cubit.publishedExamResponse;
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
                      AppStrings.tr('Result publication'),
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
                            hintText: AppStrings.tr('exam session id'),
                            labelText: AppStrings.tr('Session ID'),
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
                                label: Text(AppStrings.tr('Status')),
                                style: _filledActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _publishResult(context),
                                icon: const Icon(Icons.publish_outlined),
                                label: Text(AppStrings.tr('Publish')),
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
                            AppStrings.tr('Approval workflow'),
                            style: AppTextStyles.font14DarkGreySemiBold
                                .copyWith(color: AppColors.primaryColor9),
                          ),
                          verticalSpace(12),
                          TextFieldWidget(
                            controller: cubit.workflowResourceIdController,
                            hintText: AppStrings.tr(
                              'assessment result resource id',
                            ),
                            labelText: AppStrings.tr('Resource ID'),
                            obscureText: false,
                          ),
                          verticalSpace(12),
                          TextFieldWidget(
                            controller: cubit.workflowIdController,
                            hintText: AppStrings.tr('workflow id'),
                            labelText: AppStrings.tr('Workflow ID'),
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
                                label: Text(AppStrings.tr('Create')),
                                style: _filledActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _getWorkflow(context),
                                icon: const Icon(Icons.search_rounded),
                                label: Text(AppStrings.tr('Get')),
                                style: _outlinedActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _approveWorkflow(context),
                                icon: const Icon(Icons.verified_outlined),
                                label: Text(AppStrings.tr('Approve')),
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
                            AppStrings.tr('Exam publication workflow'),
                            style: AppTextStyles.font14DarkGreySemiBold
                                .copyWith(color: AppColors.primaryColor9),
                          ),
                          verticalSpace(8),
                          Text(
                            AppStrings.tr(
                              'Approval and exam publish are separate backend calls.',
                            ),
                            style: AppTextStyles.font11DarkGreyLight.copyWith(
                              color: AppColors.tertiaryColor6,
                              height: 1.4,
                            ),
                          ),
                          verticalSpace(12),
                          TextFieldWidget(
                            controller: cubit.examWorkflowExamIdController,
                            hintText: AppStrings.tr('exam id'),
                            labelText: AppStrings.tr('Exam ID'),
                            obscureText: false,
                          ),
                          verticalSpace(12),
                          TextFieldWidget(
                            controller: cubit.examWorkflowIdController,
                            hintText: AppStrings.tr('workflow id'),
                            labelText: AppStrings.tr('Workflow ID'),
                            obscureText: false,
                          ),
                          verticalSpace(12),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              FilledButton.icon(
                                onPressed: () => _createExamWorkflow(context),
                                icon: const Icon(Icons.account_tree_outlined),
                                label: Text(AppStrings.tr('Create')),
                                style: _filledActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _getExamWorkflow(context),
                                icon: const Icon(Icons.search_rounded),
                                label: Text(AppStrings.tr('Get')),
                                style: _outlinedActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _approveExamWorkflow(context),
                                icon: const Icon(Icons.verified_outlined),
                                label: Text(AppStrings.tr('Approve')),
                                style: _outlinedActionButtonStyle(),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _publishApprovedExam(context),
                                icon: const Icon(Icons.publish_outlined),
                                label: Text(AppStrings.tr('Publish exam')),
                                style: _outlinedActionButtonStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (examWorkflow != null) ...[
                      verticalSpace(14),
                      _ResultPublicationCard(
                        child: Text(
                          const JsonEncoder.withIndent(
                            '  ',
                          ).convert(examWorkflow.toJson()),
                          style: AppTextStyles.font11DarkGreyLight.copyWith(
                            color: AppColors.primaryColor9,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                    if (publishedExam != null) ...[
                      verticalSpace(14),
                      _ResultPublicationCard(
                        child: Text(
                          'Published exam: ${publishedExam.data.examName}',
                          style: AppTextStyles.font12DarkGreyRegular.copyWith(
                            color: AppColors.primaryColor9,
                          ),
                        ),
                      ),
                    ],
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
                        workflow == null &&
                        examWorkflow == null &&
                        publishedExam == null) ...[
                      TenantAdminEmptyState(
                        icon: Icons.publish_outlined,
                        title: AppStrings.tr('No session loaded'),
                        message: AppStrings.tr(
                          'Enter a session id to check or publish a result.',
                        ),
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
      examPublished: (_) =>
          showAppSnackBar(context, 'Exam published successfully'),
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

  void _createExamWorkflow(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final examId = cubit.examWorkflowExamIdController.text.trim();
    if (examId.isEmpty) {
      showAppSnackBar(context, 'Enter exam id first');
      return;
    }

    cubit.createExamPublicationWorkflow(examId);
  }

  void _getExamWorkflow(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final workflowId = cubit.examWorkflowIdController.text.trim();
    if (workflowId.isEmpty) {
      showAppSnackBar(context, 'Enter workflow id first');
      return;
    }

    cubit.getExamPublicationWorkflow(workflowId);
  }

  void _approveExamWorkflow(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final workflowId = cubit.examWorkflowIdController.text.trim();
    if (workflowId.isEmpty) {
      showAppSnackBar(context, 'Enter workflow id first');
      return;
    }

    cubit.approveExamPublicationWorkflow(workflowId);
  }

  void _publishApprovedExam(BuildContext context) {
    final cubit = context.read<ResultPublicationCubit>();
    final examId = cubit.examWorkflowExamIdController.text.trim();
    if (examId.isEmpty) {
      showAppSnackBar(context, 'Enter exam id first');
      return;
    }

    cubit.publishApprovedExam(examId);
  }
}

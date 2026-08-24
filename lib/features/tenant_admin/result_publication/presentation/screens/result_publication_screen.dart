import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/searchable_entity_picker.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../../../exam_sessions/data/repos/exam_sessions_repo.dart';
import '../../data/models/result_publication_request_body.dart';
import '../../data/models/result_publication_response.dart';
import '../../logic/result_publication_cubit.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

part '../widgets/result_publication_widgets.dart';

class ResultPublicationScreen extends StatefulWidget {
  const ResultPublicationScreen({super.key});

  @override
  State<ResultPublicationScreen> createState() =>
      _ResultPublicationScreenState();
}

class _ResultPublicationScreenState extends State<ResultPublicationScreen> {
  late final Future<List<EntityPickerOption>> _completedSessionOptions;

  @override
  void initState() {
    super.initState();
    _completedSessionOptions = _completedSessions();
  }

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
            final publicationStatus = status?.data;
            final workflowStatus = cubit
                .resultPublicationWorkflow
                ?.currentWorkflowStatus
                .toLowerCase();
            final isAlreadyPublished =
                publicationStatus?.publicationStatus.toLowerCase() ==
                'published';
            final canPublish =
                publicationStatus?.resultStatus.toLowerCase() == 'final' &&
                workflowStatus == 'approved';
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
                          FutureBuilder<List<EntityPickerOption>>(
                            future: _completedSessionOptions,
                            builder: (context, snapshot) =>
                                SearchableEntityPicker(
                                  label: AppStrings.tr('Session ID'),
                                  value: cubit.sessionIdController.text.isEmpty
                                      ? null
                                      : cubit.sessionIdController.text,
                                  options: snapshot.data ?? const [],
                                  isLoading:
                                      snapshot.connectionState ==
                                      ConnectionState.waiting,
                                  onChanged: (id) =>
                                      cubit.sessionIdController.text = id ?? '',
                                ),
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
                                onPressed: canPublish
                                    ? () => _publishResult(context)
                                    : null,
                                icon: const Icon(Icons.publish_outlined),
                                label: Text(
                                  AppStrings.tr(
                                    isAlreadyPublished
                                        ? 'Issue Certificate'
                                        : 'Publish',
                                  ),
                                ),
                                style: _outlinedActionButtonStyle(),
                              ),
                            ],
                          ),
                          if (publicationStatus != null) ...[
                            verticalSpace(10),
                            Text(
                              AppStrings.tr(
                                canPublish
                                    ? 'The result is approved for publication.'
                                    : _publicationGuardMessage(
                                        publicationStatus,
                                        workflowStatus,
                                      ),
                              ),
                              style: AppTextStyles.font12DarkGreyRegular
                                  .copyWith(color: AppColors.tertiaryColor7),
                            ),
                          ],
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
                          InputDecorator(
                            decoration: InputDecoration(
                              labelText: AppStrings.tr('Resource ID'),
                            ),
                            child: Text(
                              cubit.workflowResourceIdController.text.isEmpty
                                  ? AppStrings.tr(
                                      'Load publication status first',
                                    )
                                  : AppStrings.tr('Result loaded for workflow'),
                            ),
                          ),
                          verticalSpace(12),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              FilledButton.icon(
                                onPressed:
                                    cubit
                                        .workflowResourceIdController
                                        .text
                                        .isEmpty
                                    ? null
                                    : () => _createWorkflow(context),
                                icon: const Icon(Icons.account_tree_outlined),
                                label: Text(AppStrings.tr('Create')),
                                style: _filledActionButtonStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (workflow != null) ...[
                      verticalSpace(14),
                      _ApprovalWorkflowSummaryCard(response: workflow),
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

  Future<List<EntityPickerOption>> _completedSessions() async {
    final response = await getIt<ExamSessionsRepo>().getExamSessions(
      status: 'completed',
      perPage: 100,
    );
    return response.data
        .map(
          (session) => EntityPickerOption(
            id: session.sessionId,
            label: AppStrings.tr('Completed session'),
            subtitle: session.timestamps.endedAt ?? session.state,
          ),
        )
        .toList();
  }

  void _listenToState(BuildContext context, ResultPublicationState state) {
    state.maybeWhen(
      published: (_) {
        showAppSnackBar(
          context,
          AppStrings.tr('Result published successfully'),
        );
        _checkStatus(context);
      },
      statusError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      publishError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
      workflowLoaded: (_) =>
          showAppSnackBar(context, AppStrings.tr('Workflow updated')),
      workflowError: (error) => showAppSnackBar(context, AppStrings.tr(error)),
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
      showAppSnackBar(context, 'Load publication status first');
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

  String _publicationGuardMessage(
    ResultPublicationStatus status,
    String? workflowStatus,
  ) {
    if (status.resultStatus.toLowerCase() != 'final') {
      return 'Only final results can be published.';
    }
    if (workflowStatus == 'pending') {
      return 'Result publication approval is still pending.';
    }
    if (workflowStatus == 'rejected') {
      return 'Result publication request was rejected.';
    }
    return 'Create the result publication workflow first.';
  }
}

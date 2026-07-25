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
import '../../data/models/result_publication_response.dart';
import '../../logic/result_publication_cubit.dart';

class ResultPublicationScreen extends StatefulWidget {
  const ResultPublicationScreen({super.key});

  @override
  State<ResultPublicationScreen> createState() =>
      _ResultPublicationScreenState();
}

class _ResultPublicationScreenState extends State<ResultPublicationScreen> {
  final TextEditingController _sessionIdController = TextEditingController();

  ResultPublicationStatusResponse? _statusResponse;
  ResultPublicationResponse? _publishedResponse;

  @override
  void dispose() {
    _sessionIdController.dispose();
    super.dispose();
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
            final status =
                _statusResponse ?? cubit.resultPublicationStatusResponse;
            final published =
                _publishedResponse ?? cubit.resultPublicationResponse;
            final isLoading = state.maybeWhen(
              statusLoading: () => true,
              publishLoading: () => true,
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
                      style: AppTextStyles.font20DarkGreyBold,
                    ),
                    verticalSpace(12),
                    _ResultPublicationCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldWidget(
                            controller: _sessionIdController,
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
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _publishResult(context),
                                icon: const Icon(Icons.publish_outlined),
                                label: const Text('Publish'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(14),
                    if (status != null)
                      _PublicationStatusCard(status: status.data),
                    if (published != null) ...[
                      if (status != null) verticalSpace(14),
                      _PublishedResultCard(result: published.data),
                    ],
                    if (status == null && published == null) ...[
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
      statusLoaded: (response) => _statusResponse = response,
      published: (response) {
        _publishedResponse = response;
        showAppSnackBar(context, 'Result published successfully');
        _checkStatus(context);
      },
      statusError: (error) => showAppSnackBar(context, error),
      publishError: (error) => showAppSnackBar(context, error),
      orElse: () {},
    );
  }

  void _checkStatus(BuildContext context) {
    final sessionId = _sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    context.read<ResultPublicationCubit>().getResultPublicationStatus(
      sessionId,
    );
  }

  void _publishResult(BuildContext context) {
    final sessionId = _sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    context.read<ResultPublicationCubit>().publishSessionResult(sessionId);
  }
}

class _PublicationStatusCard extends StatelessWidget {
  final ResultPublicationStatus status;

  const _PublicationStatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return _ResultPublicationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Publication status', style: AppTextStyles.font16DarkGreyBold),
          verticalSpace(10),
          TenantAdminCopyableValueRow(
            label: 'Result ID',
            value: status.resultId ?? '-',
          ),
          TenantAdminCopyableValueRow(
            label: 'Result status',
            value: status.resultStatus,
          ),
          TenantAdminCopyableValueRow(
            label: 'Publication status',
            value: status.publicationStatus,
          ),
          TenantAdminCopyableValueRow(
            label: 'Published at',
            value: status.publishedAt ?? '-',
          ),
          TenantAdminCopyableValueRow(
            label: 'Calculated at',
            value: status.resultCalculatedAt ?? '-',
          ),
        ],
      ),
    );
  }
}

class _PublishedResultCard extends StatelessWidget {
  final PublishedSessionResult result;

  const _PublishedResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final summary = result.summary;

    return _ResultPublicationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Published result', style: AppTextStyles.font16DarkGreyBold),
          verticalSpace(10),
          TenantAdminCopyableValueRow(
            label: 'Result ID',
            value: result.resultId,
          ),
          TenantAdminCopyableValueRow(
            label: 'Candidate ID',
            value: result.candidateId,
          ),
          TenantAdminCopyableValueRow(label: 'Exam ID', value: result.examId),
          TenantAdminCopyableValueRow(
            label: 'Status',
            value:
                '${result.status.resultStatus} / ${result.status.publicationStatus}',
          ),
          TenantAdminCopyableValueRow(
            label: 'Grade',
            value:
                '${summary.gradeLetter ?? '-'} - ${summary.percentage}% (${summary.rawScore}/${summary.maxScore})',
          ),
          TenantAdminCopyableValueRow(
            label: 'Pending evaluations',
            value: '${summary.totals.pendingEvaluations}',
          ),
        ],
      ),
    );
  }
}

class _ResultPublicationCard extends StatelessWidget {
  final Widget child;

  const _ResultPublicationCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: child,
    );
  }
}

class _ResultPublicationActionBanner extends StatelessWidget {
  final ResultPublicationState state;

  const _ResultPublicationActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      statusLoading: () => 'Checking publication status...',
      publishLoading: () => 'Publishing result...',
      orElse: () => 'Working...',
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryColor9,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: AppSkeletonBox(height: 18.h, borderRadius: 9),
            ),
            horizontalSpace(10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.neutralColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

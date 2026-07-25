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
import '../../data/models/manual_evaluation_request_body.dart';
import '../../data/models/manual_evaluation_response.dart';
import '../../logic/manual_evaluation_cubit.dart';

class ManualEvaluationScreen extends StatefulWidget {
  const ManualEvaluationScreen({super.key});

  @override
  State<ManualEvaluationScreen> createState() => _ManualEvaluationScreenState();
}

class _ManualEvaluationScreenState extends State<ManualEvaluationScreen> {
  final TextEditingController _sessionIdController = TextEditingController();
  final TextEditingController _evaluationIdController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _maxScoreController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  PendingEvaluationsResponse? _pendingResponse;
  ResultPublicationStatusResponse? _statusResponse;
  ResultPublicationResponse? _publishedResponse;

  @override
  void dispose() {
    _sessionIdController.dispose();
    _evaluationIdController.dispose();
    _scoreController.dispose();
    _maxScoreController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<ManualEvaluationCubit, ManualEvaluationState>(
          listener: _listenToState,
          builder: (context, state) {
            final cubit = context.read<ManualEvaluationCubit>();
            final pending =
                _pendingResponse ?? cubit.pendingEvaluationsResponse;
            final status =
                _statusResponse ?? cubit.resultPublicationStatusResponse;
            final published =
                _publishedResponse ?? cubit.resultPublicationResponse;
            final isLoading = state.maybeWhen(
              pendingLoading: () => true,
              scoreLoading: () => true,
              statusLoading: () => true,
              publishLoading: () => true,
              orElse: () => false,
            );
            final loadError = state.maybeWhen(
              pendingError: (error) => error,
              orElse: () => null,
            );

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async => _loadPending(context),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 18.h,
                    ),
                    children: [
                      _ManualEvaluationHeader(
                        pendingCount: pending?.data.length ?? 0,
                        publicationStatus: status?.data.publicationStatus,
                      ),
                      verticalSpace(16),
                      _SessionActionsCard(
                        sessionIdController: _sessionIdController,
                        onLoadPending: () => _loadPending(context),
                        onCheckStatus: () => _checkStatus(context),
                        onPublish: () => _publishResult(context),
                      ),
                      verticalSpace(14),
                      _ScoreFormCard(
                        evaluationIdController: _evaluationIdController,
                        scoreController: _scoreController,
                        maxScoreController: _maxScoreController,
                        commentsController: _commentsController,
                        onSubmit: () => _submitScore(context),
                      ),
                      verticalSpace(14),
                      if (status != null)
                        _PublicationStatusCard(status: status.data),
                      if (published != null) ...[
                        if (status != null) verticalSpace(14),
                        _PublishedResultCard(result: published.data),
                      ],
                      if (status != null || published != null)
                        verticalSpace(14),
                      _PendingEvaluationsSection(
                        response: pending,
                        isLoading: pending == null && isLoading,
                        loadError: pending == null ? loadError : null,
                        onRetry: () => _loadPending(context),
                        onSelect: _selectEvaluation,
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 14.h,
                    child: _ManualEvaluationActionBanner(state: state),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _listenToState(BuildContext context, ManualEvaluationState state) {
    state.maybeWhen(
      pendingLoaded: (response) => _pendingResponse = response,
      statusLoaded: (response) => _statusResponse = response,
      published: (response) {
        _publishedResponse = response;
        showAppSnackBar(context, 'Result published successfully');
        _checkStatus(context);
      },
      scoreSubmitted: (_) {
        showAppSnackBar(context, 'Evaluation score submitted successfully');
        _loadPending(context);
        _checkStatus(context);
      },
      pendingError: (error) => showAppSnackBar(context, error),
      scoreError: (error) => showAppSnackBar(context, error),
      statusError: (error) => showAppSnackBar(context, error),
      publishError: (error) => showAppSnackBar(context, error),
      orElse: () {},
    );
  }

  void _loadPending(BuildContext context) {
    final sessionId = _sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    context.read<ManualEvaluationCubit>().getPendingEvaluations(sessionId);
  }

  void _checkStatus(BuildContext context) {
    final sessionId = _sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    context.read<ManualEvaluationCubit>().getResultPublicationStatus(sessionId);
  }

  void _publishResult(BuildContext context) {
    final sessionId = _sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    context.read<ManualEvaluationCubit>().publishSessionResult(sessionId);
  }

  void _submitScore(BuildContext context) {
    final evaluationId = _evaluationIdController.text.trim();
    final score = num.tryParse(_scoreController.text.trim());
    final maxScore = num.tryParse(_maxScoreController.text.trim());
    if (evaluationId.isEmpty || score == null || maxScore == null) {
      showAppSnackBar(context, 'Enter evaluation id, score, and max score');
      return;
    }

    final comments = _commentsController.text
        .split('\n')
        .map((comment) => comment.trim())
        .where((comment) => comment.isNotEmpty)
        .toList();

    context.read<ManualEvaluationCubit>().scoreEvaluation(
      evaluationId,
      ScoreEvaluationRequestBody(
        scoreAwarded: score,
        maxScorePossible: maxScore,
        evaluatorComments: comments,
      ),
    );
  }

  void _selectEvaluation(PendingEvaluationItem evaluation) {
    _evaluationIdController.text = evaluation.id ?? '';
    final maxScore = evaluation.maxScorePossible;
    if (maxScore != null) {
      _maxScoreController.text = '$maxScore';
    }
  }
}

class _ManualEvaluationHeader extends StatelessWidget {
  final int pendingCount;
  final String? publicationStatus;

  const _ManualEvaluationHeader({
    required this.pendingCount,
    required this.publicationStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryColor9,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.fact_check_outlined, color: AppColors.neutralColor),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manual evaluation',
                  style: AppTextStyles.font20DarkGreyBold.copyWith(
                    color: AppColors.neutralColor,
                  ),
                ),
                verticalSpace(4),
                Text(
                  '$pendingCount pending - ${publicationStatus ?? 'status not loaded'}',
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.neutralColor.withValues(alpha: 0.78),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionActionsCard extends StatelessWidget {
  final TextEditingController sessionIdController;
  final VoidCallback onLoadPending;
  final VoidCallback onCheckStatus;
  final VoidCallback onPublish;

  const _SessionActionsCard({
    required this.sessionIdController,
    required this.onLoadPending,
    required this.onCheckStatus,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return _EvaluationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Session', style: AppTextStyles.font16DarkGreyBold),
          verticalSpace(12),
          TextFieldWidget(
            controller: sessionIdController,
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
                onPressed: onLoadPending,
                icon: const Icon(Icons.pending_actions_outlined),
                label: const Text('Pending'),
              ),
              OutlinedButton.icon(
                onPressed: onCheckStatus,
                icon: const Icon(Icons.verified_outlined),
                label: const Text('Status'),
              ),
              FilledButton.icon(
                onPressed: onPublish,
                icon: const Icon(Icons.publish_outlined),
                label: const Text('Publish'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreFormCard extends StatelessWidget {
  final TextEditingController evaluationIdController;
  final TextEditingController scoreController;
  final TextEditingController maxScoreController;
  final TextEditingController commentsController;
  final VoidCallback onSubmit;

  const _ScoreFormCard({
    required this.evaluationIdController,
    required this.scoreController,
    required this.maxScoreController,
    required this.commentsController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return _EvaluationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Score evaluation', style: AppTextStyles.font16DarkGreyBold),
          verticalSpace(12),
          TextFieldWidget(
            controller: evaluationIdController,
            hintText: 'answer evaluation id',
            labelText: 'Evaluation ID',
            obscureText: false,
          ),
          verticalSpace(10),
          Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  controller: scoreController,
                  hintText: '1',
                  labelText: 'Score',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: TextFieldWidget(
                  controller: maxScoreController,
                  hintText: '1',
                  labelText: 'Max score',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          TextFieldWidget(
            controller: commentsController,
            hintText: 'One comment per line',
            labelText: 'Evaluator comments',
            obscureText: false,
            maxLines: 3,
          ),
          verticalSpace(12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onSubmit,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Submit score'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingEvaluationsSection extends StatelessWidget {
  final PendingEvaluationsResponse? response;
  final bool isLoading;
  final String? loadError;
  final VoidCallback onRetry;
  final ValueChanged<PendingEvaluationItem> onSelect;

  const _PendingEvaluationsSection({
    required this.response,
    required this.isLoading,
    required this.loadError,
    required this.onRetry,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppSkeletonDataList(
        itemCount: 4,
        showDescription: true,
        chipCount: 2,
        showActionButton: true,
      );
    }

    if (loadError != null) {
      return SizedBox(
        height: 240.h,
        child: AppRetryErrorView(
          title: loadError!,
          message: 'Check the session id and try again.',
          onRetry: onRetry,
        ),
      );
    }

    final items = response?.data;
    if (items == null) {
      return _EmptyEvaluationState(
        title: 'Load a session',
        message: 'Enter a session id to fetch pending manual evaluations.',
      );
    }

    if (items.isEmpty) {
      return _EmptyEvaluationState(
        title: 'No pending evaluations',
        message: 'This session has no pending manual grading items.',
      );
    }

    return Column(
      children: items
          .map(
            (evaluation) => _PendingEvaluationCard(
              evaluation: evaluation,
              onSelect: () => onSelect(evaluation),
            ),
          )
          .toList(),
    );
  }
}

class _PendingEvaluationCard extends StatelessWidget {
  final PendingEvaluationItem evaluation;
  final VoidCallback onSelect;

  const _PendingEvaluationCard({
    required this.evaluation,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final metadata = evaluation.evaluationMetadata;

    return _EvaluationCard(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  evaluation.id ?? 'Evaluation',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
              ),
              horizontalSpace(8),
              _StatusChip(label: evaluation.evaluationStatus ?? 'pending'),
            ],
          ),
          verticalSpace(10),
          _InfoLine(label: 'Question', value: evaluation.questionId ?? '-'),
          _InfoLine(label: 'Type', value: evaluation.evaluationType ?? '-'),
          _InfoLine(
            label: 'Score',
            value:
                '${evaluation.scoreAwarded ?? '-'} / ${evaluation.maxScorePossible ?? '-'}',
          ),
          if (metadata != null && metadata.isNotEmpty)
            _InfoLine(label: 'Metadata', value: _prettyJson(metadata)),
          verticalSpace(10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSelect,
              icon: const Icon(Icons.edit_note_outlined),
              label: const Text('Use for scoring'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PublicationStatusCard extends StatelessWidget {
  final ResultPublicationStatus status;

  const _PublicationStatusCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return _EvaluationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Publication status', style: AppTextStyles.font16DarkGreyBold),
          verticalSpace(10),
          _InfoLine(label: 'Result ID', value: status.resultId ?? '-'),
          _InfoLine(label: 'Result', value: status.resultStatus),
          _InfoLine(label: 'Publication', value: status.publicationStatus),
          _InfoLine(label: 'Published at', value: status.publishedAt ?? '-'),
          _InfoLine(
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

    return _EvaluationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Published result', style: AppTextStyles.font16DarkGreyBold),
          verticalSpace(10),
          _InfoLine(label: 'Result ID', value: result.resultId),
          _InfoLine(
            label: 'Status',
            value:
                '${result.status.resultStatus} / ${result.status.publicationStatus}',
          ),
          _InfoLine(
            label: 'Grade',
            value:
                '${summary.gradeLetter ?? '-'} - ${summary.percentage}% (${summary.rawScore}/${summary.maxScore})',
          ),
          _InfoLine(
            label: 'Pending evaluations',
            value: '${summary.totals.pendingEvaluations}',
          ),
          _InfoLine(
            label: 'Published at',
            value: result.timestamps.publishedAt ?? '-',
          ),
        ],
      ),
    );
  }
}

class _EvaluationCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const _EvaluationCard({required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
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

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor2.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.font12DarkGreySemiBold.copyWith(
          color: AppColors.primaryColor9,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          ),
          verticalSpace(3),
          SelectableText(
            value,
            style: AppTextStyles.font13DarkGreyMedium.copyWith(
              color: AppColors.primaryColor9,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyEvaluationState extends StatelessWidget {
  final String title;
  final String message;

  const _EmptyEvaluationState({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            color: AppColors.tertiaryColor6,
            size: 34.sp,
          ),
          verticalSpace(10),
          Text(title, style: AppTextStyles.font14DarkGreySemiBold),
          verticalSpace(6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ManualEvaluationActionBanner extends StatelessWidget {
  final ManualEvaluationState state;

  const _ManualEvaluationActionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      pendingLoading: () => 'Loading pending evaluations...',
      scoreLoading: () => 'Submitting score...',
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

String _prettyJson(Map<String, dynamic> value) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(value);
}

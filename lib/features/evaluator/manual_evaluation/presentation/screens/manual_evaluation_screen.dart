import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../data/models/manual_evaluation_request_body.dart';
import '../../data/models/manual_evaluation_response.dart';
import '../../logic/manual_evaluation_cubit.dart';

part '../widgets/manual_evaluation_widgets.dart';

class ManualEvaluationScreen extends StatelessWidget {
  const ManualEvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<ManualEvaluationCubit, ManualEvaluationState>(
          listener: _listenToState,
          builder: (context, state) {
            final cubit = context.read<ManualEvaluationCubit>();
            final pending = cubit.pendingEvaluationsResponse;
            final status = cubit.resultPublicationStatusResponse;
            final published = cubit.resultPublicationResponse;
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
                        sessionIdController: cubit.sessionIdController,
                        onLoadPending: () => _loadPending(context),
                        onCheckStatus: () => _checkStatus(context),
                        onPublish: () => _publishResult(context),
                      ),
                      verticalSpace(14),
                      _ScoreFormCard(
                        evaluationIdController: cubit.evaluationIdController,
                        scoreController: cubit.scoreController,
                        maxScoreController: cubit.maxScoreController,
                        commentsController: cubit.commentsController,
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
                        onSelect: cubit.selectEvaluation,
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
      published: (_) {
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
    final cubit = context.read<ManualEvaluationCubit>();
    final sessionId = cubit.sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    cubit.getPendingEvaluations(sessionId);
  }

  void _checkStatus(BuildContext context) {
    final cubit = context.read<ManualEvaluationCubit>();
    final sessionId = cubit.sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    cubit.getResultPublicationStatus(sessionId);
  }

  void _publishResult(BuildContext context) {
    final cubit = context.read<ManualEvaluationCubit>();
    final sessionId = cubit.sessionIdController.text.trim();
    if (sessionId.isEmpty) {
      showAppSnackBar(context, 'Enter session id first');
      return;
    }
    cubit.publishSessionResult(sessionId);
  }

  void _submitScore(BuildContext context) {
    final cubit = context.read<ManualEvaluationCubit>();
    final evaluationId = cubit.evaluationIdController.text.trim();
    final score = num.tryParse(cubit.scoreController.text.trim());
    final maxScore = num.tryParse(cubit.maxScoreController.text.trim());
    if (evaluationId.isEmpty || score == null || maxScore == null) {
      showAppSnackBar(context, 'Enter evaluation id, score, and max score');
      return;
    }

    final comments = cubit.commentsController.text
        .split('\n')
        .map((comment) => comment.trim())
        .where((comment) => comment.isNotEmpty)
        .toList();

    cubit.scoreEvaluation(
      evaluationId,
      ScoreEvaluationRequestBody(
        scoreAwarded: score,
        maxScorePossible: maxScore,
        evaluatorComments: comments,
      ),
    );
  }
}

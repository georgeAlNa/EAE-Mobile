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
      published: (_) {
        showAppSnackBar(context, 'Result published successfully');
        _checkStatus(context);
      },
      statusError: (error) => showAppSnackBar(context, error),
      publishError: (error) => showAppSnackBar(context, error),
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
}

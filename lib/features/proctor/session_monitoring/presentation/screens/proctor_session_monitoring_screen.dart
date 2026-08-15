import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../logic/proctor_session_cubit.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class ProctorSessionMonitoringScreen extends StatelessWidget {
  final String? initialSessionId;

  const ProctorSessionMonitoringScreen({super.key, this.initialSessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<ProctorSessionCubit, ProctorSessionState>(
          listener: (context, state) {
            state.maybeWhen(
              actionSuccess: (message) => _showSnack(context, message),
              error: (error) => _showSnack(context, error),
              orElse: () {},
            );
          },
          builder: (context, state) {
            final cubit = context.read<ProctorSessionCubit>();
            if (initialSessionId != null &&
                initialSessionId!.isNotEmpty &&
                cubit.sessionIdController.text != initialSessionId) {
              cubit.sessionIdController.text = initialSessionId!;
            }
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );
            final output = state.maybeWhen(
              sanctionsLoaded: (response) =>
                  const JsonEncoder.withIndent('  ').convert(response.toJson()),
              eventsLoaded: (response) =>
                  const JsonEncoder.withIndent('  ').convert(response.toJson()),
              actionSuccess: (message) => message,
              error: (error) => error,
              orElse: () => '',
            );

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tr('Proctor Session Monitoring'),
                    style: AppTextStyles.font20DarkGreyBold.copyWith(
                      color: AppColors.primaryColor9,
                    ),
                  ),
                  verticalSpace(6),
                  Text(
                    AppStrings.tr(
                      'Control exam sessions and inspect sanctions or proctoring events.',
                    ),
                    style: AppTextStyles.font12DarkGreyRegular.copyWith(
                      color: AppColors.tertiaryColor6,
                      height: 1.4,
                    ),
                  ),
                  verticalSpace(18),
                  _TextInput(
                    controller: cubit.sessionIdController,
                    label: AppStrings.tr('Session ID'),
                    icon: Icons.confirmation_number_outlined,
                  ),
                  verticalSpace(14),
                  _ActionGrid(
                    isLoading: isLoading,
                    actions: [
                      _ProctorAction(
                        label: AppStrings.tr('Suspend'),
                        icon: Icons.pause_circle_outline,
                        onTap: cubit.suspendExamSession,
                      ),
                      _ProctorAction(
                        label: AppStrings.tr('Resume'),
                        icon: Icons.play_circle_outline,
                        onTap: cubit.resumeExamSession,
                      ),
                      _ProctorAction(
                        label: AppStrings.tr('Terminate'),
                        icon: Icons.stop_circle_outlined,
                        onTap: cubit.terminateExamSession,
                      ),
                      _ProctorAction(
                        label: AppStrings.tr('Sanctions'),
                        icon: Icons.gavel_outlined,
                        onTap: cubit.getSessionSanctions,
                      ),
                      _ProctorAction(
                        label: AppStrings.tr('Events'),
                        icon: Icons.visibility_outlined,
                        onTap: cubit.getProctoringEvents,
                      ),
                    ],
                  ),
                  verticalSpace(18),
                  Text(
                    AppStrings.tr('Void Sanction'),
                    style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                      color: AppColors.primaryColor9,
                    ),
                  ),
                  verticalSpace(10),
                  _TextInput(
                    controller: cubit.sanctionIdController,
                    label: AppStrings.tr('Sanction ID'),
                    icon: Icons.rule_outlined,
                  ),
                  verticalSpace(10),
                  _TextInput(
                    controller: cubit.voidReasonController,
                    label: AppStrings.tr('Reason'),
                    icon: Icons.edit_note_outlined,
                  ),
                  verticalSpace(10),
                  _WideButton(
                    label: AppStrings.tr('Void Sanction'),
                    icon: Icons.cancel_outlined,
                    enabled: !isLoading,
                    onTap: cubit.voidSanction,
                  ),
                  verticalSpace(18),
                  Text(
                    AppStrings.tr('Submit Proctoring Event'),
                    style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                      color: AppColors.primaryColor9,
                    ),
                  ),
                  verticalSpace(10),
                  _TextInput(
                    controller: cubit.eventTypeController,
                    label: AppStrings.tr('Event Type'),
                    icon: Icons.event_note_outlined,
                  ),
                  verticalSpace(10),
                  _TextInput(
                    controller: cubit.eventCategoryController,
                    label: AppStrings.tr('Event Category'),
                    icon: Icons.category_outlined,
                  ),
                  verticalSpace(10),
                  _WideButton(
                    label: AppStrings.tr('Submit Event'),
                    icon: Icons.send_outlined,
                    enabled: !isLoading,
                    onTap: cubit.submitProctoringEvent,
                  ),
                  if (isLoading) ...[
                    verticalSpace(18),
                    const Center(child: CircularProgressIndicator()),
                  ],
                  if (output.isNotEmpty) ...[
                    verticalSpace(18),
                    _OutputPanel(output: output),
                  ],
                  verticalSpace(24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    if (message.trim().isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}

class _TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _TextInput({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  final bool isLoading;
  final List<_ProctorAction> actions;

  const _ActionGrid({required this.isLoading, required this.actions});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 2.8,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return _WideButton(
          label: action.label,
          icon: action.icon,
          enabled: !isLoading,
          onTap: action.onTap,
        );
      },
    );
  }
}

class _WideButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _WideButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.primaryColor10 : AppColors.tertiaryColor3,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.sp, color: AppColors.white),
              horizontalSpace(8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12WhiteSemiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutputPanel extends StatelessWidget {
  final String output;

  const _OutputPanel({required this.output});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor5,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Text(
        output,
        style: AppTextStyles.font11DarkGreyLight.copyWith(
          color: AppColors.primaryColor9,
          height: 1.4,
        ),
      ),
    );
  }
}

class _ProctorAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ProctorAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

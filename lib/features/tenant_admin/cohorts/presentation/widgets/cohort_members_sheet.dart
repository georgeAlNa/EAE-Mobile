import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/custom_dropdown.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../data/models/cohorts_request_body.dart';
import '../../data/models/cohorts_response.dart';
import '../../logic/cohorts_cubit.dart';

class CohortMembersSheet extends StatefulWidget {
  final String cohortId;
  final String cohortName;

  const CohortMembersSheet({
    super.key,
    required this.cohortId,
    required this.cohortName,
  });

  @override
  State<CohortMembersSheet> createState() => _CohortMembersSheetState();
}

class _CohortMembersSheetState extends State<CohortMembersSheet> {
  List<CohortMember>? _members;

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'Cohort members',
      subtitle: widget.cohortName,
      child: BlocConsumer<CohortsCubit, CohortsState>(
        listener: (context, state) {
          state.maybeWhen(
            cohortMembersLoaded: (response) {
              _members = response.data;
            },
            addCohortMemberSuccess: (_) {
              context.read<CohortsCubit>().getCohortMembers(widget.cohortId);
            },
            removeCohortMemberSuccess: (_) {
              context.read<CohortsCubit>().getCohortMembers(widget.cohortId);
            },
            cohortMembersError: (error) => showAppSnackBar(context, error),
            orElse: () {},
          );
        },
        builder: (context, state) {
          final loaded = state.whenOrNull(
            cohortMembersLoaded: (response) => response.data,
          );
          if (loaded != null) {
            _members = loaded;
          }

          final members = _members;
          final isMembersLoading = state.maybeWhen(
            cohortMembersLoading: () => true,
            orElse: () => false,
          );
          final isActionLoading = state.maybeWhen(
            addCohortMemberLoading: () => true,
            removeCohortMemberLoading: () => true,
            orElse: () => false,
          );
          final loadError = state.maybeWhen(
            cohortMembersError: (error) => error,
            orElse: () => null,
          );

          if (members == null && isMembersLoading) {
            return Column(
              children: [
                AppSkeletonBox(width: double.infinity, height: 44.h),
                verticalSpace(14),
                AppSkeletonBox(width: double.infinity, height: 62.h),
                verticalSpace(10),
                AppSkeletonBox(width: double.infinity, height: 62.h),
              ],
            );
          }

          if (members == null) {
            return SizedBox(
              height: 220.h,
              child: AppRetryErrorView(
                title: loadError ?? 'Unable to load cohort members',
                message: 'Check the connection and try again.',
                onRetry: () => context.read<CohortsCubit>().getCohortMembers(
                  widget.cohortId,
                ),
              ),
            );
          }

          return Column(
            children: [
              if (isMembersLoading || isActionLoading) ...[
                AppSkeletonBox(
                  width: double.infinity,
                  height: 4.h,
                  borderRadius: 2,
                ),
                verticalSpace(12),
              ],
              _MembersContent(
                cohortId: widget.cohortId,
                members: members,
                isActionLoading: isActionLoading,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MembersContent extends StatelessWidget {
  final String cohortId;
  final List<CohortMember> members;
  final bool isActionLoading;

  const _MembersContent({
    required this.cohortId,
    required this.members,
    required this.isActionLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonWidget(
          title: 'Add Member',
          width: double.infinity,
          radius: 8.r,
          backgroundColor: AppColors.secondaryColor7,
          textStyle: AppTextStyles.font14DarkGreySemiBold.copyWith(
            color: AppColors.neutralColor,
          ),
          onTap: isActionLoading ? () {} : () => _showAddMemberSheet(context),
        ),
        verticalSpace(16),
        if (members.isEmpty)
          Text(
            'No members available',
            style: AppTextStyles.font14DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          )
        else
          ...members.asMap().entries.map(
            (entry) => _AnimatedMemberTile(
              index: entry.key,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _MemberTile(
                  cohortId: cohortId,
                  member: entry.value,
                  enabled: !isActionLoading,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showAddMemberSheet(BuildContext context) async {
    final cubit = context.read<CohortsCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddCohortMemberSheet(cohortId: cohortId),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final String cohortId;
  final CohortMember member;
  final bool enabled;

  const _MemberTile({
    required this.cohortId,
    required this.member,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TenantAdminCopyableValueRow(
                  label: 'User ID',
                  value: member.userId,
                ),
                TenantAdminCopyableValueRow(
                  label: 'Membership role',
                  value: member.membershipRole,
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          IconButton.outlined(
            tooltip: 'Remove member',
            onPressed: enabled
                ? () {
                    context.read<CohortsCubit>().removeCohortMember(
                      cohortId,
                      member.userId,
                    );
                  }
                : null,
            icon: const Icon(Icons.person_remove_outlined),
            style: IconButton.styleFrom(foregroundColor: AppColors.redWarring),
          ),
        ],
      ),
    );
  }
}

class _AnimatedMemberTile extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedMemberTile({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(index),
      duration: Duration(milliseconds: 220 + (index * 35).clamp(0, 180)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12.h),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class AddCohortMemberSheet extends StatefulWidget {
  final String cohortId;

  const AddCohortMemberSheet({super.key, required this.cohortId});

  @override
  State<AddCohortMemberSheet> createState() => _AddCohortMemberSheetState();
}

class _AddCohortMemberSheetState extends State<AddCohortMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  String? _membershipRole = 'member';

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'Add member',
      subtitle: 'Attach a user to this cohort.',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFieldWidget(
              controller: _userIdController,
              hintText: 'user UUID',
              labelText: 'User ID',
              obscureText: false,
            ),
            verticalSpace(12),
            CustomDropdown(
              items: const ['member', 'leader', 'manager', 'observer'],
              value: _membershipRole,
              hintText: 'Membership role',
              onChanged: (value) => setState(() => _membershipRole = value),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            verticalSpace(20),
            ButtonWidget(
              title: 'Add Member',
              width: double.infinity,
              radius: 8.r,
              backgroundColor: AppColors.secondaryColor7,
              textStyle: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.neutralColor,
              ),
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_userIdController.text.trim().isEmpty ||
        (_membershipRole ?? '').isEmpty) {
      showAppSnackBar(context, 'Please fill all required fields');
      return;
    }

    context.read<CohortsCubit>().addCohortMember(
      widget.cohortId,
      AddCohortMemberRequestBody(
        userId: _userIdController.text.trim(),
        membershipRole: _membershipRole!,
      ),
    );
    Navigator.pop(context);
  }
}

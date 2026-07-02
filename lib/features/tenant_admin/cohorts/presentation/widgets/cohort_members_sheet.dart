import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/button_widget.dart';
import '../../../../../core/public_widgets/custom_dropdown.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../../../core/public_widgets/text_field_widget.dart';
import '../../../users_management/presentation/widgets/users_management_sheet_scaffold.dart';
import '../../data/models/cohorts_request_body.dart';
import '../../data/models/cohorts_response.dart';
import '../../logic/cohorts_cubit.dart';

class CohortMembersSheet extends StatelessWidget {
  final String cohortId;
  final String cohortName;

  const CohortMembersSheet({
    super.key,
    required this.cohortId,
    required this.cohortName,
  });

  @override
  Widget build(BuildContext context) {
    return UsersManagementSheetScaffold(
      title: 'Cohort members',
      subtitle: cohortName,
      child: BlocBuilder<CohortsCubit, CohortsState>(
        builder: (context, state) {
          final members = state.maybeWhen(
            membersLoaded: (response) => response.data,
            orElse: () => null,
          );
          final error = state.maybeWhen(
            error: (error) => error,
            orElse: () => null,
          );

          if (error != null) {
            return Text(
              error,
              style: AppTextStyles.font14DarkGreyRegular.copyWith(
                color: AppColors.redWarring,
              ),
            );
          }

          if (members == null) {
            return SizedBox(height: 180.h, child: const LoadingWidget());
          }

          return _MembersContent(cohortId: cohortId, members: members);
        },
      ),
    );
  }
}

class _MembersContent extends StatelessWidget {
  final String cohortId;
  final List<CohortMember> members;

  const _MembersContent({required this.cohortId, required this.members});

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
          onTap: () => _showAddMemberSheet(context),
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
          ...members.map(
            (member) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _MemberTile(cohortId: cohortId, member: member),
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

    cubit.getCohortMembers(cohortId);
  }
}

class _MemberTile extends StatelessWidget {
  final String cohortId;
  final CohortMember member;

  const _MemberTile({required this.cohortId, required this.member});

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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.userId,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                  ),
                ),
                verticalSpace(4),
                Text(
                  member.membershipRole,
                  style: AppTextStyles.font12DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
              ],
            ),
          ),
          IconButton.outlined(
            tooltip: 'Remove member',
            onPressed: () {
              context.read<CohortsCubit>().removeCohortMember(
                cohortId,
                member.userId,
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.person_remove_outlined),
            style: IconButton.styleFrom(foregroundColor: AppColors.redWarring),
          ),
        ],
      ),
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

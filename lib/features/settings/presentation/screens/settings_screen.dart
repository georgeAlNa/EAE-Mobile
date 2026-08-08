import 'package:eae_mobile/core/constants/colors.dart';
import 'package:eae_mobile/core/constants/text_styles.dart';
import 'package:eae_mobile/core/helpers/spacing.dart';
import 'package:eae_mobile/core/public_widgets/app_state_widgets.dart';
import 'package:eae_mobile/core/routing/routes.dart';
import 'package:eae_mobile/features/settings/data/models/settings_response.dart';
import 'package:eae_mobile/features/settings/logic/settings_cubit.dart';
import 'package:eae_mobile/features/settings/presentation/widgets/settings_form_fields.dart';
import 'package:eae_mobile/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) {
        final hasMessage = current.maybeWhen(
          ready: (_, _, _, _, _, message) => message != null,
          orElse: () => false,
        );
        final isLoggedOut = current.maybeWhen(
          loggedOut: () => true,
          orElse: () => false,
        );
        return hasMessage || isLoggedOut;
      },
      listener: (context, state) {
        state.whenOrNull(
          ready: (_, _, _, _, _, message) {
            if (message == null) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          loggedOut: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.roleSelectionScreen,
              (route) => false,
            );
          },
        );
      },
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return state.when(
            loading: () => const _SettingsLoadingView(),
            error: (error) => _SettingsErrorState(error: error),
            loggedOut: () => const SizedBox.shrink(),
            ready:
                (
                  profile,
                  permissions,
                  sessions,
                  isSaving,
                  isActionLoading,
                  message,
                ) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<SettingsCubit>().loadAccount(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 18.h,
                      ),
                      children: [
                        const _AccountHeader(),
                        verticalSpace(18),
                        _ProfileSummaryCard(profile: profile),
                        verticalSpace(18),
                        _ProfileFormCard(profile: profile, isSaving: isSaving),
                        verticalSpace(18),
                        _AccessCard(permissions: permissions),
                        verticalSpace(18),
                        _SessionsCard(
                          sessions: sessions,
                          isActionLoading: isActionLoading,
                        ),
                        verticalSpace(18),
                        _SystemStatusCard(isActionLoading: isActionLoading),
                        verticalSpace(18),
                        _AccountActionsCard(isActionLoading: isActionLoading),
                        verticalSpace(24),
                      ],
                    ),
                  );
                },
          );
        },
      ),
    );
  }
}

class _SystemStatusCard extends StatelessWidget {
  final bool isActionLoading;

  const _SystemStatusCard({required this.isActionLoading});

  @override
  Widget build(BuildContext context) {
    final status = context.read<SettingsCubit>().systemStatus;

    return SettingsSectionCard(
      title: 'System Status',
      icon: Icons.health_and_safety_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status == null)
            Text(
              'No system status loaded.',
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            )
          else ...[
            _DetailPill(
              label: 'Status',
              value: status.status,
              icon: Icons.check_circle_outline,
              valueColor: status.status == 'ok'
                  ? AppColors.secondaryColor7
                  : AppColors.tertiaryColor6,
            ),
            verticalSpace(10),
            _DetailPill(
              label: 'Database',
              value: status.database,
              icon: Icons.storage_outlined,
              valueColor: AppColors.primaryColor9,
            ),
            verticalSpace(10),
            _DetailPill(
              label: 'Timestamp',
              value: _formatDate(status.timestamp),
              icon: Icons.schedule_rounded,
              valueColor: AppColors.primaryColor9,
            ),
          ],
          verticalSpace(12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isActionLoading
                  ? null
                  : context.read<SettingsCubit>().loadSystemStatus,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh System Status'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.tertiaryColor2),
                foregroundColor: AppColors.primaryColor9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsLoadingView extends StatelessWidget {
  const _SettingsLoadingView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<SettingsCubit>().loadAccount(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        children: [
          const _AccountHeader(),
          verticalSpace(18),
          const _ProfileSummarySkeleton(),
          verticalSpace(18),
          const _ProfileFormSkeleton(),
          verticalSpace(18),
          const _AccessSkeleton(),
          verticalSpace(18),
          const _SessionsSkeleton(),
          verticalSpace(18),
          const _AccountActionsSkeleton(),
          verticalSpace(24),
        ],
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Account',
                style: AppTextStyles.font32DarkGreyMedium.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
            ),
            IconButton.filled(
              tooltip: 'Refresh account',
              onPressed: () => context.read<SettingsCubit>().loadAccount(),
              icon: const Icon(Icons.refresh_rounded),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondaryColor7,
                foregroundColor: AppColors.neutralColor,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        Text(
          'Manage your profile, access permissions, and active sessions.',
          style: AppTextStyles.font14DarkGreyRegular.copyWith(
            color: AppColors.tertiaryColor6,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ProfileSummarySkeleton extends StatelessWidget {
  const _ProfileSummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          AppSkeletonBox(width: 68.w, height: 68.w),
          verticalSpace(12),
          AppSkeletonBox(width: 170.w, height: 18.h),
          verticalSpace(8),
          AppSkeletonBox(width: 220.w, height: 12.h),
          verticalSpace(16),
          Row(
            children: [
              Expanded(child: AppSkeletonBox(height: 58.h)),
              SizedBox(width: 12.w),
              Expanded(child: AppSkeletonBox(height: 58.h)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  final SettingsProfileData profile;

  const _ProfileSummaryCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        children: [
          Container(
            width: 68.w,
            height: 68.w,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor2,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(profile),
              style: AppTextStyles.font20DarkGreyBold.copyWith(
                color: AppColors.secondaryColor7,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          verticalSpace(12),
          Text(
            profile.fullName.isEmpty ? profile.email : profile.fullName,
            textAlign: TextAlign.center,
            style: AppTextStyles.font17DarkGreySemiBold.copyWith(
              color: AppColors.primaryColor9,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpace(4),
          Text(
            profile.email,
            textAlign: TextAlign.center,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
              height: 1.45,
            ),
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: _DetailPill(
                  label: 'Status',
                  value: profile.status,
                  icon: Icons.verified_user_outlined,
                  valueColor: profile.isActive
                      ? AppColors.secondaryColor7
                      : AppColors.tertiaryColor6,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _DetailPill(
                  label: 'Last login',
                  value: _formatDate(profile.lastLoginAt),
                  icon: Icons.schedule_rounded,
                  valueColor: AppColors.primaryColor9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileFormSkeleton extends StatelessWidget {
  const _ProfileFormSkeleton();

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Profile',
      icon: Icons.badge_outlined,
      child: Column(
        children: [
          const _SettingsFieldSkeleton(labelWidth: 78),
          verticalSpace(14),
          const _SettingsFieldSkeleton(labelWidth: 76),
          verticalSpace(14),
          const _SettingsFieldSkeleton(labelWidth: 142),
          verticalSpace(14),
          const _SettingsFieldSkeleton(labelWidth: 112),
          verticalSpace(16),
          Row(
            children: [
              Expanded(child: AppSkeletonBox(height: 42.h)),
              SizedBox(width: 12.w),
              Expanded(child: AppSkeletonBox(height: 42.h)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileFormCard extends StatelessWidget {
  final SettingsProfileData profile;
  final bool isSaving;

  const _ProfileFormCard({required this.profile, required this.isSaving});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return SettingsSectionCard(
      title: 'Profile',
      icon: Icons.badge_outlined,
      child: Column(
        children: [
          SettingsFieldGroup(
            label: 'First Name',
            child: TextFormField(
              controller: cubit.firstNameController,
              textInputAction: TextInputAction.next,
              decoration: settingsFieldDecoration(),
            ),
          ),
          verticalSpace(14),
          SettingsFieldGroup(
            label: 'Last Name',
            child: TextFormField(
              controller: cubit.lastNameController,
              textInputAction: TextInputAction.next,
              decoration: settingsFieldDecoration(),
            ),
          ),
          verticalSpace(14),
          SettingsFieldGroup(
            label: 'External Employee ID',
            child: TextFormField(
              controller: cubit.externalEmployeeIdController,
              textInputAction: TextInputAction.done,
              decoration: settingsFieldDecoration(),
            ),
          ),
          verticalSpace(14),
          SettingsFieldGroup(
            label: 'Corporate Email',
            child: SettingsReadOnlyField(value: profile.email),
          ),
          verticalSpace(16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSaving ? null : cubit.resetProfileForm,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.tertiaryColor2),
                    foregroundColor: AppColors.primaryColor9,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const Text('Discard'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: isSaving ? null : cubit.updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor7,
                    foregroundColor: AppColors.neutralColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isSaving
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: AppSkeletonBox(height: 18.h, borderRadius: 9),
                        )
                      : const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccessSkeleton extends StatelessWidget {
  const _AccessSkeleton();

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Roles & Permissions',
      icon: Icons.admin_panel_settings_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeletonBox(width: 52.w, height: 10.h),
          verticalSpace(8),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              AppSkeletonBox(width: 72.w, height: 30.h),
              AppSkeletonBox(width: 96.w, height: 30.h),
            ],
          ),
          verticalSpace(16),
          AppSkeletonBox(width: 92.w, height: 10.h),
          verticalSpace(8),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              AppSkeletonBox(width: 110.w, height: 30.h),
              AppSkeletonBox(width: 132.w, height: 30.h),
              AppSkeletonBox(width: 92.w, height: 30.h),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccessCard extends StatelessWidget {
  final SettingsPermissionsData permissions;

  const _AccessCard({required this.permissions});

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Roles & Permissions',
      icon: Icons.admin_panel_settings_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChipWrap(
            title: 'Roles',
            values: permissions.roles,
            emptyLabel: 'No roles assigned',
          ),
          verticalSpace(16),
          _ChipWrap(
            title: 'Permissions',
            values: permissions.permissions,
            emptyLabel: 'No permissions available',
          ),
        ],
      ),
    );
  }
}

class _SessionsSkeleton extends StatelessWidget {
  const _SessionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Active Sessions',
      icon: Icons.devices_other_rounded,
      child: Column(
        children: [
          const AppSkeletonDataCard(
            showDescription: false,
            chipCount: 0,
            infoRowCount: 2,
          ),
          verticalSpace(12),
          AppSkeletonBox(width: double.infinity, height: 42.h),
        ],
      ),
    );
  }
}

class _SessionsCard extends StatelessWidget {
  final List<SettingsSessionData> sessions;
  final bool isActionLoading;

  const _SessionsCard({required this.sessions, required this.isActionLoading});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    final currentSessionId = cubit.currentSessionId;

    return SettingsSectionCard(
      title: 'Active Sessions',
      icon: Icons.devices_other_rounded,
      child: Column(
        children: [
          if (sessions.isEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'No active sessions were returned.',
                style: AppTextStyles.font12DarkGreyRegular.copyWith(
                  color: AppColors.tertiaryColor6,
                ),
              ),
            )
          else
            ...sessions.map(
              (session) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _SessionTile(
                  session: session,
                  isCurrent: session.sessionId == currentSessionId,
                  isActionLoading: isActionLoading,
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isActionLoading ? null : cubit.deleteAllSessions,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Revoke All Sessions'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.tertiaryColor2),
                foregroundColor: AppColors.primaryColor9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final SettingsSessionData session;
  final bool isCurrent;
  final bool isActionLoading;

  const _SessionTile({
    required this.session,
    required this.isCurrent,
    required this.isActionLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor6,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.laptop_mac_rounded,
            size: 20.sp,
            color: AppColors.primaryColor9,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrent ? 'Current session' : session.sessionState,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: AppColors.primaryColor9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${session.ipAddress} - ${session.browserName ?? session.userAgent}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font10DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Last activity ${_formatDate(session.lastActivityAt)}',
                  style: AppTextStyles.font10DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Revoke session',
            onPressed: isActionLoading
                ? null
                : () => context.read<SettingsCubit>().deleteSession(
                    session.sessionId,
                  ),
            icon: Icon(
              Icons.close_rounded,
              size: 18.sp,
              color: AppColors.primaryColor9,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountActionsSkeleton extends StatelessWidget {
  const _AccountActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Session Actions',
      icon: Icons.lock_clock_outlined,
      child: AppSkeletonBox(width: double.infinity, height: 42.h),
    );
  }
}

class _AccountActionsCard extends StatelessWidget {
  final bool isActionLoading;

  const _AccountActionsCard({required this.isActionLoading});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return SettingsSectionCard(
      title: 'Session Actions',
      icon: Icons.lock_clock_outlined,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isActionLoading ? null : cubit.logout,
              icon: const Icon(Icons.exit_to_app_rounded),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.tertiaryColor2),
                foregroundColor: AppColors.primaryColor9,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsFieldSkeleton extends StatelessWidget {
  final double labelWidth;

  const _SettingsFieldSkeleton({required this.labelWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeletonBox(width: labelWidth.w, height: 10.h),
        verticalSpace(8),
        AppSkeletonBox(width: double.infinity, height: 48.h),
      ],
    );
  }
}

class _ChipWrap extends StatelessWidget {
  final String title;
  final List<String> values;
  final String emptyLabel;

  const _ChipWrap({
    required this.title,
    required this.values,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTextStyles.font10DarkGreyRegular.copyWith(
            color: AppColors.primaryColor9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        verticalSpace(8),
        if (values.isEmpty)
          Text(
            emptyLabel,
            style: AppTextStyles.font12DarkGreyRegular.copyWith(
              color: AppColors.tertiaryColor6,
            ),
          )
        else
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: values
                .map(
                  (value) => Chip(
                    label: Text(value),
                    backgroundColor: AppColors.neutralColor6,
                    side: BorderSide(color: AppColors.tertiaryColor2),
                    labelStyle: AppTextStyles.font10DarkGreyRegular.copyWith(
                      color: AppColors.primaryColor9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _DetailPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;

  const _DetailPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.neutralColor6,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: valueColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.font10DarkGreyRegular.copyWith(
                    color: AppColors.tertiaryColor6,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                    color: valueColor,
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

class _SettingsErrorState extends StatelessWidget {
  final String error;

  const _SettingsErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<SettingsCubit>().loadAccount(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        children: [
          const _AccountHeader(),
          verticalSpace(18),
          SizedBox(
            height: 320.h,
            child: AppRetryErrorView(
              title: error,
              message: 'Unable to load account data.',
              onRetry: () => context.read<SettingsCubit>().loadAccount(),
            ),
          ),
        ],
      ),
    );
  }
}

String _initials(SettingsProfileData profile) {
  final first = profile.firstName.isNotEmpty ? profile.firstName[0] : '';
  final last = profile.lastName.isNotEmpty ? profile.lastName[0] : '';
  final initials = '$first$last'.toUpperCase();
  return initials.isEmpty ? 'EA' : initials;
}

String _formatDate(String? value) {
  if (value == null || value.isEmpty) return '-';
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  final local = parsed.toLocal();
  final date =
      '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  final time =
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  return '$date $time';
}

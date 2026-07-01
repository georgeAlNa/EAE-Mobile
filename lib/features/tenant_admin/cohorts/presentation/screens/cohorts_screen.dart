import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../logic/cohorts_cubit.dart';
import '../widgets/cohort_details_sheet.dart';
import '../widgets/cohort_form_sheet.dart';
import '../widgets/cohort_members_sheet.dart';
import '../widgets/cohorts_header.dart';
import '../widgets/cohorts_list_section.dart';

class CohortsScreen extends StatefulWidget {
  const CohortsScreen({super.key});

  @override
  State<CohortsScreen> createState() => _CohortsScreenState();
}

class _CohortsScreenState extends State<CohortsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<CohortsCubit, CohortsState>(
          listener: (context, state) {
            state.maybeWhen(
              saveSuccess: (_) {
                showAppSnackBar(context, 'Cohort saved successfully');
                context.read<CohortsCubit>().getCohorts();
              },
              memberSaveSuccess: (_) {
                showAppSnackBar(context, 'Member added successfully');
                context.read<CohortsCubit>().getCohorts();
              },
              actionSuccess: (_) {
                showAppSnackBar(context, 'Action completed successfully');
                context.read<CohortsCubit>().getCohorts();
              },
              error: (error) => showAppSnackBar(context, error),
              orElse: () {},
            );
          },
          builder: (screenContext, state) {
            final cohorts = state.maybeWhen(
              loaded: (response) => response.data,
              orElse: () => null,
            );
            final isLoading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            if (cohorts == null && isLoading) {
              return const LoadingWidget();
            }

            if (cohorts == null) {
              return _CohortsErrorView(
                onRetry: screenContext.read<CohortsCubit>().getCohorts,
              );
            }

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: screenContext.read<CohortsCubit>().getCohorts,
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 18.h,
                    ),
                    children: [
                      CohortsHeader(
                        onCreateCohort: () => _showCreateCohortSheet(
                          screenContext,
                        ),
                      ),
                      verticalSpace(18),
                      CohortsListSection(
                        cohorts: cohorts,
                        onDetails: (cohort) => _showCohortDetailsSheet(
                          context: screenContext,
                          cohortId: cohort.id,
                        ),
                        onEdit: (cohort) => _showUpdateCohortSheet(
                          context: screenContext,
                          cohortId: cohort.id,
                          cohortName: cohort.cohortName,
                          cohortCode: cohort.cohortCode,
                          cohortType: cohort.cohortType,
                          cohortDescription: cohort.cohortDescription,
                          isActive: cohort.isActive,
                        ),
                        onMembers: (cohort) => _showCohortMembersSheet(
                          context: screenContext,
                          cohortId: cohort.id,
                          cohortName: cohort.cohortName,
                        ),
                        onDelete: (cohort) => _confirmDeleteCohort(
                          context: screenContext,
                          cohortId: cohort.id,
                          cohortName: cohort.cohortName,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: ColoredBox(
                      color: AppColors.neutralColor.withValues(alpha: 0.65),
                      child: const LoadingWidget(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showCreateCohortSheet(BuildContext context) async {
    final cubit = context.read<CohortsCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const CohortFormSheet(),
      ),
    );
  }

  Future<void> _showUpdateCohortSheet({
    required BuildContext context,
    required String cohortId,
    required String cohortName,
    required String cohortCode,
    required String cohortType,
    required String cohortDescription,
    required bool isActive,
  }) async {
    final cubit = context.read<CohortsCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CohortFormSheet(
          cohortId: cohortId,
          initialCohortName: cohortName,
          initialCohortCode: cohortCode,
          initialCohortType: cohortType,
          initialCohortDescription: cohortDescription,
          initialIsActive: isActive,
        ),
      ),
    );
  }

  Future<void> _showCohortDetailsSheet({
    required BuildContext context,
    required String cohortId,
  }) async {
    final cubit = context.read<CohortsCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit..getCohortDetails(cohortId),
        child: const CohortDetailsSheet(),
      ),
    );

    cubit.getCohorts();
  }

  Future<void> _showCohortMembersSheet({
    required BuildContext context,
    required String cohortId,
    required String cohortName,
  }) async {
    final cubit = context.read<CohortsCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit..getCohortMembers(cohortId),
        child: CohortMembersSheet(cohortId: cohortId, cohortName: cohortName),
      ),
    );

    cubit.getCohorts();
  }

  Future<void> _confirmDeleteCohort({
    required BuildContext context,
    required String cohortId,
    required String cohortName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete cohort'),
        content: Text('Delete $cohortName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      context.read<CohortsCubit>().deleteCohort(cohortId);
    }
  }
}

class _CohortsErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _CohortsErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unable to load cohorts',
              textAlign: TextAlign.center,
              style: AppTextStyles.font14DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor7,
              ),
            ),
            verticalSpace(16),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                  color: AppColors.secondaryColor7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

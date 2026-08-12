import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../data/models/cohorts_response.dart';
import '../../logic/cohorts_cubit.dart';
import '../widgets/cohort_details_sheet.dart';
import '../widgets/cohort_form_sheet.dart';
import '../widgets/cohort_members_sheet.dart';
import '../widgets/cohorts_header.dart';
import '../widgets/cohorts_list_section.dart';
import 'package:eae_mobile/core/constants/app_strings.dart';

class CohortsScreen extends StatefulWidget {
  const CohortsScreen({super.key});

  @override
  State<CohortsScreen> createState() => _CohortsScreenState();
}

class _CohortsScreenState extends State<CohortsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  CohortsResponse? _cohortsResponse;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child: BlocConsumer<CohortsCubit, CohortsState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (response) {
                _cohortsResponse = response;
              },
              createCohortSuccess: (_) {
                showAppSnackBar(context, 'Cohort created successfully');
                context.read<CohortsCubit>().getCohorts();
              },
              updateCohortSuccess: (_) {
                showAppSnackBar(context, 'Cohort updated successfully');
                context.read<CohortsCubit>().getCohorts();
              },
              deleteCohortSuccess: (_) {
                showAppSnackBar(context, 'Cohort deleted successfully');
                context.read<CohortsCubit>().getCohorts();
              },
              addCohortMemberSuccess: (_) {
                showAppSnackBar(context, 'Member added successfully');
                context.read<CohortsCubit>().getCohorts();
              },
              removeCohortMemberSuccess: (_) {
                showAppSnackBar(context, 'Member removed successfully');
                context.read<CohortsCubit>().getCohorts();
              },
              createCohortError: (error) => showAppSnackBar(context, error),
              updateCohortError: (error) => showAppSnackBar(context, error),
              deleteCohortError: (error) => showAppSnackBar(context, error),
              addCohortMemberError: (error) => showAppSnackBar(context, error),
              removeCohortMemberError: (error) =>
                  showAppSnackBar(context, error),
              orElse: () {},
            );
          },
          builder: (screenContext, state) {
            final loadedResponse = state.whenOrNull(
              loaded: (response) => response,
            );

            if (loadedResponse != null) {
              _cohortsResponse = loadedResponse;
            }

            final cohorts = _cohortsResponse?.data;
            final isCohortsLoading = state.maybeWhen(
              loadingCohorts: () => true,
              orElse: () => false,
            );
            final isActionLoading = state.maybeWhen(
              createCohortLoading: () => true,
              updateCohortLoading: () => true,
              deleteCohortLoading: () => true,
              addCohortMemberLoading: () => true,
              removeCohortMemberLoading: () => true,
              orElse: () => false,
            );
            final loadError = state.maybeWhen(
              loadError: (error) => error,
              orElse: () => null,
            );

            final visibleCohorts = cohorts == null
                ? null
                : _filterCohorts(cohorts);

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: screenContext.read<CohortsCubit>().getCohorts,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: ListView(
                      key: ValueKey('${visibleCohorts?.length}-$_query'),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 18.h,
                      ),
                      children: [
                        CohortsHeader(
                          totalCohorts: cohorts?.length,
                          activeCohorts: cohorts
                              ?.where((cohort) => cohort.isActive)
                              .length,
                          searchController: _searchController,
                          onCreateCohort: () =>
                              _showCreateCohortSheet(screenContext),
                        ),
                        verticalSpace(18),
                        _CohortsDataSection(
                          cohorts: visibleCohorts,
                          query: _query,
                          isLoading: cohorts == null && isCohortsLoading,
                          loadError: cohorts == null ? loadError : null,
                          onRetry: screenContext
                              .read<CohortsCubit>()
                              .getCohorts,
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
                ),
                if (isCohortsLoading && cohorts != null && cohorts.isNotEmpty)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AppSkeletonBox(
                      width: double.infinity,
                      height: 4.h,
                      borderRadius: 0,
                    ),
                  ),
                if (isActionLoading)
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 14.h,
                    child: _CohortActionProgressBanner(state: state),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<CohortItem> _filterCohorts(List<CohortItem> cohorts) {
    if (_query.isEmpty) return cohorts;

    return cohorts.where((cohort) {
      return cohort.cohortName.toLowerCase().contains(_query) ||
          cohort.cohortCode.toLowerCase().contains(_query) ||
          cohort.cohortType.toLowerCase().contains(_query) ||
          cohort.cohortDescription.toLowerCase().contains(_query);
    }).toList();
  }

  Future<void> _showCreateCohortSheet(BuildContext context) async {
    final cubit = context.read<CohortsCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const CohortFormSheet()),
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
        child: CohortDetailsSheet(cohortId: cohortId),
      ),
    );
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
  }

  Future<void> _confirmDeleteCohort({
    required BuildContext context,
    required String cohortId,
    required String cohortName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.tr('Delete cohort')),
        content: Text(AppStrings.deleteItem(cohortName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.tr('Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.tr('Delete')),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      context.read<CohortsCubit>().deleteCohort(cohortId);
    }
  }
}

class _CohortsDataSection extends StatelessWidget {
  final List<CohortItem>? cohorts;
  final String query;
  final bool isLoading;
  final String? loadError;
  final VoidCallback onRetry;
  final ValueChanged<CohortItem> onDetails;
  final ValueChanged<CohortItem> onEdit;
  final ValueChanged<CohortItem> onMembers;
  final ValueChanged<CohortItem> onDelete;

  const _CohortsDataSection({
    required this.cohorts,
    required this.query,
    required this.isLoading,
    required this.loadError,
    required this.onRetry,
    required this.onDetails,
    required this.onEdit,
    required this.onMembers,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _SectionSkeleton(itemCount: 4);
    }

    if (loadError != null) {
      return SizedBox(
        height: 260.h,
        child: AppRetryErrorView(
          title: loadError!,
          message: AppStrings.tr('Check the connection and try again.'),
          onRetry: onRetry,
        ),
      );
    }

    return CohortsListSection(
      cohorts: cohorts ?? const <CohortItem>[],
      query: query,
      onDetails: onDetails,
      onEdit: onEdit,
      onMembers: onMembers,
      onDelete: onDelete,
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  final int itemCount;

  const _SectionSkeleton({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonDataList(
      itemCount: itemCount,
      showDescription: true,
      chipCount: 2,
    );
  }
}

class _CohortActionProgressBanner extends StatelessWidget {
  final CohortsState state;

  const _CohortActionProgressBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      createCohortLoading: () => 'Creating cohort...',
      updateCohortLoading: () => 'Updating cohort...',
      deleteCohortLoading: () => 'Deleting cohort...',
      addCohortMemberLoading: () => 'Adding member...',
      removeCohortMemberLoading: () => 'Removing member...',
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

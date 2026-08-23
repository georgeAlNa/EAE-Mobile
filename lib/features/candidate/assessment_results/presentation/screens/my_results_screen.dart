import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../logic/my_results_cubit.dart';

class MyResultsScreen extends StatelessWidget {
  const MyResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      appBar: AppBar(
        backgroundColor: AppColors.neutralColor,
        foregroundColor: AppColors.primaryColor9,
        elevation: 0,
        title: Text(AppStrings.tr('My Results')),
        actions: [
          IconButton(
            tooltip: AppStrings.tr('Refresh'),
            onPressed: context.read<MyResultsCubit>().refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<MyResultsCubit, MyResultsState>(
          builder: (context, state) {
            if (state is MyResultsLoading || state is MyResultsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = (state as MyResultsLoaded).items;
            return RefreshIndicator(
              onRefresh: context.read<MyResultsCubit>().refresh,
              child: items.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(24.w),
                      children: [
                        SizedBox(height: 160.h),
                        Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 52.sp,
                          color: AppColors.tertiaryColor5,
                        ),
                        verticalSpace(16),
                        Text(
                          AppStrings.tr('No completed assessment results yet.'),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.font14DarkGreyRegular.copyWith(
                            color: AppColors.tertiaryColor6,
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 24.h),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => verticalSpace(12),
                      itemBuilder: (_, index) =>
                          _ResultCard(item: items[index]),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final MyResultItem item;

  const _ResultCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final result = item.result;
    final title = item.history.title.trim().isEmpty
        ? AppStrings.tr('Completed assessment')
        : item.history.title;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.tertiaryColor2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.font16DarkGreyBold.copyWith(
              color: AppColors.primaryColor9,
            ),
          ),
          verticalSpace(12),
          if (result == null)
            _PendingResult()
          else ...[
            _InfoRow(
              label: AppStrings.tr('Result Status'),
              value: AppStrings.displayValue(result.status.resultStatus),
            ),
            _InfoRow(
              label: AppStrings.tr('Publication Status'),
              value: AppStrings.displayValue(result.status.publicationStatus),
            ),
            _InfoRow(
              label: AppStrings.tr('Score'),
              value: '${result.summary.rawScore} / ${result.summary.maxScore}',
            ),
            _InfoRow(
              label: AppStrings.tr('Percentage'),
              value: '${result.summary.percentage}%',
            ),
            if (result.summary.gradeLetter?.trim().isNotEmpty ?? false)
              _InfoRow(
                label: AppStrings.tr('Grade'),
                value: result.summary.gradeLetter!,
              ),
            _InfoRow(
              label: AppStrings.tr('Pending Evaluations'),
              value: result.summary.totals.pendingEvaluations.toString(),
              includeBottomPadding: false,
            ),
          ],
        ],
      ),
    );
  }
}

class _PendingResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.hourglass_empty_rounded,
          color: AppColors.secondaryColor7,
          size: 22.sp,
        ),
        horizontalSpace(10),
        Expanded(
          child: Text(
            AppStrings.tr('Result pending or unavailable'),
            style: AppTextStyles.font12DarkGreySemiBold.copyWith(
              color: AppColors.tertiaryColor7,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool includeBottomPadding;

  const _InfoRow({
    required this.label,
    required this.value,
    this.includeBottomPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: includeBottomPadding ? 8.h : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.font11DarkGreyLight.copyWith(
                color: AppColors.tertiaryColor6,
              ),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              style: AppTextStyles.font11DarkGreyLight.copyWith(
                color: AppColors.primaryColor9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

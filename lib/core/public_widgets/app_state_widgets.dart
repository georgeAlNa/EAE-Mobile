import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_strings.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../helpers/spacing.dart';

class AppSkeletonBox extends StatefulWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppSkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  State<AppSkeletonBox> createState() => _AppSkeletonBoxState();
}

class _AppSkeletonBoxState extends State<AppSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final alignment = Alignment(-1.6 + (_controller.value * 3.2), 0);

        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.15, 0.45, 0.75],
              colors: [
                AppColors.tertiaryColor2.withValues(alpha: 0.45),
                AppColors.surface,
                AppColors.tertiaryColor2.withValues(alpha: 0.45),
              ],
              transform: _SlidingGradientTransform(alignment.x),
            ),
          ),
        );
      },
    );
  }
}

class AppSkeletonListView extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final int itemCount;
  final double itemHeight;
  final bool showHeader;

  const AppSkeletonListView({
    super.key,
    this.padding,
    this.itemCount = 5,
    this.itemHeight = 118,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
      itemCount: itemCount + (showHeader ? 1 : 0),
      separatorBuilder: (_, _) => verticalSpace(12),
      itemBuilder: (context, index) {
        if (showHeader && index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeletonBox(width: 190.w, height: 24.h),
              verticalSpace(10),
              AppSkeletonBox(width: double.infinity, height: 46.h),
              verticalSpace(12),
              Row(
                children: [
                  Expanded(child: AppSkeletonBox(height: 64.h)),
                  horizontalSpace(10),
                  Expanded(child: AppSkeletonBox(height: 64.h)),
                ],
              ),
            ],
          );
        }

        return AppSkeletonBox(width: double.infinity, height: itemHeight.h);
      },
    );
  }
}

class AppSkeletonDataList extends StatelessWidget {
  final int itemCount;
  final bool circularAvatar;
  final bool showDescription;
  final int chipCount;
  final int infoRowCount;
  final bool showActionButton;

  const AppSkeletonDataList({
    super.key,
    required this.itemCount,
    this.circularAvatar = false,
    this.showDescription = true,
    this.chipCount = 2,
    this.infoRowCount = 0,
    this.showActionButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => AppSkeletonDataCard(
          margin: EdgeInsets.only(bottom: 12.h),
          circularAvatar: circularAvatar,
          showDescription: showDescription,
          chipCount: chipCount,
          infoRowCount: infoRowCount,
          showActionButton: showActionButton,
        ),
      ),
    );
  }
}

class AppSkeletonDataCard extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final bool circularAvatar;
  final bool showDescription;
  final int chipCount;
  final int infoRowCount;
  final bool showActionButton;

  const AppSkeletonDataCard({
    super.key,
    this.margin,
    this.circularAvatar = false,
    this.showDescription = true,
    this.chipCount = 2,
    this.infoRowCount = 0,
    this.showActionButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSkeletonBox(
                width: 42.w,
                height: 42.w,
                borderRadius: circularAvatar ? 21 : 8,
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeletonBox(width: 150.w, height: 14.h),
                    verticalSpace(6),
                    AppSkeletonBox(width: double.infinity, height: 12.h),
                  ],
                ),
              ),
              horizontalSpace(10),
              AppSkeletonBox(width: 64.w, height: 26.h),
              horizontalSpace(8),
              AppSkeletonBox(width: 28.w, height: 28.w, borderRadius: 14),
            ],
          ),
          if (showDescription) ...[
            verticalSpace(12),
            AppSkeletonBox(width: double.infinity, height: 12.h),
            verticalSpace(6),
            AppSkeletonBox(width: 0.72.sw, height: 12.h),
          ],
          if (infoRowCount > 0) ...[
            verticalSpace(12),
            ...List.generate(
              infoRowCount,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeletonBox(width: 90.w, height: 10.h),
                    verticalSpace(4),
                    AppSkeletonBox(width: double.infinity, height: 12.h),
                  ],
                ),
              ),
            ),
          ],
          if (chipCount > 0) ...[
            verticalSpace(12),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(
                chipCount,
                (index) => AppSkeletonBox(width: 86.w, height: 28.h),
              ),
            ),
          ],
          if (showActionButton) ...[
            verticalSpace(12),
            AppSkeletonBox(width: double.infinity, height: 42.h),
          ],
        ],
      ),
    );
  }
}

class AppSkeletonDetailRows extends StatelessWidget {
  final int rowCount;

  const AppSkeletonDetailRows({super.key, this.rowCount = 8});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        rowCount,
        (index) => Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeletonBox(width: 130.w, height: 11.h),
              verticalSpace(6),
              AppSkeletonBox(width: index.isEven ? 180.w : 110.w, height: 14.h),
            ],
          ),
        ),
      ),
    );
  }
}

class AppRetryErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const AppRetryErrorView({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.icon = Icons.cloud_off_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.tertiaryColor6, size: 38.sp),
            verticalSpace(12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14DarkGreySemiBold.copyWith(
                color: AppColors.primaryColor9,
              ),
            ),
            verticalSpace(6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font12DarkGreyRegular.copyWith(
                color: AppColors.tertiaryColor6,
                height: 1.4,
              ),
            ),
            verticalSpace(16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

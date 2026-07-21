import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                AppColors.neutralColor,
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
              label: const Text('Retry'),
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

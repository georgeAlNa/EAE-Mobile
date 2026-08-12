import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/analytics_models.dart';
import 'analytics_section_card.dart';

class AnalyticsCompetencyCard extends StatelessWidget {
  final String title;
  final String secureProfileLabel;
  final String radarLabelTop;
  final String radarLabelBottom;
  final List<AnalyticsMetric> metrics;
  final List<double> chartValues;

  const AnalyticsCompetencyCard({
    super.key,
    required this.title,
    required this.secureProfileLabel,
    required this.radarLabelTop,
    required this.radarLabelBottom,
    required this.metrics,
    required this.chartValues,
  });

  @override
  Widget build(BuildContext context) {
    return AnalyticsSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.tr(title),
                  style: AppTextStyles.font20DarkGreyBold.copyWith(
                    color: AppColors.primaryColor9,
                    height: 1.15,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor2,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.secondaryColor4),
                ),
                child: Text(
                  AppStrings.tr(secureProfileLabel),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font10DarkGreyRegular.copyWith(
                    color: AppColors.secondaryColor8,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(18),
          Center(
            child: SizedBox(
              height: 246.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: _RadarLabel(
                      label: AppStrings.tr(radarLabelTop),
                      borderColor: AppColors.tertiaryColor2,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: _RadarLabel(
                      label: AppStrings.tr(radarLabelBottom),
                      borderColor: AppColors.tertiaryColor2,
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter: _RadarChartPainter(
                        values: chartValues,
                        borderColor: AppColors.secondaryColor8,
                        fillColor: AppColors.secondaryColor2,
                        gridColor: AppColors.tertiaryColor3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          verticalSpace(12),
          ...List.generate(metrics.length, (index) {
            final metric = metrics[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == metrics.length - 1 ? 0 : 14.h,
              ),
              child: _MetricBar(metric: metric),
            );
          }),
        ],
      ),
    );
  }
}

class _MetricBar extends StatelessWidget {
  final AnalyticsMetric metric;

  const _MetricBar({required this.metric});

  @override
  Widget build(BuildContext context) {
    final percentageText = '${(metric.value * 100).round()}%';
    final progressColor = metric.isAlert
        ? const Color(0xFFDC2626)
        : const Color(0xFF0F766E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                AppStrings.tr(metric.label),
                style: AppTextStyles.font12DarkGreyRegular.copyWith(
                  color: AppColors.primaryColor9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              percentageText,
              style: AppTextStyles.font12DarkGreySemiBold.copyWith(
                color: progressColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: SizedBox(
            height: 6.h,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: AppColors.tertiaryColor2),
                ),
                FractionallySizedBox(
                  widthFactor: metric.value,
                  child: ColoredBox(color: progressColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RadarLabel extends StatelessWidget {
  final String label;
  final Color borderColor;

  const _RadarLabel({required this.label, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.neutralColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: AppTextStyles.font10DarkGreyRegular.copyWith(
          color: AppColors.tertiaryColor6,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<double> values;
  final Color borderColor;
  final Color fillColor;
  final Color gridColor;

  const _RadarChartPainter({
    required this.values,
    required this.borderColor,
    required this.fillColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;
    final axisCount = values.length;
    const levels = 5;

    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var level = 1; level <= levels; level++) {
      final levelRadius = radius * level / levels;
      final polygon = Path();
      for (var axis = 0; axis < axisCount; axis++) {
        final angle = _angleFor(axis, axisCount);
        final point =
            center +
            Offset(
              math.cos(angle) * levelRadius,
              math.sin(angle) * levelRadius,
            );
        if (axis == 0) {
          polygon.moveTo(point.dx, point.dy);
        } else {
          polygon.lineTo(point.dx, point.dy);
        }
      }
      polygon.close();
      canvas.drawPath(polygon, gridPaint);
    }

    for (var axis = 0; axis < axisCount; axis++) {
      final angle = _angleFor(axis, axisCount);
      final point =
          center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      canvas.drawLine(center, point, gridPaint);
    }

    final dataPath = Path();
    for (var axis = 0; axis < axisCount; axis++) {
      final angle = _angleFor(axis, axisCount);
      final pointRadius = radius * values[axis].clamp(0.0, 1.0);
      final point =
          center +
          Offset(math.cos(angle) * pointRadius, math.sin(angle) * pointRadius);
      if (axis == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();

    canvas.drawPath(
      dataPath,
      Paint()
        ..color = fillColor.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    for (var axis = 0; axis < axisCount; axis++) {
      final angle = _angleFor(axis, axisCount);
      final pointRadius = radius * values[axis].clamp(0.0, 1.0);
      final point =
          center +
          Offset(math.cos(angle) * pointRadius, math.sin(angle) * pointRadius);
      canvas.drawCircle(point, 3.6, Paint()..color = borderColor);
    }
  }

  double _angleFor(int axis, int axisCount) {
    return -math.pi / 2 + (2 * math.pi * axis / axisCount);
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.gridColor != gridColor;
  }
}

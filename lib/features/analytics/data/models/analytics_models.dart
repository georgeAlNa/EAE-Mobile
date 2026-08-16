class AnalyticsViewData {
  final int totalFinalizedResults;
  final num averagePercentage;
  final double averageProgress;
  final bool hasFinalizedResults;

  const AnalyticsViewData({
    required this.totalFinalizedResults,
    required this.averagePercentage,
    required this.averageProgress,
    required this.hasFinalizedResults,
  });
}

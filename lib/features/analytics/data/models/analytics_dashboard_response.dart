import 'package:json_annotation/json_annotation.dart';

part 'analytics_dashboard_response.g.dart';

@JsonSerializable()
class AnalyticsDashboardResponse {
  final AnalyticsDashboardData data;

  AnalyticsDashboardResponse({required this.data});

  factory AnalyticsDashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsDashboardResponseToJson(this);
}

@JsonSerializable()
class AnalyticsDashboardData {
  @JsonKey(name: 'total_finalized_results')
  final int totalFinalizedResults;

  @JsonKey(name: 'average_percentage')
  final num averagePercentage;

  AnalyticsDashboardData({
    required this.totalFinalizedResults,
    required this.averagePercentage,
  });

  factory AnalyticsDashboardData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDashboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsDashboardDataToJson(this);
}

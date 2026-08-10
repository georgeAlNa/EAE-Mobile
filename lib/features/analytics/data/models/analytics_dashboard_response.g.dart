// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsDashboardResponse _$AnalyticsDashboardResponseFromJson(
  Map<String, dynamic> json,
) => AnalyticsDashboardResponse(
  data: AnalyticsDashboardData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnalyticsDashboardResponseToJson(
  AnalyticsDashboardResponse instance,
) => <String, dynamic>{'data': instance.data};

AnalyticsDashboardData _$AnalyticsDashboardDataFromJson(
  Map<String, dynamic> json,
) => AnalyticsDashboardData(
  totalFinalizedResults: (json['total_finalized_results'] as num).toInt(),
  averagePercentage: json['average_percentage'] as num,
);

Map<String, dynamic> _$AnalyticsDashboardDataToJson(
  AnalyticsDashboardData instance,
) => <String, dynamic>{
  'total_finalized_results': instance.totalFinalizedResults,
  'average_percentage': instance.averagePercentage,
};

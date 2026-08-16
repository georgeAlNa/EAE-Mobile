import 'package:eae_mobile/features/analytics/data/models/analytics_dashboard_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalyticsDashboardResponse', () {
    test('parses dashboard summary fields with decimal average', () {
      final response = AnalyticsDashboardResponse.fromJson({
        'data': {'total_finalized_results': 3, 'average_percentage': 78.5},
      });

      expect(response.data.totalFinalizedResults, 3);
      expect(response.data.averagePercentage, 78.5);
      expect(response.toJson(), {'data': response.data});
    });

    test('parses zero dashboard as valid data', () {
      final response = AnalyticsDashboardResponse.fromJson({
        'data': {'total_finalized_results': 0, 'average_percentage': 0.0},
      });

      expect(response.data.totalFinalizedResults, 0);
      expect(response.data.averagePercentage, 0.0);
    });

    test('parses integer average safely', () {
      final response = AnalyticsDashboardResponse.fromJson({
        'data': {'total_finalized_results': 4, 'average_percentage': 78},
      });

      expect(response.data.totalFinalizedResults, 4);
      expect(response.data.averagePercentage, 78);
    });
  });
}

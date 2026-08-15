import 'package:eae_mobile/features/analytics/data/models/analytics_dashboard_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalyticsDashboardResponse', () {
    test('parses dashboard summary fields', () {
      final response = AnalyticsDashboardResponse.fromJson({
        'data': {'total_finalized_results': 7, 'average_percentage': 82.5},
      });

      expect(response.data.totalFinalizedResults, 7);
      expect(response.data.averagePercentage, 82.5);
      expect(response.toJson(), {'data': response.data});
    });
  });
}

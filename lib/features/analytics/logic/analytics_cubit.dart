import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/analytics_dashboard_response.dart';
import '../data/models/analytics_models.dart';
import '../data/repos/analytics_repo.dart';

part 'analytics_cubit.freezed.dart';
part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepo analyticsRepo;

  AnalyticsCubit({required this.analyticsRepo})
    : super(const AnalyticsState.loading()) {
    getAnalyticsDashboard();
  }

  Future<void> getAnalyticsDashboard() async {
    emit(const AnalyticsState.loading());

    try {
      final response = await analyticsRepo.analyticsDashboard();
      emit(AnalyticsState.ready(viewData: _mapResponseToViewData(response)));
    } on NetworkExceptions catch (e) {
      emit(AnalyticsState.error(error: NetworkExceptions.getErrorMessage(e)));
    } catch (_) {
      emit(
        const AnalyticsState.error(error: 'Failed to load analytics dashboard'),
      );
    }
  }

  AnalyticsViewData _mapResponseToViewData(
    AnalyticsDashboardResponse response,
  ) {
    final data = response.data;
    final averagePercentage = data.averagePercentage.toDouble();
    final normalizedAverage = (averagePercentage / 100).clamp(0.0, 1.0);

    return AnalyticsViewData(
      title: 'Analytics Dashboard',
      subtitle:
          'Finalized results: ${data.totalFinalizedResults} | Average score: ${averagePercentage.toStringAsFixed(1)}%',
      competencyTitle: 'Competency Metrics',
      secureProfileLabel: 'API\nSYNCED',
      radarLabelTop: 'AVERAGE',
      radarLabelBottom: 'RESULTS',
      chartValues: const [],
      metrics: const [],
      benchmarkingTitle: 'Dashboard Summary',
      benchmarkingSubtitle: 'Values returned by analytics dashboard',
      benchmarks: [
        AnalyticsBenchmark(
          label: 'Finalized Results',
          value: data.totalFinalizedResults.toString(),
        ),
        AnalyticsBenchmark(
          label: 'Average Percentage',
          value: '${averagePercentage.toStringAsFixed(1)}%',
        ),
      ],
      recommendationTitle: '',
      recommendationSubtitle: '',
      recommendationBody: '',
      recommendationActionLabel: '',
      credentialsTitle: 'Earned Credentials',
      exportCertificateLabel: 'EXPORT CERTIFICATE',
      credentials: const [],
      assessmentStatusTitle: 'ASSESSMENT STATUS',
      sessionLabel: 'Average percentage',
      syncedLabel: '${averagePercentage.toStringAsFixed(1)}%',
      statusProgress: normalizedAverage,
      statusNotice: 'Based on finalized assessment results from the backend.',
    );
  }
}

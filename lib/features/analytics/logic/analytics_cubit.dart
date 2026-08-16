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
      emit(const AnalyticsState.error(error: 'Unable to load analytics'));
    }
  }

  AnalyticsViewData _mapResponseToViewData(
    AnalyticsDashboardResponse response,
  ) {
    final data = response.data;
    final averagePercentage = data.averagePercentage.toDouble();
    final normalizedAverage = (averagePercentage / 100).clamp(0.0, 1.0);

    return AnalyticsViewData(
      totalFinalizedResults: data.totalFinalizedResults,
      averagePercentage: data.averagePercentage,
      averageProgress: normalizedAverage,
      hasFinalizedResults: data.totalFinalizedResults > 0,
    );
  }
}

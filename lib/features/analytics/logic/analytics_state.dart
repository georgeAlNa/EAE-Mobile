part of 'analytics_cubit.dart';

@freezed
class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState.loading() = _Loading;

  const factory AnalyticsState.ready({required AnalyticsViewData viewData}) =
      _Ready;

  const factory AnalyticsState.error({required String error}) = _Error;
}

part of 'my_results_cubit.dart';

class MyResultItem {
  final CandidateResultHistoryEntry history;
  final AssessmentResult? result;

  const MyResultItem({required this.history, this.result});
}

abstract class MyResultsState {
  const MyResultsState();

  const factory MyResultsState.initial() = MyResultsInitial;
  const factory MyResultsState.loading() = MyResultsLoading;
  const factory MyResultsState.loaded(List<MyResultItem> items) =
      MyResultsLoaded;
}

class MyResultsInitial extends MyResultsState {
  const MyResultsInitial();
}

class MyResultsLoading extends MyResultsState {
  const MyResultsLoading();
}

class MyResultsLoaded extends MyResultsState {
  final List<MyResultItem> items;

  const MyResultsLoaded(this.items);
}

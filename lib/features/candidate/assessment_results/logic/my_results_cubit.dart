import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/local/candidate_result_history_store.dart';
import '../data/models/assessment_results_response.dart';
import '../data/repos/assessment_results_repo.dart';

part 'my_results_state.dart';

class MyResultsCubit extends Cubit<MyResultsState> {
  final AssessmentResultsRepo assessmentResultsRepo;
  final CandidateResultHistoryStore historyStore;

  MyResultsCubit({
    required this.assessmentResultsRepo,
    required this.historyStore,
  }) : super(const MyResultsState.initial());

  Future<void> loadResults() async {
    emit(const MyResultsState.loading());
    final history = historyStore.loadForCurrentUser();

    final items = await Future.wait(
      history.map((entry) async {
        try {
          final response = await assessmentResultsRepo.getAssessmentResult(
            entry.sessionId,
          );
          return MyResultItem(history: entry, result: response.data);
        } catch (_) {
          return MyResultItem(history: entry);
        }
      }),
    );

    if (!isClosed) {
      emit(MyResultsState.loaded(items));
    }
  }

  Future<void> refresh() => loadResults();
}

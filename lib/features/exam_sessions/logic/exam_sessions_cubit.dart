import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/exam_sessions_list_response.dart';
import '../data/repos/exam_sessions_repo.dart';

part 'exam_sessions_state.dart';

enum ExamSessionsRole { tenantAdmin, proctor, evaluator }

class ExamSessionStatus {
  static const notStarted = 'not_started';
  static const inProgress = 'in_progress';
  static const paused = 'paused';
  static const completed = 'completed';
  static const terminated = 'terminated';

  static const all = <String>{
    notStarted,
    inProgress,
    paused,
    completed,
    terminated,
  };

  static const proctorAllowed = <String>{inProgress, terminated};
}

class ExamSessionsCubit extends Cubit<ExamSessionsState> {
  final ExamSessionsRepo examSessionsRepo;
  final ExamSessionsRole role;

  ExamSessionsCubit({required this.examSessionsRepo, required this.role})
    : super(const ExamSessionsState.initial());

  String? currentStatus;
  String? currentExamId;
  String? currentCandidateId;
  int? currentPerPage;
  int currentPage = 0;
  int lastPage = 1;
  List<ExamSessionListItem> currentSessions = [];
  int _requestGeneration = 0;
  bool _isLoadingInitial = false;
  bool _isLoadingNextPage = false;

  bool get hasMore => currentPage < lastPage;

  Future<void> loadExamSessions({
    String? status,
    String? examId,
    String? candidateId,
    int? perPage,
  }) async {
    final guardedStatus = _guardStatus(status);
    if (guardedStatus == _invalidStatusMarker) return;

    final generation = ++_requestGeneration;
    _isLoadingInitial = true;
    _isLoadingNextPage = false;
    currentStatus = guardedStatus;
    currentExamId = _blankToNull(examId);
    currentCandidateId = _blankToNull(candidateId);
    currentPerPage = perPage;
    currentPage = 0;
    lastPage = 1;
    currentSessions = [];

    emit(const ExamSessionsState.loading());
    await _loadPage(1, append: false, generation: generation);
  }

  Future<void> refresh() async {
    if (_isLoadingInitial) return;
    final generation = ++_requestGeneration;
    _isLoadingNextPage = false;
    currentPage = 0;
    lastPage = 1;
    emit(const ExamSessionsState.refreshing());
    await _loadPage(1, append: false, generation: generation, isRefresh: true);
  }

  Future<void> loadNextPage() async {
    if (_isLoadingInitial || _isLoadingNextPage || !hasMore) return;
    final nextPage = currentPage + 1;
    final generation = _requestGeneration;
    _isLoadingNextPage = true;
    emit(ExamSessionsState.loadingNextPage(currentSessions));
    await _loadPage(nextPage, append: true, generation: generation);
  }

  Future<void> _loadPage(
    int page, {
    required bool append,
    required int generation,
    bool isRefresh = false,
  }) async {
    try {
      final response = await examSessionsRepo.getExamSessions(
        status: currentStatus,
        examId: currentExamId,
        candidateId: currentCandidateId,
        page: page,
        perPage: currentPerPage,
      );

      if (generation != _requestGeneration) return;

      currentPage = response.meta.currentPage;
      lastPage = response.meta.lastPage;
      currentSessions = append
          ? _appendWithoutDuplicates(currentSessions, response.data)
          : response.data;

      emit(
        ExamSessionsState.loaded(
          sessions: currentSessions,
          meta: response.meta,
        ),
      );
    } on NetworkExceptions catch (e) {
      if (generation != _requestGeneration) return;
      final message = NetworkExceptions.getErrorMessage(e);
      emit(
        append
            ? ExamSessionsState.nextPageError(
                sessions: currentSessions,
                error: message,
              )
            : isRefresh
            ? ExamSessionsState.refreshError(
                sessions: currentSessions,
                error: message,
              )
            : ExamSessionsState.error(error: message),
      );
    } catch (e) {
      if (generation != _requestGeneration) return;
      const message = 'Failed to load exam sessions';
      emit(
        append
            ? ExamSessionsState.nextPageError(
                sessions: currentSessions,
                error: message,
              )
            : isRefresh
            ? ExamSessionsState.refreshError(
                sessions: currentSessions,
                error: message,
              )
            : const ExamSessionsState.error(error: message),
      );
    } finally {
      if (generation == _requestGeneration) {
        _isLoadingInitial = false;
        _isLoadingNextPage = false;
      }
    }
  }

  String? _guardStatus(String? status) {
    final value = _blankToNull(status);

    if (role == ExamSessionsRole.tenantAdmin) {
      if (value == null || ExamSessionStatus.all.contains(value)) {
        return value;
      }
      _emitRoleError();
      return _invalidStatusMarker;
    }

    if (role == ExamSessionsRole.proctor) {
      if (value == null) return ExamSessionStatus.inProgress;
      if (ExamSessionStatus.proctorAllowed.contains(value)) return value;
      _emitRoleError();
      return _invalidStatusMarker;
    }

    return ExamSessionStatus.completed;
  }

  void _emitRoleError() {
    emit(
      const ExamSessionsState.error(
        error: 'This status is not available for your role',
      ),
    );
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  List<ExamSessionListItem> _appendWithoutDuplicates(
    List<ExamSessionListItem> existing,
    List<ExamSessionListItem> incoming,
  ) {
    final seen = existing.map((session) => session.sessionId).toSet();
    final merged = List<ExamSessionListItem>.from(existing);

    for (final session in incoming) {
      if (seen.add(session.sessionId)) {
        merged.add(session);
      }
    }

    return merged;
  }
}

const _invalidStatusMarker = '__invalid_exam_session_status__';

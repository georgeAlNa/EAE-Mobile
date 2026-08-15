import 'dart:async';

import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/exam_sessions/data/models/exam_sessions_list_response.dart';
import 'package:eae_mobile/features/exam_sessions/data/repos/exam_sessions_repo.dart';
import 'package:eae_mobile/features/exam_sessions/logic/exam_sessions_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExamSessionsRepo extends Mock implements ExamSessionsRepo {}

ExamSessionListItem session(String id, {String state = 'in_progress'}) =>
    ExamSessionListItem(
      sessionId: id,
      examId: 'exam-$id',
      candidateId: 'candidate-$id',
      enrollmentId: 'enrollment-$id',
      state: state,
      progress: ExamSessionListProgress(
        totalQuestionsResponded: 3,
        totalQuestionsFlagged: 1,
      ),
      timestamps: ExamSessionListTimestamps(
        startedAt: '2026-08-14T10:00:00+00:00',
        lastHeartbeatAt: '2026-08-14T10:15:00+00:00',
      ),
      totalSessionDurationSeconds: 900,
    );

ExamSessionsListResponse pageResponse({
  required int page,
  required int lastPage,
  required List<ExamSessionListItem> sessions,
}) => ExamSessionsListResponse(
  data: sessions,
  meta: ExamSessionsPaginationMeta(
    currentPage: page,
    perPage: 15,
    total: sessions.length,
    lastPage: lastPage,
  ),
);

bool isLoading(ExamSessionsState state) =>
    state.maybeWhen(loading: () => true, orElse: () => false);

List<ExamSessionListItem>? loadedSessions(ExamSessionsState state) =>
    state.whenOrNull(loaded: (sessions, _) => sessions);

String? stateError(ExamSessionsState state) =>
    state.maybeWhen(error: (error) => error, orElse: () => null);

void main() {
  late MockExamSessionsRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(1);
  });

  setUp(() {
    repo = MockExamSessionsRepo();
  });

  ExamSessionsCubit cubit(ExamSessionsRole role) {
    final cubit = ExamSessionsCubit(examSessionsRepo: repo, role: role);
    addTearDown(cubit.close);
    return cubit;
  }

  void stubSuccess({
    String? expectedStatus,
    String? expectedExamId,
    String? expectedCandidateId,
    int? expectedPage,
    ExamSessionsListResponse? response,
  }) {
    when(
      () => repo.getExamSessions(
        status: expectedStatus,
        examId: expectedExamId,
        candidateId: expectedCandidateId,
        page: expectedPage,
        perPage: any(named: 'perPage'),
      ),
    ).thenAnswer(
      (_) async =>
          response ??
          pageResponse(
            page: expectedPage ?? 1,
            lastPage: 1,
            sessions: [
              session('session-001', state: expectedStatus ?? 'not_started'),
            ],
          ),
    );
  }

  group('ExamSessionsCubit', () {
    test('loads success and empty response as normal loaded state', () async {
      stubSuccess(
        expectedPage: 1,
        response: pageResponse(page: 1, lastPage: 1, sessions: []),
      );
      final subject = cubit(ExamSessionsRole.tenantAdmin);

      final emission = expectLater(
        subject.stream,
        emitsInOrder([
          predicate<ExamSessionsState>(isLoading),
          predicate<ExamSessionsState>(
            (state) => loadedSessions(state)?.isEmpty ?? false,
          ),
        ]),
      );

      await subject.loadExamSessions();
      await emission;
    });

    test('refresh reuses current filters', () async {
      stubSuccess(
        expectedStatus: 'completed',
        expectedExamId: 'exam-uuid',
        expectedPage: 1,
      );
      final subject = cubit(ExamSessionsRole.tenantAdmin);

      await subject.loadExamSessions(status: 'completed', examId: 'exam-uuid');
      await subject.refresh();

      verify(
        () => repo.getExamSessions(
          status: 'completed',
          examId: 'exam-uuid',
          candidateId: null,
          page: 1,
          perPage: null,
        ),
      ).called(2);
    });

    test('pagination appends and removes duplicate sessions', () async {
      when(
        () => repo.getExamSessions(
          status: any(named: 'status'),
          examId: any(named: 'examId'),
          candidateId: any(named: 'candidateId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          lastPage: 2,
          sessions: [session('session-001'), session('session-002')],
        ),
      );
      when(
        () => repo.getExamSessions(
          status: any(named: 'status'),
          examId: any(named: 'examId'),
          candidateId: any(named: 'candidateId'),
          page: 2,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 2,
          lastPage: 2,
          sessions: [session('session-002'), session('session-003')],
        ),
      );
      final subject = cubit(ExamSessionsRole.tenantAdmin);

      await subject.loadExamSessions();
      await subject.loadNextPage();

      expect(subject.currentSessions.map((item) => item.sessionId), [
        'session-001',
        'session-002',
        'session-003',
      ]);
    });

    test('page failure preserves existing data', () async {
      when(
        () => repo.getExamSessions(
          status: any(named: 'status'),
          examId: any(named: 'examId'),
          candidateId: any(named: 'candidateId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          lastPage: 2,
          sessions: [session('session-001')],
        ),
      );
      when(
        () => repo.getExamSessions(
          status: any(named: 'status'),
          examId: any(named: 'examId'),
          candidateId: any(named: 'candidateId'),
          page: 2,
          perPage: any(named: 'perPage'),
        ),
      ).thenThrow(const NetworkExceptions.notFound('No page'));
      final subject = cubit(ExamSessionsRole.tenantAdmin);

      await subject.loadExamSessions();
      await subject.loadNextPage();

      expect(subject.currentSessions.single.sessionId, 'session-001');
      expect(
        subject.state.whenOrNull(nextPageError: (sessions, error) => error),
        'No page',
      );
    });

    test('refresh failure preserves existing data', () async {
      when(
        () => repo.getExamSessions(
          status: any(named: 'status'),
          examId: any(named: 'examId'),
          candidateId: any(named: 'candidateId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          lastPage: 1,
          sessions: [session('session-001')],
        ),
      );
      final subject = cubit(ExamSessionsRole.tenantAdmin);
      await subject.loadExamSessions();

      when(
        () => repo.getExamSessions(
          status: any(named: 'status'),
          examId: any(named: 'examId'),
          candidateId: any(named: 'candidateId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenThrow(const NetworkExceptions.notFound('Refresh failed'));

      await subject.refresh();

      expect(subject.currentSessions.single.sessionId, 'session-001');
      expect(
        subject.state.whenOrNull(refreshError: (sessions, error) => error),
        'Refresh failed',
      );
    });

    test(
      'duplicate load more calls do not create duplicate page requests',
      () async {
        when(
          () => repo.getExamSessions(
            status: any(named: 'status'),
            examId: any(named: 'examId'),
            candidateId: any(named: 'candidateId'),
            page: 1,
            perPage: any(named: 'perPage'),
          ),
        ).thenAnswer(
          (_) async => pageResponse(
            page: 1,
            lastPage: 2,
            sessions: [session('session-001')],
          ),
        );

        final completer = Completer<ExamSessionsListResponse>();
        when(
          () => repo.getExamSessions(
            status: any(named: 'status'),
            examId: any(named: 'examId'),
            candidateId: any(named: 'candidateId'),
            page: 2,
            perPage: any(named: 'perPage'),
          ),
        ).thenAnswer((_) => completer.future);

        final subject = cubit(ExamSessionsRole.tenantAdmin);
        await subject.loadExamSessions();

        final firstLoadMore = subject.loadNextPage();
        final secondLoadMore = subject.loadNextPage();
        completer.complete(
          pageResponse(
            page: 2,
            lastPage: 2,
            sessions: [session('session-002')],
          ),
        );
        await Future.wait([firstLoadMore, secondLoadMore]);

        verify(
          () => repo.getExamSessions(
            status: null,
            examId: null,
            candidateId: null,
            page: 2,
            perPage: null,
          ),
        ).called(1);
      },
    );

    test('stale response after filter change is ignored', () async {
      final firstCompleter = Completer<ExamSessionsListResponse>();
      when(
        () => repo.getExamSessions(
          status: 'in_progress',
          examId: any(named: 'examId'),
          candidateId: any(named: 'candidateId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) => firstCompleter.future);
      when(
        () => repo.getExamSessions(
          status: 'terminated',
          examId: any(named: 'examId'),
          candidateId: any(named: 'candidateId'),
          page: 1,
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => pageResponse(
          page: 1,
          lastPage: 1,
          sessions: [session('new-session', state: 'terminated')],
        ),
      );

      final subject = cubit(ExamSessionsRole.tenantAdmin);
      final oldRequest = subject.loadExamSessions(status: 'in_progress');
      await subject.loadExamSessions(status: 'terminated');
      firstCompleter.complete(
        pageResponse(
          page: 1,
          lastPage: 1,
          sessions: [session('old-session', state: 'in_progress')],
        ),
      );
      await oldRequest;

      expect(subject.currentSessions.single.sessionId, 'new-session');
    });

    test(
      'proctor defaults to in_progress and allows only terminated alternate',
      () async {
        stubSuccess(expectedStatus: 'in_progress', expectedPage: 1);
        stubSuccess(expectedStatus: 'terminated', expectedPage: 1);
        final subject = cubit(ExamSessionsRole.proctor);

        await subject.loadExamSessions();
        await subject.loadExamSessions(status: 'terminated');
        await subject.loadExamSessions(status: 'completed');

        verify(
          () => repo.getExamSessions(
            status: 'in_progress',
            examId: null,
            candidateId: null,
            page: 1,
            perPage: null,
          ),
        ).called(1);
        verify(
          () => repo.getExamSessions(
            status: 'terminated',
            examId: null,
            candidateId: null,
            page: 1,
            perPage: null,
          ),
        ).called(1);
        expect(
          stateError(subject.state),
          'This status is not available for your role',
        );
      },
    );

    test(
      'evaluator always requests completed and preserves exam filter',
      () async {
        stubSuccess(
          expectedStatus: 'completed',
          expectedExamId: 'exam-uuid',
          expectedPage: 1,
        );
        final subject = cubit(ExamSessionsRole.evaluator);

        await subject.loadExamSessions(
          status: 'in_progress',
          examId: 'exam-uuid',
        );

        verify(
          () => repo.getExamSessions(
            status: 'completed',
            examId: 'exam-uuid',
            candidateId: null,
            page: 1,
            perPage: null,
          ),
        ).called(1);
      },
    );

    test(
      'tenant admin can request unfiltered and all statuses with filters',
      () async {
        stubSuccess(expectedPage: 1);
        stubSuccess(
          expectedStatus: 'paused',
          expectedExamId: 'exam-uuid',
          expectedCandidateId: 'candidate-uuid',
          expectedPage: 1,
        );
        final subject = cubit(ExamSessionsRole.tenantAdmin);

        await subject.loadExamSessions();
        await subject.loadExamSessions(
          status: 'paused',
          examId: 'exam-uuid',
          candidateId: 'candidate-uuid',
        );

        verify(
          () => repo.getExamSessions(
            status: null,
            examId: null,
            candidateId: null,
            page: 1,
            perPage: null,
          ),
        ).called(1);
        verify(
          () => repo.getExamSessions(
            status: 'paused',
            examId: 'exam-uuid',
            candidateId: 'candidate-uuid',
            page: 1,
            perPage: null,
          ),
        ).called(1);
      },
    );
  });
}

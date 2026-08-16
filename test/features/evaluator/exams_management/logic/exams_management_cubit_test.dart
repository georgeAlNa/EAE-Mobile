import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_request_body.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_response.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/repos/exams_management_repo.dart';
import 'package:eae_mobile/features/evaluator/exams_management/logic/exams_management_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_request_body.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/data/models/result_publication_response.dart';
import 'package:eae_mobile/features/workflows/data/repos/workflow_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExamsManagementRepo extends Mock implements ExamsManagementRepo {}

class MockWorkflowRepo extends Mock implements WorkflowRepo {}

ExamRequestBody examRequest() {
  return ExamRequestBody(
    examName: 'Flutter Fundamentals',
    examCode: 'FLUTTER-101',
    examDescription: 'Covers Flutter basics',
    examType: 'technical',
    assessmentMode: 'online',
    totalQuestions: 25,
    totalDurationMinutes: 60,
    passMarkPercentage: 70,
    difficultyTierLevel: 2,
    isAdaptiveExam: false,
    isRandomized: true,
    allowReviewAfterSubmit: true,
    allowFlaggingForReview: true,
    timerVisibleToCandidate: true,
    showCorrectAnswersAfter: false,
  );
}

ExamItem exam({String id = 'exam_001', String status = 'draft'}) {
  return ExamItem(
    id: id,
    tenantId: 'tenant_001',
    createdByUserId: 'usr_creator',
    examName: 'Flutter Fundamentals',
    examCode: 'FLUTTER-101',
    examDescription: 'Covers Flutter basics',
    examType: 'technical',
    assessmentMode: 'online',
    totalQuestions: 25,
    totalDurationMinutes: 60,
    passMarkPercentage: 70,
    difficultyTierLevel: 2,
    isAdaptiveExam: false,
    isRandomized: true,
    allowReviewAfterSubmit: true,
    allowFlaggingForReview: true,
    timerVisibleToCandidate: true,
    showCorrectAnswersAfter: false,
    securityProtocols: const {'camera': true},
    examMetadata: const {'category': 'mobile'},
    examStatus: status,
    isPublished: status == 'published',
    publishedAt: status == 'published' ? '2026-07-15T20:00:00.000Z' : null,
    archivedAt: status == 'archived' ? '2026-07-16T20:00:00.000Z' : null,
    createdAt: '2026-07-01T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

ExamsResponse examsResponse() => ExamsResponse(data: [exam()]);

ExamSectionRequestBody sectionRequest() => ExamSectionRequestBody(
  sectionName: 'Second Section',
  sectionSequence: 2,
  questionsInSection: 1,
);

ExamBlueprintRequestBody blueprintRequest() => ExamBlueprintRequestBody(
  sectionId: 'section_001',
  competencyId: 'competency_001',
  minQuestionsCount: 1,
  maxQuestionsCount: 1,
  minWeightPercentage: 100,
  maxWeightPercentage: 100,
);

ExamSection section({String id = 'section_001'}) => ExamSection(
  sectionId: id,
  tenantId: 'tenant_001',
  examId: 'exam_001',
  sectionName: 'Main Section',
  sectionSequence: 1,
  questionsInSection: 1,
  blueprints: const [],
);

ExamBlueprint blueprint({String id = 'blueprint_001'}) => ExamBlueprint(
  blueprintId: id,
  examId: 'exam_001',
  sectionId: 'section_001',
  competencyId: 'competency_001',
  minQuestionsCount: 1,
  maxQuestionsCount: 1,
  minWeightPercentage: '100.00',
  maxWeightPercentage: '100.00',
);

Future<ExamsManagementState> waitForLoadTerminal(ExamsManagementCubit cubit) {
  return cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (_) => true,
      loadError: (_) => true,
      orElse: () => false,
    ),
  );
}

bool isLoading(ExamsManagementState state) {
  return state.maybeWhen(
    examsLoading: () => true,
    detailsLoading: () => true,
    saveLoading: () => true,
    actionLoading: () => true,
    orElse: () => false,
  );
}

String? stateError(ExamsManagementState state) {
  return state.maybeWhen(
    loadError: (error) => error,
    detailsError: (error) => error,
    saveError: (error) => error,
    actionError: (error) => error,
    orElse: () => null,
  );
}

ExamsResponse? loadedResponse(ExamsManagementState state) {
  return state.whenOrNull(loaded: (response) => response);
}

ExamResponse? detailsResponse(ExamsManagementState state) {
  return state.whenOrNull(detailsLoaded: (response) => response);
}

ExamResponse? savedResponse(ExamsManagementState state) {
  return state.whenOrNull(saved: (response) => response);
}

ExamActionResponse? actionResponse(ExamsManagementState state) {
  return state.whenOrNull(actionSuccess: (response) => response);
}

void main() {
  late MockExamsManagementRepo repo;
  late MockWorkflowRepo workflowRepo;

  setUpAll(() {
    registerFallbackValue(examRequest());
    registerFallbackValue(sectionRequest());
    registerFallbackValue(blueprintRequest());
    registerFallbackValue(
      CreateApprovalWorkflowRequestBody(
        resourceType: '',
        resourceId: '',
        workflowType: '',
      ),
    );
    registerFallbackValue('');
  });

  setUp(() {
    repo = MockExamsManagementRepo();
    workflowRepo = MockWorkflowRepo();
  });

  ExamsManagementCubit createCubit() {
    final cubit = ExamsManagementCubit(
      examsManagementRepo: repo,
      workflowRepo: workflowRepo,
    );
    addTearDown(cubit.close);
    return cubit;
  }

  Future<ExamsManagementCubit> loadedCubit() async {
    when(() => repo.getExams()).thenAnswer((_) async => examsResponse());
    final cubit = createCubit();
    await waitForLoadTerminal(cubit);
    return cubit;
  }

  group('ExamsManagementCubit', () {
    test('initially loads exams and stores response', () async {
      final response = examsResponse();
      when(() => repo.getExams()).thenAnswer((_) async => response);

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(loadedResponse(state), same(response));
      expect(cubit.examsResponse, same(response));
      verify(() => repo.getExams()).called(1);
    });

    test('emits error when initial load fails', () async {
      when(() => repo.getExams()).thenAnswer(
        (_) async =>
            throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      );

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(stateError(state), 'Unauthorized');
      expect(cubit.examsResponse, isNull);
    });

    test('getExams emits loading then loaded on retry', () async {
      final cubit = await loadedCubit();

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => loadedResponse(state)?.data.single.id == 'exam_001',
          ),
        ]),
      );

      await cubit.getExams();
      await emission;
    });

    test('createExam emits loading then saved', () async {
      final cubit = await loadedCubit();
      final response = ExamResponse(data: exam(id: 'exam_created'));
      when(() => repo.createExam(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => savedResponse(state)?.data.id == 'exam_created',
          ),
        ]),
      );

      await cubit.createExam(examRequest());
      await emission;

      final captured =
          verify(() => repo.createExam(captureAny())).captured.single
              as ExamRequestBody;
      expect(captured.examCode, 'FLUTTER-101');
    });

    test(
      'getExamDetails emits loading then detailsLoaded and stores selection',
      () async {
        final cubit = await loadedCubit();
        final response = ExamResponse(data: exam(id: 'exam_details'));
        when(
          () => repo.getExamDetails(any()),
        ).thenAnswer((_) async => response);

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ExamsManagementState>(isLoading),
            predicate<ExamsManagementState>(
              (state) => detailsResponse(state)?.data.id == 'exam_details',
            ),
          ]),
        );

        await cubit.getExamDetails('exam_details');
        await emission;

        expect(cubit.selectedExamResponse, same(response));
        expect(
          verify(() => repo.getExamDetails(captureAny())).captured.single,
          'exam_details',
        );
      },
    );

    test('updateExam emits loading then saved', () async {
      final cubit = await loadedCubit();
      final response = ExamResponse(data: exam(id: 'exam_001'));
      when(
        () => repo.updateExam(any(), any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => savedResponse(state)?.data.id == 'exam_001',
          ),
        ]),
      );

      await cubit.updateExam('exam_001', examRequest());
      await emission;

      final captured = verify(
        () => repo.updateExam(captureAny(), captureAny()),
      ).captured;
      expect(captured[0], 'exam_001');
      expect((captured[1] as ExamRequestBody).examName, 'Flutter Fundamentals');
    });

    test('deleteExam emits loading then actionSuccess', () async {
      final cubit = await loadedCubit();
      final response = ExamActionResponse(message: 'Exam deleted');
      when(() => repo.deleteExam(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => actionResponse(state)?.message == 'Exam deleted',
          ),
        ]),
      );

      await cubit.deleteExam('exam_001');
      await emission;

      expect(
        verify(() => repo.deleteExam(captureAny())).captured.single,
        'exam_001',
      );
    });

    test('publishExam emits loading then saved', () async {
      final cubit = await loadedCubit();
      final response = ExamResponse(data: exam(status: 'published'));
      when(() => repo.publishExam(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => savedResponse(state)?.data.examStatus == 'published',
          ),
        ]),
      );

      await cubit.publishExam('exam_001');
      await emission;
    });

    test(
      'creates and views exam publication workflow without approval',
      () async {
        final cubit = await loadedCubit();
        final created = ApprovalWorkflowActionResponse(
          message: 'created',
          data: ApprovalWorkflowData(
            workflowId: 'workflow_001',
            resourceType: 'exam',
            resourceId: 'exam_001',
            workflowType: 'exam_publication',
            currentWorkflowStatus: 'pending',
          ),
        );
        final loaded = ApprovalWorkflowActionResponse(
          message: 'loaded',
          data: ApprovalWorkflowData(
            workflowId: 'workflow_001',
            resourceType: 'exam',
            resourceId: 'exam_001',
            workflowType: 'exam_publication',
            currentWorkflowStatus: 'approved',
          ),
        );
        when(
          () => workflowRepo.createWorkflow(any()),
        ).thenAnswer((_) async => created);
        when(
          () => workflowRepo.getWorkflow(any()),
        ).thenAnswer((_) async => loaded);

        var emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ExamsManagementState>(isLoading),
            predicate<ExamsManagementState>(
              (state) => actionResponse(state)?.message == 'workflow_001',
            ),
          ]),
        );
        await cubit.createExamPublicationWorkflow('exam_001');
        await emission;
        final request =
            verify(
                  () => workflowRepo.createWorkflow(captureAny()),
                ).captured.single
                as CreateApprovalWorkflowRequestBody;
        expect(request.resourceType, 'exam');
        expect(request.resourceId, 'exam_001');
        expect(request.workflowType, 'exam_publication');

        emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ExamsManagementState>(isLoading),
            predicate<ExamsManagementState>(
              (state) => actionResponse(state)?.message == 'approved',
            ),
          ]),
        );
        await cubit.getExamPublicationWorkflow('workflow_001');
        await emission;

        verify(() => workflowRepo.getWorkflow('workflow_001')).called(1);
        verifyNever(() => workflowRepo.approveWorkflow(any()));
      },
    );

    test('archiveExam emits loading then saved', () async {
      final cubit = await loadedCubit();
      final response = ExamResponse(data: exam(status: 'archived'));
      when(() => repo.archiveExam(any())).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => savedResponse(state)?.data.examStatus == 'archived',
          ),
        ]),
      );

      await cubit.archiveExam('exam_001');
      await emission;
    });

    test('createExam emits loading then error when API fails', () async {
      final cubit = await loadedCubit();
      when(
        () => repo.createExam(any()),
      ).thenThrow(const NetworkExceptions.unprocessableEntity('Invalid exam'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => stateError(state) == 'Invalid exam',
          ),
        ]),
      );

      await cubit.createExam(examRequest());
      await emission;
    });

    test('deleteExam emits loading then error when API fails', () async {
      final cubit = await loadedCubit();
      when(
        () => repo.deleteExam(any()),
      ).thenThrow(const NetworkExceptions.notFound('Exam not found'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => stateError(state) == 'Exam not found',
          ),
        ]),
      );

      await cubit.deleteExam('missing_exam');
      await emission;
    });

    test('section methods emit actionSuccess and store section list', () async {
      final cubit = await loadedCubit();
      final created = ExamSectionResponse(data: section(id: 'section_new'));
      final sections = ExamSectionsResponse(data: [section()]);
      when(
        () => repo.createExamSection(any(), any()),
      ).thenAnswer((_) async => created);
      when(() => repo.getExamSections(any())).thenAnswer((_) async => sections);

      var emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => actionResponse(state)?.message == 'section_new',
          ),
        ]),
      );
      await cubit.createExamSection('exam_001', sectionRequest());
      await emission;

      emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<ExamsManagementState>(isLoading),
          predicate<ExamsManagementState>(
            (state) => actionResponse(state)?.message == '1',
          ),
        ]),
      );
      await cubit.getExamSections('exam_001');
      await emission;
      expect(cubit.examSectionsResponse, same(sections));
    });

    test(
      'blueprint methods emit actionSuccess and store blueprint list',
      () async {
        final cubit = await loadedCubit();
        final created = ExamBlueprintResponse(
          data: blueprint(id: 'blueprint_new'),
        );
        final blueprints = ExamBlueprintsResponse(data: [blueprint()]);
        when(
          () => repo.createExamBlueprint(any(), any()),
        ).thenAnswer((_) async => created);
        when(
          () => repo.getExamBlueprints(any()),
        ).thenAnswer((_) async => blueprints);

        var emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ExamsManagementState>(isLoading),
            predicate<ExamsManagementState>(
              (state) => actionResponse(state)?.message == 'blueprint_new',
            ),
          ]),
        );
        await cubit.createExamBlueprint('exam_001', blueprintRequest());
        await emission;

        emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ExamsManagementState>(isLoading),
            predicate<ExamsManagementState>(
              (state) => actionResponse(state)?.message == '1',
            ),
          ]),
        );
        await cubit.getExamBlueprints('exam_001');
        await emission;
        expect(cubit.examBlueprintsResponse, same(blueprints));
      },
    );

    test(
      'exportExamResults emits actionSuccess and stores CSV response',
      () async {
        final cubit = await loadedCubit();
        final response = ExamResultsExportResponse(data: 'csv');
        when(
          () => repo.exportExamResults(any()),
        ).thenAnswer((_) async => response);

        final emission = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<ExamsManagementState>(isLoading),
            predicate<ExamsManagementState>(
              (state) => actionResponse(state)?.message == 'csv',
            ),
          ]),
        );

        await cubit.exportExamResults('exam_001');
        await emission;
        expect(cubit.examResultsExportResponse, same(response));
      },
    );
  });
}

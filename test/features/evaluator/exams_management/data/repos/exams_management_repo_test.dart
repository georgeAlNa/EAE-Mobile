import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/datasources/exams_management_remote_data_source.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_request_body.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_response.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/repos/exams_management_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExamsManagementRemoteDataSource extends Mock
    implements ExamsManagementRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

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

void main() {
  late MockExamsManagementRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late ExamsManagementRepo repo;

  setUpAll(() {
    registerFallbackValue(examRequest());
    registerFallbackValue(sectionRequest());
    registerFallbackValue(blueprintRequest());
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockExamsManagementRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = ExamsManagementRepo(
      examsManagementRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('getExams', () {
    test('returns exams response when connected and remote succeeds', () async {
      final response = ExamsResponse(data: [exam()]);
      connected();
      when(() => remoteDataSource.getExams()).thenAnswer((_) async => response);

      final result = await repo.getExams();

      expect(result, same(response));
      verify(() => remoteDataSource.getExams()).called(1);
    });

    test('throws noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.getExams(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.getExams());
    });

    test('propagates API errors', () {
      connected();
      const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
      when(() => remoteDataSource.getExams()).thenThrow(exception);

      expect(() => repo.getExams(), throwsA(exception));
    });
  });

  group('createExam', () {
    test('returns exam response when connected and remote succeeds', () async {
      final request = examRequest();
      final response = ExamResponse(data: exam(id: 'exam_created'));
      connected();
      when(
        () => remoteDataSource.createExam(any()),
      ).thenAnswer((_) async => response);

      final result = await repo.createExam(request);

      expect(result, same(response));
      final captured =
          verify(
                () => remoteDataSource.createExam(captureAny()),
              ).captured.single
              as ExamRequestBody;
      expect(captured.examName, 'Flutter Fundamentals');
    });

    test('throws noInternetConnection when create is offline', () {
      offline();

      expect(
        () => repo.createExam(examRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.createExam(any()));
    });
  });

  group('getExamDetails', () {
    test('returns exam response when connected and remote succeeds', () async {
      final response = ExamResponse(data: exam());
      connected();
      when(
        () => remoteDataSource.getExamDetails(any()),
      ).thenAnswer((_) async => response);

      final result = await repo.getExamDetails('exam_001');

      expect(result, same(response));
      expect(
        verify(
          () => remoteDataSource.getExamDetails(captureAny()),
        ).captured.single,
        'exam_001',
      );
    });

    test('throws noInternetConnection when details is offline', () {
      offline();

      expect(
        () => repo.getExamDetails('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.getExamDetails(any()));
    });
  });

  group('updateExam', () {
    test('returns exam response when connected and remote succeeds', () async {
      final response = ExamResponse(data: exam());
      connected();
      when(
        () => remoteDataSource.updateExam(any(), any()),
      ).thenAnswer((_) async => response);

      final result = await repo.updateExam('exam_001', examRequest());

      expect(result, same(response));
      final captured = verify(
        () => remoteDataSource.updateExam(captureAny(), captureAny()),
      ).captured;
      expect(captured[0], 'exam_001');
      expect((captured[1] as ExamRequestBody).examCode, 'FLUTTER-101');
    });

    test('throws noInternetConnection when update is offline', () {
      offline();

      expect(
        () => repo.updateExam('exam_001', examRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.updateExam(any(), any()));
    });
  });

  group('deleteExam', () {
    test(
      'returns action response when connected and remote succeeds',
      () async {
        final response = ExamActionResponse(message: 'Exam deleted');
        connected();
        when(
          () => remoteDataSource.deleteExam(any()),
        ).thenAnswer((_) async => response);

        final result = await repo.deleteExam('exam_001');

        expect(result, same(response));
        expect(
          verify(
            () => remoteDataSource.deleteExam(captureAny()),
          ).captured.single,
          'exam_001',
        );
      },
    );

    test('throws noInternetConnection when delete is offline', () {
      offline();

      expect(
        () => repo.deleteExam('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.deleteExam(any()));
    });

    test('propagates delete API errors', () {
      connected();
      const exception = NetworkExceptions.notFound('Exam not found');
      when(() => remoteDataSource.deleteExam(any())).thenThrow(exception);

      expect(() => repo.deleteExam('missing_exam'), throwsA(exception));
    });
  });

  group('publishExam', () {
    test('returns published exam when connected and remote succeeds', () async {
      final response = ExamResponse(data: exam(status: 'published'));
      connected();
      when(
        () => remoteDataSource.publishExam(any()),
      ).thenAnswer((_) async => response);

      final result = await repo.publishExam('exam_001');

      expect(result, same(response));
      verify(() => remoteDataSource.publishExam('exam_001')).called(1);
    });

    test('throws noInternetConnection when publish is offline', () {
      offline();

      expect(
        () => repo.publishExam('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.publishExam(any()));
    });
  });

  group('archiveExam', () {
    test('returns archived exam when connected and remote succeeds', () async {
      final response = ExamResponse(data: exam(status: 'archived'));
      connected();
      when(
        () => remoteDataSource.archiveExam(any()),
      ).thenAnswer((_) async => response);

      final result = await repo.archiveExam('exam_001');

      expect(result, same(response));
      verify(() => remoteDataSource.archiveExam('exam_001')).called(1);
    });

    test('throws noInternetConnection when archive is offline', () {
      offline();

      expect(
        () => repo.archiveExam('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.archiveExam(any()));
    });
  });

  group('exam sections, blueprints, and export', () {
    test('new ExamEngine methods call remote when connected', () async {
      connected();
      final sectionCreated = ExamSectionResponse(
        data: section(id: 'section_new'),
      );
      final sections = ExamSectionsResponse(data: [section()]);
      final blueprintCreated = ExamBlueprintResponse(
        data: blueprint(id: 'blueprint_new'),
      );
      final blueprints = ExamBlueprintsResponse(data: [blueprint()]);
      final export = ExamResultsExportResponse(data: 'csv');

      when(
        () => remoteDataSource.createExamSection(any(), any()),
      ).thenAnswer((_) async => sectionCreated);
      when(
        () => remoteDataSource.getExamSections(any()),
      ).thenAnswer((_) async => sections);
      when(
        () => remoteDataSource.createExamBlueprint(any(), any()),
      ).thenAnswer((_) async => blueprintCreated);
      when(
        () => remoteDataSource.getExamBlueprints(any()),
      ).thenAnswer((_) async => blueprints);
      when(
        () => remoteDataSource.exportExamResults(any()),
      ).thenAnswer((_) async => export);

      expect(
        await repo.createExamSection('exam_001', sectionRequest()),
        same(sectionCreated),
      );
      expect(await repo.getExamSections('exam_001'), same(sections));
      expect(
        await repo.createExamBlueprint('exam_001', blueprintRequest()),
        same(blueprintCreated),
      );
      expect(await repo.getExamBlueprints('exam_001'), same(blueprints));
      expect(await repo.exportExamResults('exam_001'), same(export));
    });

    test('new ExamEngine methods throw noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.createExamSection('exam_001', sectionRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getExamSections('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.createExamBlueprint('exam_001', blueprintRequest()),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getExamBlueprints('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.exportExamResults('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
    });
  });
}

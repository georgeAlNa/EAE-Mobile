import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/datasources/assessment_inventory_remote_data_source.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory/assessment_inventory_response.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/models/assessment_inventory_details/assessment_inventory_details_response.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/repos/assessment_inventory_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssessmentInventoryRemoteDataSource extends Mock
    implements AssessmentInventoryRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

AssessmentExam exam({String id = 'exam_001'}) {
  return AssessmentExam(
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
    examStatus: 'published',
    isPublished: true,
    publishedAt: '2026-07-15T20:00:00.000Z',
    archivedAt: null,
    createdAt: '2026-07-01T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

void main() {
  late MockAssessmentInventoryRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late AssessmentInventoryRepo repo;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockAssessmentInventoryRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = AssessmentInventoryRepo(
      assessmentInventoryRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group('assessmentInventory', () {
    test(
      'returns inventory response when connected and remote succeeds',
      () async {
        final response = AssessmentInventoryResponse(data: [exam()]);
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.assessmentInventory(),
        ).thenAnswer((_) async => response);

        final result = await repo.assessmentInventory();

        expect(result, same(response));
        verify(() => remoteDataSource.assessmentInventory()).called(1);
      },
    );

    test('throws noInternetConnection when offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => repo.assessmentInventory(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.assessmentInventory());
    });

    test('propagates inventory API errors', () {
      const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.assessmentInventory()).thenThrow(exception);

      expect(() => repo.assessmentInventory(), throwsA(exception));
    });
  });

  group('assessmentInventoryDetails', () {
    test(
      'returns details response when connected and remote succeeds',
      () async {
        final response = AssessmentInventoryDetailsResponse(data: exam());
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.assessmentInventoryDetails(any()),
        ).thenAnswer((_) async => response);

        final result = await repo.assessmentInventoryDetails('exam_001');

        expect(result, same(response));
        final captured =
            verify(
                  () =>
                      remoteDataSource.assessmentInventoryDetails(captureAny()),
                ).captured.single
                as String;
        expect(captured, 'exam_001');
      },
    );

    test('throws noInternetConnection when details is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => repo.assessmentInventoryDetails('exam_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.assessmentInventoryDetails(any()));
    });

    test('propagates details API errors', () {
      const exception = NetworkExceptions.notFound('Exam not found');
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.assessmentInventoryDetails(any()),
      ).thenThrow(exception);

      expect(
        () => repo.assessmentInventoryDetails('missing_exam'),
        throwsA(exception),
      );
    });
  });
}

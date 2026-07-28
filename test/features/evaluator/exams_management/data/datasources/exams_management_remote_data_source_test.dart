import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/datasources/exams_management_remote_data_source.dart';
import 'package:eae_mobile/features/evaluator/exams_management/data/models/exams_management_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'access-token',
  );
}

Map<String, dynamic> examBodyJson() => {
  'exam_name': 'Flutter Fundamentals',
  'exam_code': 'FLUTTER-101',
  'exam_description': 'Covers Flutter basics',
  'exam_type': 'technical',
  'assessment_mode': 'online',
  'total_questions': 25,
  'total_duration_minutes': 60,
  'pass_mark_percentage': 70,
  'difficulty_tier_level': 2,
  'is_adaptive_exam': false,
  'is_randomized': true,
  'allow_review_after_submit': true,
  'allow_flagging_for_review': true,
  'timer_visible_to_candidate': true,
  'show_correct_answers_after': false,
};

ExamRequestBody examRequest() => ExamRequestBody.fromJson(examBodyJson());

Map<String, dynamic> examJson({
  String id = 'exam_001',
  String examStatus = 'draft',
}) => {
  ...examBodyJson(),
  'id': id,
  'tenant_id': 'tenant_001',
  'created_by_user_id': 'usr_creator',
  'security_protocols': {'camera': true},
  'exam_metadata': {'category': 'mobile'},
  'exam_status': examStatus,
  'is_published': examStatus == 'published',
  'published_at': examStatus == 'published' ? '2026-07-15T20:00:00.000Z' : null,
  'archived_at': examStatus == 'archived' ? '2026-07-16T20:00:00.000Z' : null,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

Map<String, dynamic> sectionJson({String id = 'section_001'}) => {
  'section_id': id,
  'tenant_id': 'tenant_001',
  'exam_id': 'exam_001',
  'section_name': 'Main Section',
  'section_code': null,
  'section_sequence': 1,
  'questions_in_section': 1,
  'time_limit_minutes': null,
  'branching_logic': null,
  'section_metadata': null,
  'created_at': '2026-07-21T02:33:01.000000Z',
  'blueprints': const [],
};

Map<String, dynamic> blueprintJson({String id = 'blueprint_001'}) => {
  'blueprint_id': id,
  'exam_id': 'exam_001',
  'section_id': 'section_001',
  'competency_id': 'competency_001',
  'min_questions_count': 1,
  'max_questions_count': 1,
  'min_weight_percentage': '100.00',
  'max_weight_percentage': '100.00',
  'bloom_distribution': null,
  'target_difficulty': '0.600',
  'min_discrimination': '0.000',
  'resolution_strategy': 'stratified',
  'blueprint_metadata': null,
  'created_at': '2026-07-21T02:35:15.000000Z',
  'competency': null,
};

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

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late ExamsManagementRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = ExamsManagementRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('ExamsManagementRemoteDataSourceImpl', () {
    test('getExams gets exams endpoint with stored token', () async {
      when(
        () => apiServicesImpl.get(AppLinkUrl.exams, token: any(named: 'token')),
      ).thenAnswer(
        (_) async => {
          'data': [examJson()],
        },
      );

      final response = await remoteDataSource.getExams();

      expect(response.data.single.id, 'exam_001');
      final captured = verify(
        () => apiServicesImpl.get(
          AppLinkUrl.exams,
          token: captureAny(named: 'token'),
        ),
      ).captured.single;
      expect(captured, 'access-token');
    });

    test('createExam posts request body with stored token', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.exams,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': examJson(id: 'exam_created')});

      final response = await remoteDataSource.createExam(examRequest());

      expect(response.data.id, 'exam_created');
      final captured = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.exams,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(captured[0], examBodyJson());
      expect(captured[1], 'access-token');
    });

    test(
      'getExamDetails gets exam details endpoint with stored token',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.examDetails('exam_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'data': examJson()});

        final response = await remoteDataSource.getExamDetails('exam_001');

        expect(response.data.id, 'exam_001');
        verify(
          () => apiServicesImpl.get(
            AppLinkUrl.examDetails('exam_001'),
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test('updateExam patches details endpoint with body and token', () async {
      when(
        () => apiServicesImpl.patch(
          AppLinkUrl.examDetails('exam_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': examJson()});

      final response = await remoteDataSource.updateExam(
        'exam_001',
        examRequest(),
      );

      expect(response.data.id, 'exam_001');
      final captured = verify(
        () => apiServicesImpl.patch(
          AppLinkUrl.examDetails('exam_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(captured[0], examBodyJson());
      expect(captured[1], 'access-token');
    });

    test('deleteExam deletes details endpoint with stored token', () async {
      when(
        () => apiServicesImpl.delete(
          AppLinkUrl.examDetails('exam_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'message': 'Exam deleted'});

      final response = await remoteDataSource.deleteExam('exam_001');

      expect(response.message, 'Exam deleted');
      verify(
        () => apiServicesImpl.delete(
          AppLinkUrl.examDetails('exam_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('publishExam posts publish endpoint with stored token', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.publishExam('exam_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': examJson(examStatus: 'published')});

      final response = await remoteDataSource.publishExam('exam_001');

      expect(response.data.examStatus, 'published');
      verify(
        () => apiServicesImpl.post(
          AppLinkUrl.publishExam('exam_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('archiveExam posts archive endpoint with stored token', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.archiveExam('exam_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': examJson(examStatus: 'archived')});

      final response = await remoteDataSource.archiveExam('exam_001');

      expect(response.data.examStatus, 'archived');
      verify(
        () => apiServicesImpl.post(
          AppLinkUrl.archiveExam('exam_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('section endpoints use stored token and bodies', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.examSections('exam_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': sectionJson(id: 'section_created')});
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.examSections('exam_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [sectionJson()],
        },
      );

      expect(
        (await remoteDataSource.createExamSection(
          'exam_001',
          sectionRequest(),
        )).data.sectionId,
        'section_created',
      );
      expect(
        (await remoteDataSource.getExamSections(
          'exam_001',
        )).data.single.sectionId,
        'section_001',
      );

      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.examSections('exam_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(createCapture[0], {
        'section_name': 'Second Section',
        'section_sequence': 2,
        'questions_in_section': 1,
      });
      expect(createCapture[1], 'access-token');
      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.examSections('exam_001'),
          token: 'access-token',
        ),
      ).called(1);
    });

    test('blueprint endpoints use stored token and bodies', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.examBlueprints('exam_001'),
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => {'data': blueprintJson(id: 'blueprint_new')});
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.examBlueprints('exam_001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [blueprintJson()],
        },
      );

      expect(
        (await remoteDataSource.createExamBlueprint(
          'exam_001',
          blueprintRequest(),
        )).data.blueprintId,
        'blueprint_new',
      );
      expect(
        (await remoteDataSource.getExamBlueprints(
          'exam_001',
        )).data.single.blueprintId,
        'blueprint_001',
      );

      final createCapture = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.examBlueprints('exam_001'),
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(createCapture[0], {
        'section_id': 'section_001',
        'competency_id': 'competency_001',
        'min_questions_count': 1,
        'max_questions_count': 1,
        'min_weight_percentage': 100,
        'max_weight_percentage': 100,
      });
      expect(createCapture[1], 'access-token');
    });

    test('exportExamResults gets CSV payload with text/csv accept', () async {
      when(
        () => apiServicesImpl.getPlain(
          AppLinkUrl.examResultsExport('exam_001'),
          accept: any(named: 'accept'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => '"Candidate Name","Final Score"');

      final response = await remoteDataSource.exportExamResults('exam_001');

      expect(response.data, contains('Candidate Name'));
      verify(
        () => apiServicesImpl.getPlain(
          AppLinkUrl.examResultsExport('exam_001'),
          accept: 'text/csv',
          token: 'access-token',
        ),
      ).called(1);
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(AppLinkUrl.exams, token: any(named: 'token')),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getExams(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}

import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/candidate/assessment_inventory/data/datasources/assessment_inventory_remote_data_source.dart';
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

Map<String, dynamic> examJson({String id = 'exam_001'}) => {
  'id': id,
  'tenant_id': 'tenant_001',
  'created_by_user_id': 'usr_creator',
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
  'security_protocols': {'camera': true},
  'exam_metadata': {'category': 'mobile'},
  'exam_status': 'published',
  'is_published': true,
  'published_at': '2026-07-15T20:00:00.000Z',
  'archived_at': null,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late AssessmentInventoryRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = AssessmentInventoryRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('AssessmentInventoryRemoteDataSourceImpl', () {
    test('assessmentInventory gets exams with stored token', () async {
      when(
        () => apiServicesImpl.get(AppLinkUrl.exams, token: any(named: 'token')),
      ).thenAnswer(
        (_) async => {
          'data': [examJson()],
        },
      );

      final response = await remoteDataSource.assessmentInventory();

      expect(response.data.single.id, 'exam_001');
      final captured = verify(
        () => apiServicesImpl.get(
          AppLinkUrl.exams,
          token: captureAny(named: 'token'),
        ),
      ).captured.single;
      expect(captured, 'access-token');
    });

    test(
      'assessmentInventoryDetails gets exam details with stored token',
      () async {
        when(
          () => apiServicesImpl.get(
            AppLinkUrl.examDetails('exam_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'data': examJson(id: 'exam_001')});

        final response = await remoteDataSource.assessmentInventoryDetails(
          'exam_001',
        );

        expect(response.data.id, 'exam_001');
        verify(
          () => apiServicesImpl.get(
            AppLinkUrl.examDetails('exam_001'),
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test('candidate inventory never calls analytics dashboard', () async {
      when(
        () => apiServicesImpl.get(AppLinkUrl.exams, token: any(named: 'token')),
      ).thenAnswer(
        (_) async => {
          'data': [examJson()],
        },
      );

      await remoteDataSource.assessmentInventory();

      verifyNever(
        () => apiServicesImpl.get(
          AppLinkUrl.analyticsDashboard,
          token: any(named: 'token'),
        ),
      );
    });

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(AppLinkUrl.exams, token: any(named: 'token')),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.assessmentInventory(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}

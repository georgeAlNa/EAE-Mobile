import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/datasources/competencies_remote_data_source.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_request_body.dart';
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

Map<String, dynamic> competencyJson({
  String id = 'comp_001',
  String name = 'Mobile Development',
  String? parentId,
}) => {
  'id': id,
  'name': name,
  'tenant_id': 'tenant_001',
  'parent_id': parentId,
  'description': 'Competency description',
  'hierarchy_level': parentId == null ? 0 : 1,
  'is_active': true,
  'children': [],
  'has_questions': false,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late CompetenciesRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue('');
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = CompetenciesRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
  });

  group('CompetenciesRemoteDataSourceImpl', () {
    test('getCompetenciesTree gets tree endpoint with stored token', () async {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.competenciesTree,
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': [competencyJson()],
        },
      );

      final response = await remoteDataSource.getCompetenciesTree();

      expect(response.data.single.id, 'comp_001');
      final captured = verify(
        () => apiServicesImpl.get(
          AppLinkUrl.competenciesTree,
          token: captureAny(named: 'token'),
        ),
      ).captured.single;
      expect(captured, 'access-token');
    });

    test('createCompetency posts request body with stored token', () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.competencies,
          body: any(named: 'body'),
          token: any(named: 'token'),
        ),
      ).thenAnswer(
        (_) async => {
          'data': competencyJson(id: 'comp_created', name: 'Flutter'),
        },
      );

      final response = await remoteDataSource.createCompetency(
        CreateCompetencyRequestBody(
          name: 'Flutter',
          parentId: 'comp_parent',
          description: 'Flutter competency',
        ),
      );

      expect(response.data.id, 'comp_created');
      final captured = verify(
        () => apiServicesImpl.post(
          AppLinkUrl.competencies,
          body: captureAny(named: 'body'),
          token: captureAny(named: 'token'),
        ),
      ).captured;
      expect(captured[0], {
        'name': 'Flutter',
        'parent_id': 'comp_parent',
        'description': 'Flutter competency',
      });
      expect(captured[1], 'access-token');
    });

    test(
      'moveCompetency patches move endpoint with request body and token',
      () async {
        when(
          () => apiServicesImpl.patch(
            AppLinkUrl.moveCompetency('comp_001'),
            body: any(named: 'body'),
            token: any(named: 'token'),
          ),
        ).thenAnswer(
          (_) async => {
            'data': competencyJson(id: 'comp_001', parentId: 'comp_parent'),
          },
        );

        final response = await remoteDataSource.moveCompetency(
          'comp_001',
          MoveCompetencyRequestBody(
            parentId: 'comp_parent',
            hasChildren: false,
            hasQuestions: false,
          ),
        );

        expect(response.data.parentId, 'comp_parent');
        final captured = verify(
          () => apiServicesImpl.patch(
            AppLinkUrl.moveCompetency('comp_001'),
            body: captureAny(named: 'body'),
            token: captureAny(named: 'token'),
          ),
        ).captured;
        expect(captured[0], {
          'parent_id': 'comp_parent',
          'has_children': false,
          'has_questions': false,
        });
        expect(captured[1], 'access-token');
      },
    );

    test(
      'deleteCompetency deletes competency details endpoint with token',
      () async {
        when(
          () => apiServicesImpl.delete(
            AppLinkUrl.competencyDetails('comp_001'),
            token: any(named: 'token'),
          ),
        ).thenAnswer((_) async => {'message': 'Competency deleted'});

        final response = await remoteDataSource.deleteCompetency('comp_001');

        expect(response.message, 'Competency deleted');
        verify(
          () => apiServicesImpl.delete(
            AppLinkUrl.competencyDetails('comp_001'),
            token: 'access-token',
          ),
        ).called(1);
      },
    );

    test('wraps unexpected API failures as NetworkExceptions', () {
      when(
        () => apiServicesImpl.get(
          AppLinkUrl.competenciesTree,
          token: any(named: 'token'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        () => remoteDataSource.getCompetenciesTree(),
        throwsA(isA<NetworkExceptions>()),
      );
    });
  });
}

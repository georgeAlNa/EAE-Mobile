import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/datasources/competencies_remote_data_source.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_request_body.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_response.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/repos/competencies_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCompetenciesRemoteDataSource extends Mock
    implements CompetenciesRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

Competency competency({
  String id = 'comp_001',
  String name = 'Mobile Development',
  String? parentId,
}) {
  return Competency(
    id: id,
    name: name,
    tenantId: 'tenant_001',
    parentId: parentId,
    description: 'Competency description',
    hierarchyLevel: parentId == null ? 0 : 1,
    isActive: true,
    children: const [],
    hasQuestions: false,
    createdAt: '2026-07-01T20:00:00.000Z',
    updatedAt: '2026-07-15T20:00:00.000Z',
  );
}

void main() {
  late MockCompetenciesRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late CompetenciesRepo repo;

  setUpAll(() {
    registerFallbackValue(
      CreateCompetencyRequestBody(name: '', parentId: null, description: null),
    );
    registerFallbackValue(
      MoveCompetencyRequestBody(
        parentId: null,
        hasChildren: false,
        hasQuestions: false,
      ),
    );
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockCompetenciesRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = CompetenciesRepo(
      competenciesRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group('getCompetenciesTree', () {
    test('returns tree response when connected and remote succeeds', () async {
      final response = CompetenciesTreeResponse(data: [competency()]);
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.getCompetenciesTree(),
      ).thenAnswer((_) async => response);

      final result = await repo.getCompetenciesTree();

      expect(result, same(response));
      verify(() => remoteDataSource.getCompetenciesTree()).called(1);
    });

    test('throws noInternetConnection when offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => repo.getCompetenciesTree(),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.getCompetenciesTree());
    });

    test('propagates tree API errors', () {
      const exception = NetworkExceptions.unauthorizedRequest('Unauthorized');
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getCompetenciesTree()).thenThrow(exception);

      expect(() => repo.getCompetenciesTree(), throwsA(exception));
    });
  });

  group('createCompetency', () {
    final request = CreateCompetencyRequestBody(
      name: 'Flutter',
      parentId: 'comp_parent',
      description: 'Flutter competency',
    );

    test(
      'returns mutation response when connected and remote succeeds',
      () async {
        final response = CompetencyMutationResponse(
          data: competency(id: 'comp_created', name: 'Flutter'),
        );
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.createCompetency(any()),
        ).thenAnswer((_) async => response);

        final result = await repo.createCompetency(request);

        expect(result, same(response));
        final captured =
            verify(
                  () => remoteDataSource.createCompetency(captureAny()),
                ).captured.single
                as CreateCompetencyRequestBody;
        expect(captured.name, 'Flutter');
        expect(captured.parentId, 'comp_parent');
      },
    );

    test('throws noInternetConnection when create is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => repo.createCompetency(request),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.createCompetency(any()));
    });
  });

  group('moveCompetency', () {
    final request = MoveCompetencyRequestBody(
      parentId: 'comp_parent',
      hasChildren: false,
      hasQuestions: false,
    );

    test(
      'returns mutation response when connected and remote succeeds',
      () async {
        final response = CompetencyMutationResponse(
          data: competency(parentId: 'comp_parent'),
        );
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.moveCompetency(any(), any()),
        ).thenAnswer((_) async => response);

        final result = await repo.moveCompetency('comp_001', request);

        expect(result, same(response));
        final captured = verify(
          () => remoteDataSource.moveCompetency(captureAny(), captureAny()),
        ).captured;
        expect(captured[0], 'comp_001');
        expect(
          (captured[1] as MoveCompetencyRequestBody).parentId,
          'comp_parent',
        );
      },
    );

    test('throws noInternetConnection when move is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => repo.moveCompetency('comp_001', request),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.moveCompetency(any(), any()));
    });
  });

  group('deleteCompetency', () {
    test(
      'returns action response when connected and remote succeeds',
      () async {
        final response = CompetencyActionResponse(
          message: 'Competency deleted',
        );
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => remoteDataSource.deleteCompetency(any()),
        ).thenAnswer((_) async => response);

        final result = await repo.deleteCompetency('comp_001');

        expect(result, same(response));
        final captured =
            verify(
                  () => remoteDataSource.deleteCompetency(captureAny()),
                ).captured.single
                as String;
        expect(captured, 'comp_001');
      },
    );

    test('throws noInternetConnection when delete is offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => repo.deleteCompetency('comp_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.deleteCompetency(any()));
    });

    test('propagates delete API errors', () {
      const exception = NetworkExceptions.notFound('Competency not found');
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.deleteCompetency(any())).thenThrow(exception);

      expect(() => repo.deleteCompetency('missing_comp'), throwsA(exception));
    });
  });
}

import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_request_body.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_response.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/repos/competencies_repo.dart';
import 'package:eae_mobile/features/evaluator/competencies/logic/competencies_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCompetenciesRepo extends Mock implements CompetenciesRepo {}

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

CompetenciesTreeResponse treeResponse() {
  return CompetenciesTreeResponse(data: [competency()]);
}

Future<CompetenciesState> waitForLoadTerminal(CompetenciesCubit cubit) {
  return cubit.stream.firstWhere(
    (state) => state.maybeWhen(
      loaded: (_) => true,
      error: (_) => true,
      orElse: () => false,
    ),
  );
}

String? stateError(CompetenciesState state) {
  return state.whenOrNull(error: (error) => error);
}

CompetenciesTreeResponse? loadedResponse(CompetenciesState state) {
  return state.whenOrNull(loaded: (response) => response);
}

CompetencyMutationResponse? savedResponse(CompetenciesState state) {
  return state.whenOrNull(saved: (response) => response);
}

CompetencyActionResponse? actionResponse(CompetenciesState state) {
  return state.whenOrNull(actionSuccess: (response) => response);
}

bool isLoading(CompetenciesState state) {
  return state.maybeWhen(loading: () => true, orElse: () => false);
}

void main() {
  late MockCompetenciesRepo repo;

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
    repo = MockCompetenciesRepo();
  });

  CompetenciesCubit createCubit() {
    final cubit = CompetenciesCubit(competenciesRepo: repo);
    addTearDown(cubit.close);
    return cubit;
  }

  group('CompetenciesCubit', () {
    test('initially loads competencies tree and stores response', () async {
      final response = treeResponse();
      when(() => repo.getCompetenciesTree()).thenAnswer((_) async => response);

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(loadedResponse(state), same(response));
      expect(cubit.competenciesTreeResponse, same(response));
      verify(() => repo.getCompetenciesTree()).called(1);
    });

    test('emits error when initial tree load fails', () async {
      when(() => repo.getCompetenciesTree()).thenAnswer(
        (_) async =>
            throw const NetworkExceptions.unauthorizedRequest('Unauthorized'),
      );

      final cubit = createCubit();
      final state = await waitForLoadTerminal(cubit);

      expect(stateError(state), 'Unauthorized');
      expect(cubit.competenciesTreeResponse, isNull);
    });

    test('getCompetenciesTree emits loading then loaded on retry', () async {
      final response = treeResponse();
      when(() => repo.getCompetenciesTree()).thenAnswer((_) async => response);
      final cubit = createCubit();
      await waitForLoadTerminal(cubit);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CompetenciesState>(isLoading),
          predicate<CompetenciesState>(
            (state) => loadedResponse(state) == response,
          ),
        ]),
      );

      await cubit.getCompetenciesTree();
      await emission;
    });

    test('createCompetency emits loading then saved', () async {
      when(
        () => repo.getCompetenciesTree(),
      ).thenAnswer((_) async => treeResponse());
      final cubit = createCubit();
      await waitForLoadTerminal(cubit);

      final response = CompetencyMutationResponse(
        data: competency(id: 'comp_created', name: 'Flutter'),
      );
      final request = CreateCompetencyRequestBody(
        name: 'Flutter',
        parentId: 'comp_parent',
        description: 'Flutter competency',
      );
      when(
        () => repo.createCompetency(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CompetenciesState>(isLoading),
          predicate<CompetenciesState>(
            (state) => savedResponse(state)?.data.id == 'comp_created',
          ),
        ]),
      );

      await cubit.createCompetency(request);
      await emission;

      final captured =
          verify(() => repo.createCompetency(captureAny())).captured.single
              as CreateCompetencyRequestBody;
      expect(captured.name, 'Flutter');
      expect(captured.parentId, 'comp_parent');
    });

    test('createCompetency emits loading then error when API fails', () async {
      when(
        () => repo.getCompetenciesTree(),
      ).thenAnswer((_) async => treeResponse());
      final cubit = createCubit();
      await waitForLoadTerminal(cubit);

      when(() => repo.createCompetency(any())).thenThrow(
        const NetworkExceptions.unprocessableEntity('Invalid competency'),
      );

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CompetenciesState>(isLoading),
          predicate<CompetenciesState>(
            (state) => stateError(state) == 'Invalid competency',
          ),
        ]),
      );

      await cubit.createCompetency(
        CreateCompetencyRequestBody(
          name: '',
          parentId: null,
          description: null,
        ),
      );
      await emission;
    });

    test('moveCompetency emits loading then saved', () async {
      when(
        () => repo.getCompetenciesTree(),
      ).thenAnswer((_) async => treeResponse());
      final cubit = createCubit();
      await waitForLoadTerminal(cubit);

      final response = CompetencyMutationResponse(
        data: competency(parentId: 'comp_parent'),
      );
      final request = MoveCompetencyRequestBody(
        parentId: 'comp_parent',
        hasChildren: false,
        hasQuestions: false,
      );
      when(
        () => repo.moveCompetency(any(), any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CompetenciesState>(isLoading),
          predicate<CompetenciesState>(
            (state) => savedResponse(state)?.data.parentId == 'comp_parent',
          ),
        ]),
      );

      await cubit.moveCompetency('comp_001', request);
      await emission;

      final captured = verify(
        () => repo.moveCompetency(captureAny(), captureAny()),
      ).captured;
      expect(captured[0], 'comp_001');
      expect(
        (captured[1] as MoveCompetencyRequestBody).parentId,
        'comp_parent',
      );
    });

    test('deleteCompetency emits loading then actionSuccess', () async {
      when(
        () => repo.getCompetenciesTree(),
      ).thenAnswer((_) async => treeResponse());
      final cubit = createCubit();
      await waitForLoadTerminal(cubit);

      final response = CompetencyActionResponse(message: 'Competency deleted');
      when(
        () => repo.deleteCompetency(any()),
      ).thenAnswer((_) async => response);

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CompetenciesState>(isLoading),
          predicate<CompetenciesState>(
            (state) => actionResponse(state)?.message == 'Competency deleted',
          ),
        ]),
      );

      await cubit.deleteCompetency('comp_001');
      await emission;

      final captured =
          verify(() => repo.deleteCompetency(captureAny())).captured.single
              as String;
      expect(captured, 'comp_001');
    });

    test('deleteCompetency emits loading then error when API fails', () async {
      when(
        () => repo.getCompetenciesTree(),
      ).thenAnswer((_) async => treeResponse());
      final cubit = createCubit();
      await waitForLoadTerminal(cubit);

      when(
        () => repo.deleteCompetency(any()),
      ).thenThrow(const NetworkExceptions.notFound('Competency not found'));

      final emission = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<CompetenciesState>(isLoading),
          predicate<CompetenciesState>(
            (state) => stateError(state) == 'Competency not found',
          ),
        ]),
      );

      await cubit.deleteCompetency('missing_comp');
      await emission;
    });
  });
}

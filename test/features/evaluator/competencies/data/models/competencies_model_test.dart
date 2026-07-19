import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_request_body.dart';
import 'package:eae_mobile/features/evaluator/competencies/data/models/competencies_response.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> competencyJson({
  String id = 'comp_001',
  String name = 'Mobile Development',
  String? parentId,
  List<Map<String, dynamic>>? children,
  bool? hasQuestions = false,
}) => {
  'id': id,
  'name': name,
  'tenant_id': 'tenant_001',
  'parent_id': parentId,
  'description': 'Competency description',
  'hierarchy_level': parentId == null ? 0 : 1,
  'is_active': true,
  'children': children,
  'has_questions': hasQuestions,
  'created_at': '2026-07-01T20:00:00.000Z',
  'updated_at': '2026-07-15T20:00:00.000Z',
};

void main() {
  group('CreateCompetencyRequestBody', () {
    test('fromJson and toJson use backend field names', () {
      final request = CreateCompetencyRequestBody.fromJson({
        'name': 'Flutter',
        'parent_id': 'comp_parent',
        'description': 'Flutter competency',
      });

      expect(request.name, 'Flutter');
      expect(request.parentId, 'comp_parent');
      expect(request.description, 'Flutter competency');
      expect(request.toJson(), {
        'name': 'Flutter',
        'parent_id': 'comp_parent',
        'description': 'Flutter competency',
      });
    });

    test('fromJson allows nullable parent_id and description', () {
      final request = CreateCompetencyRequestBody.fromJson({
        'name': 'Root competency',
        'parent_id': null,
        'description': null,
      });

      expect(request.parentId, isNull);
      expect(request.description, isNull);
    });

    test('fromJson throws when required name is missing', () {
      expect(
        () => CreateCompetencyRequestBody.fromJson({'parent_id': null}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('MoveCompetencyRequestBody', () {
    test('fromJson and toJson use backend field names', () {
      final request = MoveCompetencyRequestBody.fromJson({
        'parent_id': 'comp_parent',
        'has_children': true,
        'has_questions': false,
      });

      expect(request.parentId, 'comp_parent');
      expect(request.hasChildren, isTrue);
      expect(request.hasQuestions, isFalse);
      expect(request.toJson(), {
        'parent_id': 'comp_parent',
        'has_children': true,
        'has_questions': false,
      });
    });

    test('fromJson allows moving competency to root', () {
      final request = MoveCompetencyRequestBody.fromJson({
        'parent_id': null,
        'has_children': false,
        'has_questions': false,
      });

      expect(request.parentId, isNull);
    });
  });

  group('CompetenciesTreeResponse', () {
    test('fromJson parses nested competency tree', () {
      final response = CompetenciesTreeResponse.fromJson({
        'data': [
          competencyJson(
            children: [
              competencyJson(
                id: 'comp_child',
                name: 'Flutter',
                parentId: 'comp_001',
                children: const [],
                hasQuestions: true,
              ),
            ],
          ),
        ],
      });

      expect(response.data, hasLength(1));
      final root = response.data.single;
      expect(root.id, 'comp_001');
      expect(root.name, 'Mobile Development');
      expect(root.hasChildren, isTrue);
      expect(root.children, hasLength(1));
      expect(root.children!.single.id, 'comp_child');
      expect(root.children!.single.hasQuestions, isTrue);
    });

    test('fromJson parses empty tree', () {
      final response = CompetenciesTreeResponse.fromJson({'data': []});

      expect(response.data, isEmpty);
      expect(response.toJson(), {'data': response.data});
    });

    test('toJson keeps nested Competency objects', () {
      final competency = Competency.fromJson(
        competencyJson(children: const []),
      );
      final response = CompetenciesTreeResponse(data: [competency]);

      expect(response.toJson(), {'data': same(response.data)});
      expect(competency.toJson(), competencyJson(children: const []));
    });
  });

  group('CompetencyMutationResponse', () {
    test('fromJson parses created or moved competency', () {
      final response = CompetencyMutationResponse.fromJson({
        'data': competencyJson(id: 'comp_created', children: const []),
      });

      expect(response.data.id, 'comp_created');
      expect(response.data.hasChildren, isFalse);
      expect(response.toJson(), {'data': same(response.data)});
    });
  });

  group('CompetencyActionResponse', () {
    test('fromJson parses message', () {
      final response = CompetencyActionResponse.fromJson({
        'message': 'Competency deleted',
      });

      expect(response.message, 'Competency deleted');
      expect(response.toJson(), {'message': 'Competency deleted'});
    });

    test('fromJson defaults missing message to empty string', () {
      final response = CompetencyActionResponse.fromJson({});

      expect(response.message, '');
    });
  });
}

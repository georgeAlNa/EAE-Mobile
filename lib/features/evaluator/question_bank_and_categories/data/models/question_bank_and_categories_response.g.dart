// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_bank_and_categories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesTreeResponse _$CategoriesTreeResponseFromJson(
  Map<String, dynamic> json,
) => CategoriesTreeResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => QuestionCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CategoriesTreeResponseToJson(
  CategoriesTreeResponse instance,
) => <String, dynamic>{'data': instance.data};

CategoryMutationResponse _$CategoryMutationResponseFromJson(
  Map<String, dynamic> json,
) => CategoryMutationResponse(
  data: QuestionCategory.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CategoryMutationResponseToJson(
  CategoryMutationResponse instance,
) => <String, dynamic>{'data': instance.data};

QuestionsResponse _$QuestionsResponseFromJson(Map<String, dynamic> json) =>
    QuestionsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => QuestionBankItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestionsResponseToJson(QuestionsResponse instance) =>
    <String, dynamic>{'data': instance.data, 'meta': instance.meta};

QuestionDetailsResponse _$QuestionDetailsResponseFromJson(
  Map<String, dynamic> json,
) => QuestionDetailsResponse(
  data: QuestionBankItem.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuestionDetailsResponseToJson(
  QuestionDetailsResponse instance,
) => <String, dynamic>{'data': instance.data};

QuestionBankActionResponse _$QuestionBankActionResponseFromJson(
  Map<String, dynamic> json,
) => QuestionBankActionResponse(message: json['message'] as String? ?? '');

Map<String, dynamic> _$QuestionBankActionResponseToJson(
  QuestionBankActionResponse instance,
) => <String, dynamic>{'message': instance.message};

QuestionCategory _$QuestionCategoryFromJson(Map<String, dynamic> json) =>
    QuestionCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      tenantId: json['tenant_id'] as String?,
      parentId: json['parent_id'] as String?,
      categoryCode: json['category_code'] as String,
      description: json['description'] as String?,
      hierarchyLevel: (json['hierarchy_level'] as num).toInt(),
      isActive: json['is_active'] as bool,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => QuestionCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$QuestionCategoryToJson(QuestionCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'tenant_id': instance.tenantId,
      'parent_id': instance.parentId,
      'category_code': instance.categoryCode,
      'description': instance.description,
      'hierarchy_level': instance.hierarchyLevel,
      'is_active': instance.isActive,
      'children': instance.children,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

QuestionBankItem _$QuestionBankItemFromJson(Map<String, dynamic> json) =>
    QuestionBankItem(
      id: json['id'] as String,
      tenantId: json['tenant_id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      bloomLevel: (json['bloom_level'] as num).toInt(),
      difficultyLevel: (json['difficulty_level'] as num).toInt(),
      usageCount: (json['usage_count'] as num).toInt(),
      questionText: json['question_text'] as String,
      stem: json['stem'] as String,
      versionId: json['version_id'] as String,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => QuestionChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      psychometrics: json['psychometrics'] == null
          ? null
          : QuestionPsychometrics.fromJson(
              json['psychometrics'] as Map<String, dynamic>,
            ),
      correctAnswer: json['correct_answer'] as Map<String, dynamic>?,
      evaluatorInstructions: json['evaluator_instructions'] as List<dynamic>?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$QuestionBankItemToJson(QuestionBankItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant_id': instance.tenantId,
      'category_id': instance.categoryId,
      'title': instance.title,
      'type': instance.type,
      'bloom_level': instance.bloomLevel,
      'difficulty_level': instance.difficultyLevel,
      'usage_count': instance.usageCount,
      'question_text': instance.questionText,
      'stem': instance.stem,
      'version_id': instance.versionId,
      'choices': instance.choices,
      'psychometrics': instance.psychometrics,
      'correct_answer': instance.correctAnswer,
      'evaluator_instructions': instance.evaluatorInstructions,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

QuestionChoice _$QuestionChoiceFromJson(Map<String, dynamic> json) =>
    QuestionChoice(
      id: json['id'] as String,
      optionSequence: (json['option_sequence'] as num).toInt(),
      optionText: json['option_text'] as String,
      isCorrect: json['is_correct'] as bool,
    );

Map<String, dynamic> _$QuestionChoiceToJson(QuestionChoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'option_sequence': instance.optionSequence,
      'option_text': instance.optionText,
      'is_correct': instance.isCorrect,
    };

QuestionPsychometrics _$QuestionPsychometricsFromJson(
  Map<String, dynamic> json,
) => QuestionPsychometrics(
  pValue: json['p_value'],
  discriminationIndex: json['discrimination_index'],
);

Map<String, dynamic> _$QuestionPsychometricsToJson(
  QuestionPsychometrics instance,
) => <String, dynamic>{
  'p_value': instance.pValue,
  'discrimination_index': instance.discriminationIndex,
};

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      currentPage: (json['current_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'last_page': instance.lastPage,
    };

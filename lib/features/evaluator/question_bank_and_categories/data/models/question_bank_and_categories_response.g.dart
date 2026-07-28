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

BulkImportQuestionsResponse _$BulkImportQuestionsResponseFromJson(
  Map<String, dynamic> json,
) => BulkImportQuestionsResponse(
  data: BulkImportQuestionsResult.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$BulkImportQuestionsResponseToJson(
  BulkImportQuestionsResponse instance,
) => <String, dynamic>{'data': instance.data};

QuestionCompetencyResponse _$QuestionCompetencyResponseFromJson(
  Map<String, dynamic> json,
) => QuestionCompetencyResponse(
  data: QuestionCompetencyWeight.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuestionCompetencyResponseToJson(
  QuestionCompetencyResponse instance,
) => <String, dynamic>{'data': instance.data};

QuestionCompetenciesResponse _$QuestionCompetenciesResponseFromJson(
  Map<String, dynamic> json,
) => QuestionCompetenciesResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => QuestionCompetencyWeight.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionCompetenciesResponseToJson(
  QuestionCompetenciesResponse instance,
) => <String, dynamic>{'data': instance.data};

QuestionVersionApprovalResponse _$QuestionVersionApprovalResponseFromJson(
  Map<String, dynamic> json,
) => QuestionVersionApprovalResponse(
  data: QuestionVersionApproval.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuestionVersionApprovalResponseToJson(
  QuestionVersionApprovalResponse instance,
) => <String, dynamic>{'data': instance.data};

QuestionVersionPsychometricsResponse
_$QuestionVersionPsychometricsResponseFromJson(Map<String, dynamic> json) =>
    QuestionVersionPsychometricsResponse(
      data: QuestionVersionPsychometrics.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$QuestionVersionPsychometricsResponseToJson(
  QuestionVersionPsychometricsResponse instance,
) => <String, dynamic>{'data': instance.data};

BulkImportQuestionsResult _$BulkImportQuestionsResultFromJson(
  Map<String, dynamic> json,
) => BulkImportQuestionsResult(
  importLogId: json['import_log_id'] as String,
  total: (json['total'] as num).toInt(),
  successful: (json['successful'] as num).toInt(),
  failed: (json['failed'] as num).toInt(),
  errors:
      (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$BulkImportQuestionsResultToJson(
  BulkImportQuestionsResult instance,
) => <String, dynamic>{
  'import_log_id': instance.importLogId,
  'total': instance.total,
  'successful': instance.successful,
  'failed': instance.failed,
  'errors': instance.errors,
};

QuestionCompetencyWeight _$QuestionCompetencyWeightFromJson(
  Map<String, dynamic> json,
) => QuestionCompetencyWeight(
  weightId: json['weight_id'] as String,
  questionId: json['question_id'] as String,
  competencyId: json['competency_id'] as String,
  weightPercentage: json['weight_percentage'] as String,
  skillCategory: json['skill_category'] as String?,
  skillGapTrigger: json['skill_gap_trigger'] as String?,
  isPrimaryCompetency: json['is_primary_competency'] as bool,
  weightingMetadata: json['weighting_metadata'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  competency: json['competency'] == null
      ? null
      : QuestionCompetency.fromJson(json['competency'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuestionCompetencyWeightToJson(
  QuestionCompetencyWeight instance,
) => <String, dynamic>{
  'weight_id': instance.weightId,
  'question_id': instance.questionId,
  'competency_id': instance.competencyId,
  'weight_percentage': instance.weightPercentage,
  'skill_category': instance.skillCategory,
  'skill_gap_trigger': instance.skillGapTrigger,
  'is_primary_competency': instance.isPrimaryCompetency,
  'weighting_metadata': instance.weightingMetadata,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'competency': instance.competency,
};

QuestionCompetency _$QuestionCompetencyFromJson(Map<String, dynamic> json) =>
    QuestionCompetency(
      competencyId: json['competency_id'] as String,
      competencyName: json['competency_name'] as String,
      competencyType: json['competency_type'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$QuestionCompetencyToJson(QuestionCompetency instance) =>
    <String, dynamic>{
      'competency_id': instance.competencyId,
      'competency_name': instance.competencyName,
      'competency_type': instance.competencyType,
      'is_active': instance.isActive,
    };

QuestionVersionApproval _$QuestionVersionApprovalFromJson(
  Map<String, dynamic> json,
) => QuestionVersionApproval(
  versionId: json['version_id'] as String,
  questionId: json['question_id'] as String,
  createdByUserId: json['created_by_user_id'] as String,
  verNum: (json['ver_num'] as num).toInt(),
  questionText: json['question_text'] as String,
  questionType: json['question_type'] as String,
  questionStem: json['question_stem'] as String?,
  correctAnswerJson: json['correct_answer_json'] as Map<String, dynamic>?,
  explanationText: json['explanation_text'] as String?,
  evaluatorInstructions: json['evaluator_instructions'] as String?,
  approvalStatus: json['approval_status'] as String,
  approvedByUserId: json['approved_by_user_id'] as String?,
  usageCountInExams: (json['usage_count_in_exams'] as num).toInt(),
  contentHash: json['content_hash'] as String,
  versionMetadata: json['version_metadata'] as Map<String, dynamic>?,
  createdAt: json['created_at'] as String,
  approvedAt: json['approved_at'] as String?,
  deletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$QuestionVersionApprovalToJson(
  QuestionVersionApproval instance,
) => <String, dynamic>{
  'version_id': instance.versionId,
  'question_id': instance.questionId,
  'created_by_user_id': instance.createdByUserId,
  'ver_num': instance.verNum,
  'question_text': instance.questionText,
  'question_type': instance.questionType,
  'question_stem': instance.questionStem,
  'correct_answer_json': instance.correctAnswerJson,
  'explanation_text': instance.explanationText,
  'evaluator_instructions': instance.evaluatorInstructions,
  'approval_status': instance.approvalStatus,
  'approved_by_user_id': instance.approvedByUserId,
  'usage_count_in_exams': instance.usageCountInExams,
  'content_hash': instance.contentHash,
  'version_metadata': instance.versionMetadata,
  'created_at': instance.createdAt,
  'approved_at': instance.approvedAt,
  'deleted_at': instance.deletedAt,
};

QuestionVersionPsychometrics _$QuestionVersionPsychometricsFromJson(
  Map<String, dynamic> json,
) => QuestionVersionPsychometrics(
  psychometricId: json['psychometric_id'] as String,
  questionVersionId: json['question_version_id'] as String,
  tenantId: json['tenant_id'] as String,
  difficultyIndex: json['difficulty_index'] as String,
  discriminationIndex: json['discrimination_index'] as String,
  pointBiserial: json['point_biserial'] as String?,
  sampleSize: (json['sample_size'] as num).toInt(),
  correctCount: (json['correct_count'] as num).toInt(),
  isCalibrated: json['is_calibrated'] as bool,
  calibrationStatus: json['calibration_status'] as String,
  calibrationMetadata: json['calibration_metadata'] as Map<String, dynamic>?,
  lastCalibratedAt: json['last_calibrated_at'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$QuestionVersionPsychometricsToJson(
  QuestionVersionPsychometrics instance,
) => <String, dynamic>{
  'psychometric_id': instance.psychometricId,
  'question_version_id': instance.questionVersionId,
  'tenant_id': instance.tenantId,
  'difficulty_index': instance.difficultyIndex,
  'discrimination_index': instance.discriminationIndex,
  'point_biserial': instance.pointBiserial,
  'sample_size': instance.sampleSize,
  'correct_count': instance.correctCount,
  'is_calibrated': instance.isCalibrated,
  'calibration_status': instance.calibrationStatus,
  'calibration_metadata': instance.calibrationMetadata,
  'last_calibrated_at': instance.lastCalibratedAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

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
      id: json['id'] as String? ?? '',
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
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
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
      id: json['id'] as String? ?? '',
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

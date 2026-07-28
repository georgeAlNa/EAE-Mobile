// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_bank_and_categories_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCategoryRequestBody _$CreateCategoryRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateCategoryRequestBody(
  title: json['title'] as String,
  parentId: json['parent_id'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$CreateCategoryRequestBodyToJson(
  CreateCategoryRequestBody instance,
) => <String, dynamic>{
  'title': instance.title,
  'parent_id': instance.parentId,
  'description': instance.description,
};

MoveCategoryRequestBody _$MoveCategoryRequestBodyFromJson(
  Map<String, dynamic> json,
) => MoveCategoryRequestBody(title: json['title'] as String);

Map<String, dynamic> _$MoveCategoryRequestBodyToJson(
  MoveCategoryRequestBody instance,
) => <String, dynamic>{'title': instance.title};

CreateQuestionRequestBody _$CreateQuestionRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateQuestionRequestBody(
  categoryId: json['category_id'] as String,
  title: json['title'] as String,
  type: json['type'] as String,
  questionText: json['question_text'] as String,
  stem: json['stem'] as String,
  bloomLevel: (json['bloom_level'] as num).toInt(),
  difficultyLevel: (json['difficulty_level'] as num).toInt(),
  correctAnswer: json['correct_answer'],
  acceptedAnswers: (json['accepted_answers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  matchMode: json['match_mode'] as String?,
  psychometrics: json['psychometrics'] == null
      ? null
      : QuestionPsychometricsRequestBody.fromJson(
          json['psychometrics'] as Map<String, dynamic>,
        ),
  choices: (json['choices'] as List<dynamic>?)
      ?.map(
        (e) => QuestionChoiceRequestBody.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$CreateQuestionRequestBodyToJson(
  CreateQuestionRequestBody instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'title': instance.title,
  'type': instance.type,
  'question_text': instance.questionText,
  'stem': instance.stem,
  'bloom_level': instance.bloomLevel,
  'difficulty_level': instance.difficultyLevel,
  'correct_answer': instance.correctAnswer,
  'accepted_answers': instance.acceptedAnswers,
  'match_mode': instance.matchMode,
  'psychometrics': instance.psychometrics,
  'choices': instance.choices,
};

UpdateQuestionRequestBody _$UpdateQuestionRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateQuestionRequestBody(
  title: json['title'] as String,
  categoryId: json['category_id'] as String,
  bloomLevel: (json['bloom_level'] as num).toInt(),
  difficultyLevel: (json['difficulty_level'] as num).toInt(),
  questionText: json['question_text'] as String,
  stem: json['stem'] as String,
  correctAnswer: json['correct_answer'],
  acceptedAnswers: (json['accepted_answers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  matchMode: json['match_mode'] as String?,
  psychometrics: json['psychometrics'] == null
      ? null
      : QuestionPsychometricsRequestBody.fromJson(
          json['psychometrics'] as Map<String, dynamic>,
        ),
  choices: (json['choices'] as List<dynamic>?)
      ?.map(
        (e) => QuestionChoiceRequestBody.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$UpdateQuestionRequestBodyToJson(
  UpdateQuestionRequestBody instance,
) => <String, dynamic>{
  'title': instance.title,
  'category_id': instance.categoryId,
  'bloom_level': instance.bloomLevel,
  'difficulty_level': instance.difficultyLevel,
  'question_text': instance.questionText,
  'stem': instance.stem,
  'correct_answer': instance.correctAnswer,
  'accepted_answers': instance.acceptedAnswers,
  'match_mode': instance.matchMode,
  'psychometrics': instance.psychometrics,
  'choices': instance.choices,
};

QuestionPsychometricsRequestBody _$QuestionPsychometricsRequestBodyFromJson(
  Map<String, dynamic> json,
) => QuestionPsychometricsRequestBody(
  pValue: json['p_value'] as num,
  discriminationIndex: json['discrimination_index'] as num,
  usageCount: (json['usage_count'] as num).toInt(),
);

Map<String, dynamic> _$QuestionPsychometricsRequestBodyToJson(
  QuestionPsychometricsRequestBody instance,
) => <String, dynamic>{
  'p_value': instance.pValue,
  'discrimination_index': instance.discriminationIndex,
  'usage_count': instance.usageCount,
};

QuestionChoiceRequestBody _$QuestionChoiceRequestBodyFromJson(
  Map<String, dynamic> json,
) => QuestionChoiceRequestBody(
  optionText: json['option_text'] as String,
  isCorrect: json['is_correct'] as bool,
  optionSequence: (json['option_sequence'] as num).toInt(),
);

Map<String, dynamic> _$QuestionChoiceRequestBodyToJson(
  QuestionChoiceRequestBody instance,
) => <String, dynamic>{
  'option_text': instance.optionText,
  'is_correct': instance.isCorrect,
  'option_sequence': instance.optionSequence,
};

BulkImportQuestionsRequestBody _$BulkImportQuestionsRequestBodyFromJson(
  Map<String, dynamic> json,
) => BulkImportQuestionsRequestBody(
  filePath: json['file'] as String,
  fileName: json['file_name'] as String?,
);

Map<String, dynamic> _$BulkImportQuestionsRequestBodyToJson(
  BulkImportQuestionsRequestBody instance,
) => <String, dynamic>{
  'file': instance.filePath,
  'file_name': instance.fileName,
};

QuestionCompetencyRequestBody _$QuestionCompetencyRequestBodyFromJson(
  Map<String, dynamic> json,
) => QuestionCompetencyRequestBody(
  competencyId: json['competency_id'] as String,
  weightPercentage: json['weight_percentage'] as num,
  isPrimaryCompetency: json['is_primary_competency'] as bool,
);

Map<String, dynamic> _$QuestionCompetencyRequestBodyToJson(
  QuestionCompetencyRequestBody instance,
) => <String, dynamic>{
  'competency_id': instance.competencyId,
  'weight_percentage': instance.weightPercentage,
  'is_primary_competency': instance.isPrimaryCompetency,
};

QuestionVersionPsychometricsRequestBody
_$QuestionVersionPsychometricsRequestBodyFromJson(Map<String, dynamic> json) =>
    QuestionVersionPsychometricsRequestBody(
      difficultyIndex: json['difficulty_index'] as num,
      discriminationIndex: json['discrimination_index'] as num,
      sampleSize: (json['sample_size'] as num).toInt(),
      correctCount: (json['correct_count'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionVersionPsychometricsRequestBodyToJson(
  QuestionVersionPsychometricsRequestBody instance,
) => <String, dynamic>{
  'difficulty_index': instance.difficultyIndex,
  'discrimination_index': instance.discriminationIndex,
  'sample_size': instance.sampleSize,
  'correct_count': instance.correctCount,
};

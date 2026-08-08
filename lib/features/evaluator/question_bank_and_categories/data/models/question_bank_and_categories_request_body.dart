import 'package:json_annotation/json_annotation.dart';

part 'question_bank_and_categories_request_body.g.dart';

@JsonSerializable()
class CreateCategoryRequestBody {
  final String title;

  @JsonKey(name: 'parent_id')
  final String? parentId;

  final String? description;

  CreateCategoryRequestBody({
    required this.title,
    this.parentId,
    this.description,
  });

  factory CreateCategoryRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCategoryRequestBodyToJson(this);
}

@JsonSerializable()
class MoveCategoryRequestBody {
  final String title;

  MoveCategoryRequestBody({required this.title});

  factory MoveCategoryRequestBody.fromJson(Map<String, dynamic> json) =>
      _$MoveCategoryRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$MoveCategoryRequestBodyToJson(this);
}

@JsonSerializable()
class CreateQuestionRequestBody {
  @JsonKey(name: 'category_id')
  final String categoryId;

  final String title;
  final String type;

  @JsonKey(name: 'question_text')
  final String questionText;

  final String stem;

  @JsonKey(name: 'bloom_level')
  final int bloomLevel;

  @JsonKey(name: 'difficulty_level')
  final int difficultyLevel;

  @JsonKey(name: 'correct_answer')
  final dynamic correctAnswer;

  @JsonKey(name: 'accepted_answers')
  final List<String>? acceptedAnswers;

  @JsonKey(name: 'match_mode')
  final String? matchMode;

  final QuestionPsychometricsRequestBody? psychometrics;
  final List<QuestionChoiceRequestBody>? choices;

  CreateQuestionRequestBody({
    required this.categoryId,
    required this.title,
    required this.type,
    required this.questionText,
    required this.stem,
    required this.bloomLevel,
    required this.difficultyLevel,
    required this.correctAnswer,
    this.acceptedAnswers,
    this.matchMode,
    this.psychometrics,
    this.choices,
  });

  factory CreateQuestionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateQuestionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateQuestionRequestBodyToJson(this);
}

@JsonSerializable()
class UpdateQuestionRequestBody {
  final String title;

  @JsonKey(name: 'category_id')
  final String categoryId;

  @JsonKey(name: 'bloom_level')
  final int bloomLevel;

  @JsonKey(name: 'difficulty_level')
  final int difficultyLevel;

  @JsonKey(name: 'question_text')
  final String questionText;

  final String stem;

  @JsonKey(name: 'correct_answer')
  final dynamic correctAnswer;

  @JsonKey(name: 'accepted_answers')
  final List<String>? acceptedAnswers;

  @JsonKey(name: 'match_mode')
  final String? matchMode;

  final QuestionPsychometricsRequestBody? psychometrics;
  final List<QuestionChoiceRequestBody>? choices;

  UpdateQuestionRequestBody({
    required this.title,
    required this.categoryId,
    required this.bloomLevel,
    required this.difficultyLevel,
    required this.questionText,
    required this.stem,
    required this.correctAnswer,
    this.acceptedAnswers,
    this.matchMode,
    this.psychometrics,
    this.choices,
  });

  factory UpdateQuestionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateQuestionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateQuestionRequestBodyToJson(this);
}

@JsonSerializable(includeIfNull: false)
class PartialUpdateQuestionRequestBody {
  final String? title;

  @JsonKey(name: 'category_id')
  final String? categoryId;

  @JsonKey(name: 'bloom_level')
  final int? bloomLevel;

  @JsonKey(name: 'difficulty_level')
  final int? difficultyLevel;

  @JsonKey(name: 'question_text')
  final String? questionText;

  final String? stem;

  @JsonKey(name: 'correct_answer')
  final dynamic correctAnswer;

  @JsonKey(name: 'accepted_answers')
  final List<String>? acceptedAnswers;

  @JsonKey(name: 'match_mode')
  final String? matchMode;

  final QuestionPsychometricsRequestBody? psychometrics;
  final List<QuestionChoiceRequestBody>? choices;

  PartialUpdateQuestionRequestBody({
    this.title,
    this.categoryId,
    this.bloomLevel,
    this.difficultyLevel,
    this.questionText,
    this.stem,
    this.correctAnswer,
    this.acceptedAnswers,
    this.matchMode,
    this.psychometrics,
    this.choices,
  });

  factory PartialUpdateQuestionRequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$PartialUpdateQuestionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PartialUpdateQuestionRequestBodyToJson(this);
}

@JsonSerializable()
class QuestionPsychometricsRequestBody {
  @JsonKey(name: 'p_value')
  final num pValue;

  @JsonKey(name: 'discrimination_index')
  final num discriminationIndex;

  @JsonKey(name: 'usage_count')
  final int usageCount;

  QuestionPsychometricsRequestBody({
    required this.pValue,
    required this.discriminationIndex,
    required this.usageCount,
  });

  factory QuestionPsychometricsRequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$QuestionPsychometricsRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QuestionPsychometricsRequestBodyToJson(this);
}

@JsonSerializable()
class QuestionChoiceRequestBody {
  @JsonKey(name: 'option_text')
  final String optionText;

  @JsonKey(name: 'is_correct')
  final bool isCorrect;

  @JsonKey(name: 'option_sequence')
  final int optionSequence;

  QuestionChoiceRequestBody({
    required this.optionText,
    required this.isCorrect,
    required this.optionSequence,
  });

  factory QuestionChoiceRequestBody.fromJson(Map<String, dynamic> json) =>
      _$QuestionChoiceRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionChoiceRequestBodyToJson(this);
}

@JsonSerializable()
class BulkImportQuestionsRequestBody {
  @JsonKey(name: 'file')
  final String filePath;

  @JsonKey(name: 'file_name')
  final String? fileName;

  BulkImportQuestionsRequestBody({required this.filePath, this.fileName});

  factory BulkImportQuestionsRequestBody.fromJson(Map<String, dynamic> json) =>
      _$BulkImportQuestionsRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$BulkImportQuestionsRequestBodyToJson(this);
}

@JsonSerializable()
class QuestionCompetencyRequestBody {
  @JsonKey(name: 'competency_id')
  final String competencyId;

  @JsonKey(name: 'weight_percentage')
  final num weightPercentage;

  @JsonKey(name: 'is_primary_competency')
  final bool isPrimaryCompetency;

  QuestionCompetencyRequestBody({
    required this.competencyId,
    required this.weightPercentage,
    required this.isPrimaryCompetency,
  });

  factory QuestionCompetencyRequestBody.fromJson(Map<String, dynamic> json) =>
      _$QuestionCompetencyRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionCompetencyRequestBodyToJson(this);
}

@JsonSerializable()
class QuestionVersionPsychometricsRequestBody {
  @JsonKey(name: 'difficulty_index')
  final num difficultyIndex;

  @JsonKey(name: 'discrimination_index')
  final num discriminationIndex;

  @JsonKey(name: 'sample_size')
  final int sampleSize;

  @JsonKey(name: 'correct_count')
  final int correctCount;

  QuestionVersionPsychometricsRequestBody({
    required this.difficultyIndex,
    required this.discriminationIndex,
    required this.sampleSize,
    required this.correctCount,
  });

  factory QuestionVersionPsychometricsRequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$QuestionVersionPsychometricsRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$QuestionVersionPsychometricsRequestBodyToJson(this);
}

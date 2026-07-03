import '../../data/models/exams_management_response.dart';

List<ExamItem> filterExams(List<ExamItem> exams, String query) {
  if (query.isEmpty) return exams;

  return exams.where((exam) {
    final searchable = [
      exam.examName,
      exam.examCode,
      exam.examDescription,
      exam.examType,
      exam.assessmentMode,
      exam.examStatus,
    ].join(' ').toLowerCase();

    return searchable.contains(query);
  }).toList();
}

int countPublishedExams(List<ExamItem> exams) =>
    exams.where((exam) => exam.isPublished).length;

int countDraftExams(List<ExamItem> exams) =>
    exams.where((exam) => exam.examStatus.toLowerCase() == 'draft').length;

String formatExamDate(String? value) {
  if (value == null || value.isEmpty) return 'Not set';

  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;

  final local = parsed.toLocal();
  return '${local.year}-${_twoDigits(local.month)}-${_twoDigits(local.day)}';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

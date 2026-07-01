import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../data/models/live_sessions_and_enrollment_management_request_body.dart';
import '../data/models/live_sessions_and_enrollment_management_response.dart';
import '../data/repos/live_sessions_and_enrollment_management_repo.dart';

part 'live_sessions_and_enrollment_management_state.dart';
part 'live_sessions_and_enrollment_management_cubit.freezed.dart';

class LiveSessionsAndEnrollmentManagementCubit
    extends Cubit<LiveSessionsAndEnrollmentManagementState> {
  final LiveSessionsAndEnrollmentManagementRepo
  liveSessionsAndEnrollmentManagementRepo;

  LiveSessionsAndEnrollmentManagementCubit({
    required this.liveSessionsAndEnrollmentManagementRepo,
  }) : super(const LiveSessionsAndEnrollmentManagementState.initial());

  String? _currentExamId;

  Future<void> getEnrollments(String examId) async {
    _currentExamId = examId;
    emit(const LiveSessionsAndEnrollmentManagementState.loading());

    try {
      final response = await liveSessionsAndEnrollmentManagementRepo
          .enrollments(examId);
      emit(LiveSessionsAndEnrollmentManagementState.loaded(response));
    } on NetworkExceptions catch (e) {
      emit(
        LiveSessionsAndEnrollmentManagementState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const LiveSessionsAndEnrollmentManagementState.error(
          error: 'Failed to load enrollments',
        ),
      );
    }
  }

  Future<void> refreshCurrentExam() async {
    final examId = _currentExamId;
    if (examId == null || examId.isEmpty) return;
    await getEnrollments(examId);
  }

  Future<void> createEnrollment(
    String examId,
    CreateEnrollmentRequestBody requestBody,
  ) async {
    _currentExamId = examId;
    emit(const LiveSessionsAndEnrollmentManagementState.loading());

    try {
      final response = await liveSessionsAndEnrollmentManagementRepo
          .createEnrollment(examId, requestBody);
      emit(LiveSessionsAndEnrollmentManagementState.createSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        LiveSessionsAndEnrollmentManagementState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const LiveSessionsAndEnrollmentManagementState.error(
          error: 'Failed to create enrollment',
        ),
      );
    }
  }

  Future<void> deleteEnrollment(String examId, String enrollmentId) async {
    _currentExamId = examId;
    emit(const LiveSessionsAndEnrollmentManagementState.loading());

    try {
      final response = await liveSessionsAndEnrollmentManagementRepo
          .deleteEnrollment(examId, enrollmentId);
      emit(LiveSessionsAndEnrollmentManagementState.actionSuccess(response));
    } on NetworkExceptions catch (e) {
      emit(
        LiveSessionsAndEnrollmentManagementState.error(
          error: NetworkExceptions.getErrorMessage(e),
        ),
      );
    } catch (e) {
      emit(
        const LiveSessionsAndEnrollmentManagementState.error(
          error: 'Failed to delete enrollment',
        ),
      );
    }
  }
}

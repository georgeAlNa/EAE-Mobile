import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/loading_widget.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../logic/live_sessions_and_enrollment_management_cubit.dart';
import '../widgets/create_enrollment_sheet.dart';
import '../widgets/enrollments_list_section.dart';
import '../widgets/live_sessions_enrollment_header.dart';

class LiveSessionsAndEnrollmentManagementScreen extends StatefulWidget {
  const LiveSessionsAndEnrollmentManagementScreen({super.key});

  @override
  State<LiveSessionsAndEnrollmentManagementScreen> createState() =>
      _LiveSessionsAndEnrollmentManagementScreenState();
}

class _LiveSessionsAndEnrollmentManagementScreenState
    extends State<LiveSessionsAndEnrollmentManagementScreen> {
  final _examIdController = TextEditingController();
  String? _currentExamId;

  @override
  void dispose() {
    _examIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SafeArea(
        child:
            BlocConsumer<
              LiveSessionsAndEnrollmentManagementCubit,
              LiveSessionsAndEnrollmentManagementState
            >(
              listener: (context, state) {
                state.maybeWhen(
                  createSuccess: (_) {
                    showAppSnackBar(context, 'Enrollment created successfully');
                    context
                        .read<LiveSessionsAndEnrollmentManagementCubit>()
                        .refreshCurrentExam();
                  },
                  actionSuccess: (_) {
                    showAppSnackBar(context, 'Action completed successfully');
                    context
                        .read<LiveSessionsAndEnrollmentManagementCubit>()
                        .refreshCurrentExam();
                  },
                  error: (error) => showAppSnackBar(context, error),
                  orElse: () {},
                );
              },
              builder: (screenContext, state) {
                final enrollments = state.maybeWhen(
                  loaded: (response) => response.data,
                  orElse: () => null,
                );
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        final examId = _currentExamId;
                        if (examId == null || examId.isEmpty) return;
                        await screenContext
                            .read<LiveSessionsAndEnrollmentManagementCubit>()
                            .getEnrollments(examId);
                      },
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 18.h,
                        ),
                        children: [
                          LiveSessionsEnrollmentHeader(
                            examIdController: _examIdController,
                            onLoadEnrollments: () =>
                                _loadEnrollments(screenContext),
                            onCreateEnrollment:
                                _currentExamId == null ||
                                    _currentExamId!.isEmpty
                                ? null
                                : () => _showCreateEnrollmentSheet(
                                    screenContext,
                                    _currentExamId!,
                                  ),
                          ),
                          verticalSpace(18),
                          if (enrollments == null)
                            _EmptyEnrollmentState(hasExamId: _currentExamId != null)
                          else
                            EnrollmentsListSection(
                              enrollments: enrollments,
                              onDelete: (enrollment) => _confirmDeleteEnrollment(
                                context: screenContext,
                                examId: enrollment.examId,
                                enrollmentId: enrollment.id,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: ColoredBox(
                          color: AppColors.neutralColor.withValues(alpha: 0.65),
                          child: const LoadingWidget(),
                        ),
                      ),
                  ],
                );
              },
            ),
      ),
    );
  }

  void _loadEnrollments(BuildContext context) {
    final examId = _examIdController.text.trim();
    if (examId.isEmpty) {
      showAppSnackBar(context, 'Please enter exam ID');
      return;
    }

    setState(() {
      _currentExamId = examId;
    });
    context
        .read<LiveSessionsAndEnrollmentManagementCubit>()
        .getEnrollments(examId);
  }

  Future<void> _showCreateEnrollmentSheet(
    BuildContext context,
    String examId,
  ) async {
    final cubit = context.read<LiveSessionsAndEnrollmentManagementCubit>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.neutralColor,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CreateEnrollmentSheet(examId: examId),
      ),
    );
  }

  Future<void> _confirmDeleteEnrollment({
    required BuildContext context,
    required String examId,
    required String enrollmentId,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete enrollment'),
        content: const Text('Delete this enrollment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      context
          .read<LiveSessionsAndEnrollmentManagementCubit>()
          .deleteEnrollment(examId, enrollmentId);
    }
  }
}

class _EmptyEnrollmentState extends StatelessWidget {
  final bool hasExamId;

  const _EmptyEnrollmentState({required this.hasExamId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Text(
        hasExamId
            ? 'No enrollments loaded'
            : 'Enter an exam ID to load enrollments.',
        textAlign: TextAlign.center,
        style: AppTextStyles.font14DarkGreyRegular.copyWith(
          color: AppColors.tertiaryColor6,
        ),
      ),
    );
  }
}

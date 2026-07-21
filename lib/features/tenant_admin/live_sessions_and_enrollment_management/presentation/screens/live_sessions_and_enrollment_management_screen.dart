import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/public_widgets/app_state_widgets.dart';
import '../../../../../core/public_widgets/snack_bar_widget.dart';
import '../../../shared/presentation/widgets/tenant_admin_ux_widgets.dart';
import '../../data/models/live_sessions_and_enrollment_management_response.dart';
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
  final _searchController = TextEditingController();
  String? _currentExamId;
  String _query = '';
  EnrollmentsResponse? _enrollmentsResponse;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _examIdController.dispose();
    _searchController.dispose();
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
                  loaded: (response) {
                    _enrollmentsResponse = response;
                  },
                  createSuccess: (_) {
                    showAppSnackBar(context, 'Enrollment created successfully');
                    context
                        .read<LiveSessionsAndEnrollmentManagementCubit>()
                        .refreshCurrentExam();
                  },
                  deleteSuccess: (_) {
                    showAppSnackBar(context, 'Enrollment deleted successfully');
                    context
                        .read<LiveSessionsAndEnrollmentManagementCubit>()
                        .refreshCurrentExam();
                  },
                  createError: (error) => showAppSnackBar(context, error),
                  deleteError: (error) => showAppSnackBar(context, error),
                  loadError: (error) {
                    if (_enrollmentsResponse != null) {
                      showAppSnackBar(context, error);
                    }
                  },
                  orElse: () {},
                );
              },
              builder: (screenContext, state) {
                final loadedResponse = state.whenOrNull(
                  loaded: (response) => response,
                );
                if (loadedResponse != null) {
                  _enrollmentsResponse = loadedResponse;
                }

                final enrollments = _enrollmentsResponse?.data;
                final isEnrollmentsLoading = state.maybeWhen(
                  enrollmentsLoading: () => true,
                  orElse: () => false,
                );
                final isActionLoading = state.maybeWhen(
                  createLoading: () => true,
                  deleteLoading: () => true,
                  orElse: () => false,
                );
                final loadError = state.maybeWhen(
                  loadError: (error) => error,
                  orElse: () => null,
                );
                final visibleEnrollments = enrollments == null
                    ? null
                    : _filterEnrollments(enrollments);

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
                            searchController: _searchController,
                            enrollmentsCount: enrollments?.length,
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
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: _EnrollmentBody(
                              key: ValueKey(
                                '${visibleEnrollments?.length}-$_query-$loadError-$isEnrollmentsLoading',
                              ),
                              currentExamId: _currentExamId,
                              enrollments: visibleEnrollments,
                              query: _query,
                              isInitialLoading:
                                  enrollments == null && isEnrollmentsLoading,
                              loadError: enrollments == null ? loadError : null,
                              onRetry: () {
                                final examId = _currentExamId;
                                if (examId == null || examId.isEmpty) return;
                                screenContext
                                    .read<
                                      LiveSessionsAndEnrollmentManagementCubit
                                    >()
                                    .getEnrollments(examId);
                              },
                              onDelete: (enrollment) =>
                                  _confirmDeleteEnrollment(
                                    context: screenContext,
                                    examId: enrollment.examId,
                                    enrollmentId: enrollment.id,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isEnrollmentsLoading && enrollments != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AppSkeletonBox(
                          width: double.infinity,
                          height: 4.h,
                          borderRadius: 0,
                        ),
                      ),
                    if (isActionLoading)
                      Positioned(
                        left: 24.w,
                        right: 24.w,
                        bottom: 14.h,
                        child: _EnrollmentActionProgressBanner(state: state),
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
      _enrollmentsResponse = null;
      _query = '';
      _searchController.clear();
    });
    context.read<LiveSessionsAndEnrollmentManagementCubit>().getEnrollments(
      examId,
    );
  }

  List<EnrollmentItem> _filterEnrollments(List<EnrollmentItem> enrollments) {
    if (_query.isEmpty) return enrollments;

    return enrollments.where((enrollment) {
      return enrollment.candidateUserId.toLowerCase().contains(_query) ||
          enrollment.cohortId.toLowerCase().contains(_query) ||
          enrollment.enrollmentStatus.toLowerCase().contains(_query);
    }).toList();
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
      context.read<LiveSessionsAndEnrollmentManagementCubit>().deleteEnrollment(
        examId,
        enrollmentId,
      );
    }
  }
}

class _EnrollmentBody extends StatelessWidget {
  final String? currentExamId;
  final List<EnrollmentItem>? enrollments;
  final String query;
  final bool isInitialLoading;
  final String? loadError;
  final VoidCallback onRetry;
  final ValueChanged<EnrollmentItem> onDelete;

  const _EnrollmentBody({
    super.key,
    required this.currentExamId,
    required this.enrollments,
    required this.query,
    required this.isInitialLoading,
    required this.loadError,
    required this.onRetry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const AppSkeletonDataList(
        itemCount: 3,
        showDescription: false,
        chipCount: 0,
        infoRowCount: 4,
        showActionButton: true,
      );
    }

    if (loadError != null) {
      return SizedBox(
        height: 260.h,
        child: AppRetryErrorView(
          title: loadError!,
          message: 'Unable to load enrollments for this exam.',
          onRetry: onRetry,
        ),
      );
    }

    final items = enrollments;
    if (items == null) {
      return TenantAdminEmptyState(
        icon: Icons.search_outlined,
        title: currentExamId == null
            ? 'Load an exam first'
            : 'No enrollments loaded',
        message: currentExamId == null
            ? 'Enter an exam ID to load enrollments.'
            : 'No enrollment records were returned for this exam.',
      );
    }

    return EnrollmentsListSection(
      enrollments: items,
      query: query,
      onDelete: onDelete,
    );
  }
}

class _EnrollmentActionProgressBanner extends StatelessWidget {
  final LiveSessionsAndEnrollmentManagementState state;

  const _EnrollmentActionProgressBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final message = state.maybeWhen(
      createLoading: () => 'Creating enrollment...',
      deleteLoading: () => 'Deleting enrollment...',
      orElse: () => 'Working...',
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryColor9,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 18.w,
              height: 18.w,
              child: AppSkeletonBox(height: 18.h, borderRadius: 9),
            ),
            horizontalSpace(10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.neutralColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

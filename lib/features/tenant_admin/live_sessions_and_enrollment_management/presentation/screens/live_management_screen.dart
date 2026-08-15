import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../exam_sessions/logic/exam_sessions_cubit.dart';
import '../../logic/live_sessions_and_enrollment_management_cubit.dart';
import 'live_sessions_and_enrollment_management_screen.dart';
import 'tenant_admin_exam_sessions_screen.dart';

class LiveManagementScreen extends StatelessWidget {
  const LiveManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.neutralColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TabBar(
                    labelColor: AppColors.secondaryColor7,
                    unselectedLabelColor: AppColors.tertiaryColor6,
                    indicatorColor: AppColors.secondaryColor7,
                    tabs: [
                      Tab(text: AppStrings.tr('Exam Sessions')),
                      Tab(text: AppStrings.tr('Enrollments')),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    BlocProvider(
                      create: (_) => getIt<ExamSessionsCubit>(
                        param1: ExamSessionsRole.tenantAdmin,
                      ),
                      child: const TenantAdminExamSessionsScreen(),
                    ),
                    BlocProvider(
                      create: (_) =>
                          getIt<LiveSessionsAndEnrollmentManagementCubit>(),
                      child: const LiveSessionsAndEnrollmentManagementScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

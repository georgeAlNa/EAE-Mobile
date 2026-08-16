import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../analytics/logic/analytics_cubit.dart';
import '../../../../analytics/presentation/screens/analytics_screen.dart';
import '../../../../certificates/logic/certificates_cubit.dart';
import '../../../../certificates/presentation/screens/certificates_screen.dart';
import '../../../../workflows/logic/workflow_cubit.dart';
import '../../../../workflows/presentation/screens/workflows_screen.dart';
import '../../logic/result_publication_cubit.dart';
import 'result_publication_screen.dart';

class ResultsManagementScreen extends StatelessWidget {
  const ResultsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: ColoredBox(
        color: AppColors.neutralColor,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Material(
                color: AppColors.neutralColor,
                child: TabBar(
                  labelColor: AppColors.primaryColor9,
                  indicatorColor: AppColors.secondaryColor7,
                  tabs: [
                    Tab(text: AppStrings.tr('Analytics')),
                    Tab(text: AppStrings.tr('Workflows')),
                    Tab(text: AppStrings.tr('Result Publication')),
                    Tab(text: AppStrings.tr('Certificates')),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    BlocProvider(
                      create: (_) => getIt<AnalyticsCubit>(),
                      child: const AnalyticsScreen(useScaffold: false),
                    ),
                    BlocProvider(
                      create: (_) => getIt<WorkflowCubit>(
                        param1: WorkflowRole.tenantAdmin,
                      ),
                      child: WorkflowsScreen(title: AppStrings.tr('Workflows')),
                    ),
                    BlocProvider(
                      create: (_) => getIt<ResultPublicationCubit>(),
                      child: const ResultPublicationScreen(),
                    ),
                    BlocProvider(
                      create: (_) => getIt<CertificatesCubit>(
                        param1: CertificateRole.tenantAdmin,
                      ),
                      child: CertificatesScreen(
                        role: CertificateRole.tenantAdmin,
                        title: AppStrings.tr('Certificates'),
                        useScaffold: false,
                      ),
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

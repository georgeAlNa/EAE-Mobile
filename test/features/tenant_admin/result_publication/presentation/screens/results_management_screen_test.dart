import 'package:eae_mobile/features/analytics/data/models/analytics_models.dart';
import 'package:eae_mobile/features/analytics/logic/analytics_cubit.dart';
import 'package:eae_mobile/features/certificates/data/models/certificates_response.dart';
import 'package:eae_mobile/features/certificates/logic/certificates_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/logic/result_publication_cubit.dart';
import 'package:eae_mobile/features/tenant_admin/result_publication/presentation/screens/results_management_screen.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_response.dart';
import 'package:eae_mobile/features/workflows/logic/workflow_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../../../../../helpers/widget_test_helpers.dart';

class FakeAnalyticsCubit extends Cubit<AnalyticsState>
    implements AnalyticsCubit {
  FakeAnalyticsCubit()
    : super(
        const AnalyticsState.ready(
          viewData: AnalyticsViewData(
            totalFinalizedResults: 3,
            averagePercentage: 78.5,
            averageProgress: 0.785,
            hasFinalizedResults: true,
          ),
        ),
      );

  @override
  Future<void> getAnalyticsDashboard() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeWorkflowCubit extends Cubit<WorkflowState> implements WorkflowCubit {
  FakeWorkflowCubit() : super(const WorkflowState.initial());

  @override
  List<ApprovalWorkflowData> currentWorkflows = [];

  @override
  bool get hasMore => false;

  @override
  WorkflowRole get role => WorkflowRole.tenantAdmin;

  @override
  Future<void> loadWorkflows({
    String? status,
    String? workflowType,
    String? resourceType,
    String? resourceId,
    int? perPage,
  }) async {}

  @override
  Future<void> refresh() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeResultPublicationCubit extends Cubit<ResultPublicationState>
    implements ResultPublicationCubit {
  FakeResultPublicationCubit() : super(const ResultPublicationState.initial());

  @override
  final TextEditingController sessionIdController = TextEditingController();

  @override
  final TextEditingController workflowResourceIdController =
      TextEditingController();

  @override
  Future<void> close() {
    sessionIdController.dispose();
    workflowResourceIdController.dispose();
    return super.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCertificatesCubit extends Cubit<CertificatesState>
    implements CertificatesCubit {
  FakeCertificatesCubit() : super(const CertificatesState.initial());

  @override
  List<Certificate> currentCertificates = [];

  @override
  bool get hasMore => false;

  @override
  bool get canManageCertificates => true;

  @override
  Future<void> loadCertificates({int perPage = 15}) async {}

  @override
  Future<void> refresh() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUp(() async {
    await GetIt.I.reset();
    GetIt.I.registerFactory<AnalyticsCubit>(FakeAnalyticsCubit.new);
    GetIt.I.registerFactoryParam<WorkflowCubit, WorkflowRole, void>(
      (_, _) => FakeWorkflowCubit(),
    );
    GetIt.I.registerFactory<ResultPublicationCubit>(
      FakeResultPublicationCubit.new,
    );
    GetIt.I.registerFactoryParam<CertificatesCubit, CertificateRole, void>(
      (_, _) => FakeCertificatesCubit(),
    );
    await resetWidgetTestPreferences();
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  testWidgets('results management exposes analytics and existing result tabs', (
    tester,
  ) async {
    await pumpTestApp(tester, child: const ResultsManagementScreen());

    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Workflows'), findsOneWidget);
    expect(find.text('Result Publication'), findsOneWidget);
    expect(find.text('Certificates'), findsOneWidget);
    expect(find.text('Assessment Analytics'), findsOneWidget);
  });
}

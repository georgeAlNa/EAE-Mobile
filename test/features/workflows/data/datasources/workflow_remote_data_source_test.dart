import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/core/networking/api_services_impl.dart';
import 'package:eae_mobile/core/networking/app_link_url.dart';
import 'package:eae_mobile/features/workflows/data/datasources/workflow_remote_data_source.dart';
import 'package:eae_mobile/features/workflows/data/models/workflow_request_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApiServicesImpl extends Mock implements ApiServicesImpl {}

Future<void> resetPrefs() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppSharedPreferences().init();
  await AppSharedPreferences().clear();
  await AppSharedPreferences().setString(
    AppSharedPrefKeys.token,
    'access-token',
  );
}

Map<String, dynamic> emptyResponse() => {
  'data': [],
  'meta': {'current_page': 1, 'per_page': 15, 'total': 0, 'last_page': 1},
};

Map<String, dynamic> actionResponse({String status = 'pending'}) => {
  'message': 'ok',
  'data': {
    'workflow_id': 'workflow-001',
    'resource_type': 'assessment_result',
    'resource_id': 'result-001',
    'workflow_type': 'result_publication',
    'current_workflow_status': status,
    'current_stage_key': 'approval',
    'workflow_initiated_at': '2026-08-15T10:00:00Z',
    'workflow_completed_at': null,
    'workflow_metadata': {},
  },
};

void main() {
  late MockApiServicesImpl apiServicesImpl;
  late WorkflowRemoteDataSourceImpl remoteDataSource;

  setUpAll(() {
    registerFallbackValue(<String, String>{});
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() async {
    await resetPrefs();
    apiServicesImpl = MockApiServicesImpl();
    remoteDataSource = WorkflowRemoteDataSourceImpl(
      apiServicesImpl: apiServicesImpl,
    );
    when(
      () => apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: any(named: 'queryParams'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => emptyResponse());
  });

  test(
    'GET workflows without filters sends empty params and real token',
    () async {
      await remoteDataSource.getWorkflows();

      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.workflows,
          queryParams: {},
          token: 'access-token',
        ),
      ).called(1);
    },
  );

  test('builds supported filters and pagination params only', () async {
    await remoteDataSource.getWorkflows(status: 'pending');
    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: {'status': 'pending'},
        token: 'access-token',
      ),
    ).called(1);

    await remoteDataSource.getWorkflows(status: 'approved');
    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: {'status': 'approved'},
        token: 'access-token',
      ),
    ).called(1);

    await remoteDataSource.getWorkflows(workflowType: 'result_publication');
    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: {'workflow_type': 'result_publication'},
        token: 'access-token',
      ),
    ).called(1);

    await remoteDataSource.getWorkflows(workflowType: 'exam_publication');
    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: {'workflow_type': 'exam_publication'},
        token: 'access-token',
      ),
    ).called(1);

    await remoteDataSource.getWorkflows(resourceType: 'exam');
    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: {'resource_type': 'exam'},
        token: 'access-token',
      ),
    ).called(1);

    await remoteDataSource.getWorkflows(resourceId: 'exam-001');
    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: {'resource_id': 'exam-001'},
        token: 'access-token',
      ),
    ).called(1);

    await remoteDataSource.getWorkflows(
      status: 'pending',
      workflowType: 'exam_publication',
      resourceType: 'exam',
      resourceId: 'exam-001',
      page: 2,
      perPage: 50,
    );
    final captured =
        verify(
              () => apiServicesImpl.get(
                AppLinkUrl.workflows,
                queryParams: captureAny(named: 'queryParams'),
                token: 'access-token',
              ),
            ).captured.last
            as Map<String, String>;
    expect(captured, {
      'status': 'pending',
      'workflow_type': 'exam_publication',
      'resource_type': 'exam',
      'resource_id': 'exam-001',
      'page': '2',
      'per_page': '50',
    });
    expect(captured.containsKey('evaluator_id'), isFalse);
    expect(captured.containsKey('X-Tenant-ID'), isFalse);
    expect(captured.containsKey('initiated_by_user_id'), isFalse);
    expect(captured.containsKey('user_id'), isFalse);
    expect(captured.containsKey('created_by'), isFalse);
  });

  test(
    'supports assessment_result as an explicit resource_type filter',
    () async {
      await remoteDataSource.getWorkflows(resourceType: 'assessment_result');

      verify(
        () => apiServicesImpl.get(
          AppLinkUrl.workflows,
          queryParams: {'resource_type': 'assessment_result'},
          token: 'access-token',
        ),
      ).called(1);
    },
  );

  test('does not send null or blank params', () async {
    await remoteDataSource.getWorkflows(
      status: '',
      workflowType: ' ',
      resourceType: null,
      resourceId: null,
    );

    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.workflows,
        queryParams: {},
        token: 'access-token',
      ),
    ).called(1);
  });

  test('creates workflow with exact endpoint, body, and token', () async {
    when(
      () => apiServicesImpl.post(
        AppLinkUrl.workflows,
        body: any(named: 'body'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => actionResponse());

    await remoteDataSource.createWorkflow(
      CreateApprovalWorkflowRequestBody(
        resourceType: 'assessment_result',
        resourceId: 'result-001',
        workflowType: 'result_publication',
      ),
    );

    verify(
      () => apiServicesImpl.post(
        AppLinkUrl.workflows,
        body: {
          'resource_type': 'assessment_result',
          'resource_id': 'result-001',
          'workflow_type': 'result_publication',
        },
        token: 'access-token',
      ),
    ).called(1);
  });

  test('gets workflow details with exact endpoint and token', () async {
    when(
      () => apiServicesImpl.get(
        AppLinkUrl.workflowDetails('workflow-001'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => actionResponse());

    await remoteDataSource.getWorkflow('workflow-001');

    verify(
      () => apiServicesImpl.get(
        AppLinkUrl.workflowDetails('workflow-001'),
        token: 'access-token',
      ),
    ).called(1);
  });

  test(
    'approves workflow with exact endpoint, token, and no request body',
    () async {
      when(
        () => apiServicesImpl.post(
          AppLinkUrl.approveWorkflow('workflow-001'),
          token: any(named: 'token'),
        ),
      ).thenAnswer((_) async => actionResponse(status: 'approved'));

      await remoteDataSource.approveWorkflow('workflow-001');

      verify(
        () => apiServicesImpl.post(
          AppLinkUrl.approveWorkflow('workflow-001'),
          token: 'access-token',
        ),
      ).called(1);
    },
  );
}

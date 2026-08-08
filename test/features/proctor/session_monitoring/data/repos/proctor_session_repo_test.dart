import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/datasources/proctor_session_remote_data_source.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_request_body.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/models/proctor_session_response.dart';
import 'package:eae_mobile/features/proctor/session_monitoring/data/repos/proctor_session_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProctorSessionRemoteDataSource extends Mock
    implements ProctorSessionRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockProctorSessionRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late ProctorSessionRepo repo;

  setUpAll(() {
    registerFallbackValue(VoidSanctionRequestBody(reason: ''));
    registerFallbackValue(SubmitProctoringEventRequestBody());
    registerFallbackValue('');
  });

  setUp(() {
    remoteDataSource = MockProctorSessionRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = ProctorSessionRepo(
      proctorSessionRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  void connected() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
  }

  void offline() {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
  }

  group('ProctorSessionRepo', () {
    test('session control methods call remote when connected', () async {
      connected();
      final response = ProctorActionResponse(message: 'ok');
      when(
        () => remoteDataSource.suspendExamSession(any()),
      ).thenAnswer((_) async => response);
      when(
        () => remoteDataSource.resumeExamSession(any()),
      ).thenAnswer((_) async => response);
      when(
        () => remoteDataSource.terminateExamSession(any()),
      ).thenAnswer((_) async => response);

      expect(await repo.suspendExamSession('session_001'), same(response));
      expect(await repo.resumeExamSession('session_001'), same(response));
      expect(await repo.terminateExamSession('session_001'), same(response));
    });

    test('sanctions and events call remote when connected', () async {
      connected();
      final action = ProctorActionResponse(message: 'ok');
      final sanctions = SessionSanctionsResponse(data: const []);
      when(
        () => remoteDataSource.getSessionSanctions(any()),
      ).thenAnswer((_) async => sanctions);
      when(
        () => remoteDataSource.voidSanction(any(), any()),
      ).thenAnswer((_) async => action);
      when(
        () => remoteDataSource.submitProctoringEvent(any(), any()),
      ).thenAnswer((_) async => action);
      when(
        () => remoteDataSource.getProctoringEvents(any()),
      ).thenAnswer((_) async => action);

      expect(await repo.getSessionSanctions('session_001'), same(sanctions));
      expect(
        await repo.voidSanction(
          'sanction_001',
          VoidSanctionRequestBody(reason: 'duplicate'),
        ),
        same(action),
      );
      expect(
        await repo.submitProctoringEvent(
          'session_001',
          SubmitProctoringEventRequestBody(eventType: 'focus_lost'),
        ),
        same(action),
      );
      expect(await repo.getProctoringEvents('session_001'), same(action));
    });

    test('throws noInternetConnection when offline', () {
      offline();

      expect(
        () => repo.suspendExamSession('session_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      expect(
        () => repo.getSessionSanctions('session_001'),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.suspendExamSession(any()));
    });
  });
}

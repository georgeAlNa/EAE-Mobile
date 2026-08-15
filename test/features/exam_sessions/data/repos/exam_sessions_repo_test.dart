import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/exam_sessions/data/datasources/exam_sessions_remote_data_source.dart';
import 'package:eae_mobile/features/exam_sessions/data/models/exam_sessions_list_response.dart';
import 'package:eae_mobile/features/exam_sessions/data/repos/exam_sessions_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExamSessionsRemoteDataSource extends Mock
    implements ExamSessionsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

ExamSessionsListResponse response() => ExamSessionsListResponse(
  data: const [],
  meta: ExamSessionsPaginationMeta(
    currentPage: 1,
    perPage: 15,
    total: 0,
    lastPage: 1,
  ),
);

void main() {
  late MockExamSessionsRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late ExamSessionsRepo repo;

  setUpAll(() {
    registerFallbackValue('');
    registerFallbackValue(1);
  });

  setUp(() {
    remoteDataSource = MockExamSessionsRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repo = ExamSessionsRepo(
      examSessionsRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  test('calls remote when connected and forwards filters', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    final expected = response();
    when(
      () => remoteDataSource.getExamSessions(
        status: any(named: 'status'),
        examId: any(named: 'examId'),
        candidateId: any(named: 'candidateId'),
        page: any(named: 'page'),
        perPage: any(named: 'perPage'),
      ),
    ).thenAnswer((_) async => expected);

    final actual = await repo.getExamSessions(
      status: 'completed',
      examId: 'exam-uuid',
      candidateId: 'candidate-uuid',
      page: 2,
      perPage: 50,
    );

    expect(actual, same(expected));
    verify(
      () => remoteDataSource.getExamSessions(
        status: 'completed',
        examId: 'exam-uuid',
        candidateId: 'candidate-uuid',
        page: 2,
        perPage: 50,
      ),
    ).called(1);
  });

  test('throws noInternetConnection when offline', () {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);

    expect(
      () => repo.getExamSessions(),
      throwsA(const NetworkExceptions.noInternetConnection()),
    );
  });
}

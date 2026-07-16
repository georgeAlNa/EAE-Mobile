import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:eae_mobile/core/networking/network_info.dart';
import 'package:eae_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/login/login_response.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_request_body.dart';
import 'package:eae_mobile/features/auth/data/models/logout/logout_response.dart';
import 'package:eae_mobile/features/auth/data/repos/auth_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockAuthRemoteDataSource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late AuthRepo authRepo;

  final loginRequest = LoginRequestBody(
    email: 'candidate@tenant.com',
    password: 'P@ssw0rd!',
  );

  final loginResponse = LoginResponse(
    data: LoginData(
      status: 'authenticated',
      userId: 'usr_001',
      sessionId: 'sess_001',
      mfaRequired: false,
      authenticatedAt: '2026-07-15T20:00:00.000Z',
      token: 'access-token',
    ),
  );

  setUpAll(() {
    registerFallbackValue(LoginRequestBody(email: '', password: ''));
    registerFallbackValue(LogoutRequestBody(sessionId: ''));
  });

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    networkInfo = MockNetworkInfo();
    authRepo = AuthRepo(
      authRemoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group('login', () {
    test('returns LoginResponse when connected and remote succeeds', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.login(any()),
      ).thenAnswer((_) async => loginResponse);

      final result = await authRepo.login(loginRequest);

      expect(result, same(loginResponse));
      final captured =
          verify(() => remoteDataSource.login(captureAny())).captured.single
              as LoginRequestBody;
      expect(captured.email, loginRequest.email);
      expect(captured.password, loginRequest.password);
      verify(() => networkInfo.isConnected).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('throws noInternetConnection when offline', () async {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => authRepo.login(loginRequest),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.login(any()));
    });

    test('propagates unauthorized API errors as NetworkExceptions', () async {
      const exception = NetworkExceptions.unauthorizedRequest(
        'Invalid credentials',
      );

      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.login(any())).thenThrow(exception);

      expect(() => authRepo.login(loginRequest), throwsA(exception));
    });

    test('propagates validation API errors as NetworkExceptions', () async {
      const exception = NetworkExceptions.unprocessableEntity(
        'Validation error',
      );

      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.login(any())).thenThrow(exception);

      expect(() => authRepo.login(loginRequest), throwsA(exception));
    });
  });

  group('logout', () {
    test('returns LogoutResponse when connected and remote succeeds', () async {
      final logoutRequest = LogoutRequestBody(sessionId: 'sess_001');
      final logoutResponse = LogoutResponse(message: 'Logged out');

      when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => remoteDataSource.logout(any()),
      ).thenAnswer((_) async => logoutResponse);

      final result = await authRepo.logout(logoutRequest);

      expect(result, same(logoutResponse));
      final captured =
          verify(() => remoteDataSource.logout(captureAny())).captured.single
              as LogoutRequestBody;
      expect(captured.sessionId, 'sess_001');
    });

    test('throws noInternetConnection when logout is attempted offline', () {
      when(() => networkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => authRepo.logout(LogoutRequestBody(sessionId: 'sess_001')),
        throwsA(const NetworkExceptions.noInternetConnection()),
      );
      verifyNever(() => remoteDataSource.logout(any()));
    });
  });
}

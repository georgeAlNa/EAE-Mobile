import '../../../../core/networking/error/error_handler/network_exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/forgot_password/forgot_password_request_body.dart';
import '../models/forgot_password/forgot_password_response.dart';
import '../models/login/login_request_body.dart';
import '../models/login/login_response.dart';
import '../models/logout/logout_request_body.dart';
import '../models/logout/logout_response.dart';
import '../models/refresh_token/refresh_token_request_body.dart';
import '../models/refresh_token/refresh_token_response.dart';
import '../models/register/register_request_body.dart';
import '../models/register/register_response.dart';
import '../models/reset_password/reset_password_request_body.dart';
import '../models/reset_password/reset_password_response.dart';

class AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;
  AuthRepo({required this.authRemoteDataSource, required this.networkInfo});

  Future<LoginResponse> login(LoginRequestBody login) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.login(
          LoginRequestBody(email: login.email, password: login.password),
        );
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<RegisterResponse> register(RegisterRequestBody register) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.register(register);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ForgotPasswordResponse> forgotPassword(
    ForgotPasswordRequestBody forgotPassword,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.forgotPassword(forgotPassword);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequestBody resetPassword,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.resetPassword(resetPassword);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<RefreshTokenResponse> refreshToken(
    RefreshTokenRequestBody refreshToken,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.refreshToken(refreshToken);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }

  Future<LogoutResponse> logout(LogoutRequestBody logout) async {
    if (await networkInfo.isConnected) {
      try {
        return await authRemoteDataSource.logout(logout);
      } catch (e) {
        throw NetworkExceptions.getException(e);
      }
    } else {
      throw const NetworkExceptions.noInternetConnection();
    }
  }
}

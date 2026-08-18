import 'package:dio/dio.dart';
import 'package:eae_mobile/core/networking/error/error_handler/network_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkExceptions', () {
    test('extracts nested backend error message from bad responses', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/api/v1/auth/login'),
        statusCode: 401,
        data:
            '{"error":{"code":"invalid_credentials","message":"Invalid credentials."}}',
      );

      final exception = NetworkExceptions.handleResponse(response);

      expect(
        NetworkExceptions.getErrorMessage(exception),
        'Invalid credentials.',
      );
    });

    test('falls back to readable unauthorized message when body is empty', () {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/api/v1/auth/login'),
        statusCode: 401,
      );

      final exception = NetworkExceptions.handleResponse(response);

      expect(
        NetworkExceptions.getErrorMessage(exception),
        'Unauthorized request',
      );
    });
  });
}

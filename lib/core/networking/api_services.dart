import 'dart:async';

import 'package:dio/dio.dart';

typedef FormDataBuilder = FutureOr<FormData> Function();

abstract class ApiServices {
  Future<dynamic> get(String path, {Map<String, String>? queryParams});

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    FormData? formData,
    FormDataBuilder? formDataBuilder,
  });

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    FormData? formData,
    FormDataBuilder? formDataBuilder,
  });

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    FormData? formData,
    FormDataBuilder? formDataBuilder,
  });

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  });
}

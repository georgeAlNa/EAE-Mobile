import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/shared_pref_keys.dart';
import '../helpers/app_shared_preferences.dart';
import 'api_services.dart';
import 'app_link_url.dart';

late Map<String, dynamic> _headers;

Future<void> setHeaders({String? token}) async {
  _headers = {
    "Accept": Headers.jsonContentType,
    "Accept-Timezone": DateTime.now().timeZoneName,
  };

  final baseUri = Uri.tryParse(AppLinkUrl.baseUrl);
  final baseHost = baseUri?.host.toLowerCase();
  final isLocalApi =
      baseHost == 'localhost' || baseHost == '127.0.0.1' || baseHost == '::1';
  if (isLocalApi && AppLinkUrl.apiHostHeader.isNotEmpty) {
    _headers['Host'] = AppLinkUrl.apiHostHeader;
  }

  if (token != null && token.isNotEmpty) {
    _headers["Authorization"] = "Bearer $token";
  }
}

dynamic _parseJsonResponse(Response<dynamic> response) {
  if (response.statusCode == 204) {
    return <String, dynamic>{};
  }

  if (response.data is String) {
    final data = (response.data as String).trim();
    if (data.isEmpty) {
      return <String, dynamic>{};
    }

    return jsonDecode(data);
  } else if (response.data is Map<String, dynamic>) {
    return response.data;
  } else {
    return <String, dynamic>{};
  }
}

class ApiServicesImpl implements ApiServices {
  final Dio _dio = GetIt.I.get<Dio>();
  Future<bool>? _refreshTokenFuture;

  ApiServicesImpl() {
    _dio.options
      ..baseUrl = AppLinkUrl
          .baseUrl // Put here your base Url
      ..responseType = ResponseType.plain
      ..sendTimeout = const Duration(minutes: 1)
      ..receiveTimeout = const Duration(minutes: 1)
      ..connectTimeout = const Duration(minutes: 1)
      ..followRedirects = true;

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
          request: true,
          responseBody: true,
        ),
      );
    }
  }

  String? get _storedToken {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.token);
  }

  String? get _storedSessionId {
    final sharedPref = AppSharedPreferences();
    return sharedPref.getString(AppSharedPrefKeys.sessionId);
  }

  bool _shouldAttemptTokenRefresh(DioException error, String path) {
    final statusCode = error.response?.statusCode;
    if (statusCode != 401) return false;

    final excludedPaths = {
      AppLinkUrl.login,
      AppLinkUrl.register,
      AppLinkUrl.refreshToken,
      AppLinkUrl.logout,
    };
    if (excludedPaths.contains(path)) return false;

    final token = _storedToken;
    final sessionId = _storedSessionId;
    return token != null &&
        token.isNotEmpty &&
        sessionId != null &&
        sessionId.isNotEmpty;
  }

  Future<bool> _refreshAuthToken() {
    final currentRefresh = _refreshTokenFuture;
    if (currentRefresh != null) {
      return currentRefresh;
    }

    final refresh = _performTokenRefresh();
    _refreshTokenFuture = refresh;
    return refresh.whenComplete(() => _refreshTokenFuture = null);
  }

  Future<bool> _performTokenRefresh() async {
    final token = _storedToken;
    final sessionId = _storedSessionId;
    if (token == null ||
        token.isEmpty ||
        sessionId == null ||
        sessionId.isEmpty) {
      return false;
    }

    try {
      await setHeaders(token: token);
      final response = await _dio.post(
        AppLinkUrl.refreshToken,
        data: {'session_id': sessionId},
        options: Options(
          headers: _headers,
          contentType: Headers.jsonContentType,
        ),
      );

      final parsed = _parseJsonResponse(response);
      final data = parsed is Map<String, dynamic>
          ? parsed['data'] as Map<String, dynamic>?
          : null;
      final newToken = data?['token'] as String?;
      final newSessionId = data?['session_id'] as String?;

      if (newToken == null || newToken.isEmpty) {
        return false;
      }

      final sharedPref = AppSharedPreferences();
      await sharedPref.setString(AppSharedPrefKeys.token, newToken);
      if (newSessionId != null && newSessionId.isNotEmpty) {
        await sharedPref.setString(AppSharedPrefKeys.sessionId, newSessionId);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    String? token,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      await setHeaders(token: token ?? _storedToken);
      final response = await _dio.delete(
        path,
        queryParameters: queryParams,
        data: body,
        options: Options(headers: _headers),
      );
      return _parseJsonResponse(response);
    } on DioException catch (error) {
      if (retryOnUnauthorized &&
          _shouldAttemptTokenRefresh(error, path) &&
          await _refreshAuthToken()) {
        return delete(
          path,
          queryParams: queryParams,
          body: body,
          token: _storedToken,
          retryOnUnauthorized: false,
        );
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParams,
    String? token,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      await setHeaders(token: token ?? _storedToken);
      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: _headers),
      );
      return _parseJsonResponse(response);
    } on DioException catch (error) {
      if (retryOnUnauthorized &&
          _shouldAttemptTokenRefresh(error, path) &&
          await _refreshAuthToken()) {
        return get(
          path,
          queryParams: queryParams,
          token: _storedToken,
          retryOnUnauthorized: false,
        );
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getPlain(
    String path, {
    Map<String, String>? queryParams,
    String? token,
    String? accept,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      await setHeaders(token: token ?? _storedToken);
      final headers = Map<String, dynamic>.from(_headers);
      if (accept != null && accept.isNotEmpty) {
        headers['Accept'] = accept;
      }

      final response = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(headers: headers, responseType: ResponseType.plain),
      );

      return response.data?.toString() ?? '';
    } on DioException catch (error) {
      if (retryOnUnauthorized &&
          _shouldAttemptTokenRefresh(error, path) &&
          await _refreshAuthToken()) {
        return getPlain(
          path,
          queryParams: queryParams,
          token: _storedToken,
          accept: accept,
          retryOnUnauthorized: false,
        );
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<int>> getBytes(
    String path, {
    Map<String, String>? queryParams,
    String? token,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      await setHeaders(token: token ?? _storedToken);
      final response = await _dio.get<List<int>>(
        path,
        queryParameters: queryParams,
        options: Options(headers: _headers, responseType: ResponseType.bytes),
      );

      return response.data ?? <int>[];
    } on DioException catch (error) {
      if (retryOnUnauthorized &&
          _shouldAttemptTokenRefresh(error, path) &&
          await _refreshAuthToken()) {
        return getBytes(
          path,
          queryParams: queryParams,
          token: _storedToken,
          retryOnUnauthorized: false,
        );
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    FormData? formData,
    FormDataBuilder? formDataBuilder,
    String? token,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      await setHeaders(token: token ?? _storedToken);
      final resolvedFormData = formDataBuilder != null
          ? await formDataBuilder()
          : formData;

      final response = await _dio.post(
        path,
        queryParameters: queryParams,
        data: resolvedFormData ?? body,
        options: Options(
          headers: _headers,
          contentType: resolvedFormData == null
              ? Headers.jsonContentType
              : null,
        ),
      );
      return _parseJsonResponse(response);
    } on DioException catch (error) {
      if (retryOnUnauthorized &&
          _shouldAttemptTokenRefresh(error, path) &&
          await _refreshAuthToken()) {
        return post(
          path,
          queryParams: queryParams,
          body: body,
          formData: formData,
          formDataBuilder: formDataBuilder,
          token: _storedToken,
          retryOnUnauthorized: false,
        );
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    FormData? formData,
    FormDataBuilder? formDataBuilder,
    String? token,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      await setHeaders(token: token ?? _storedToken);
      final resolvedFormData = formDataBuilder != null
          ? await formDataBuilder()
          : formData;
      final response = await _dio.put(
        path,
        queryParameters: queryParams,
        data: resolvedFormData ?? body,
        options: Options(
          headers: _headers,
          contentType: resolvedFormData == null
              ? Headers.jsonContentType
              : null,
        ),
      );
      return _parseJsonResponse(response);
    } on DioException catch (error) {
      if (retryOnUnauthorized &&
          _shouldAttemptTokenRefresh(error, path) &&
          await _refreshAuthToken()) {
        return put(
          path,
          queryParams: queryParams,
          body: body,
          formData: formData,
          formDataBuilder: formDataBuilder,
          token: _storedToken,
          retryOnUnauthorized: false,
        );
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    FormData? formData,
    FormDataBuilder? formDataBuilder,
    // bool? hasToken,
    String? token,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      await setHeaders(token: token ?? _storedToken);
      final resolvedFormData = formDataBuilder != null
          ? await formDataBuilder()
          : formData;
      final response = await _dio.patch(
        path,
        queryParameters: queryParams,
        data: resolvedFormData ?? body,
        options: Options(
          headers: _headers,
          contentType: resolvedFormData == null
              ? Headers.jsonContentType
              : null,
        ),
      );
      return _parseJsonResponse(response);
    } on DioException catch (error) {
      if (retryOnUnauthorized &&
          _shouldAttemptTokenRefresh(error, path) &&
          await _refreshAuthToken()) {
        return patch(
          path,
          queryParams: queryParams,
          body: body,
          formData: formData,
          formDataBuilder: formDataBuilder,
          token: _storedToken,
          retryOnUnauthorized: false,
        );
      }
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}

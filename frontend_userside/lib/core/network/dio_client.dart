import 'package:dio/dio.dart';
import 'package:frontend_userside/config/backend_config.dart';
import 'package:frontend_userside/core/error/exceptions.dart';
import 'package:frontend_userside/core/storage/local_storage.dart';

class DioClient {
  late final Dio _dio;
  final LocalStorage _localStorage;

  DioClient({LocalStorage? localStorage})
    : _localStorage = localStorage ?? LocalStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: BackendConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _localStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          final exception = _handleDioError(e);
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: exception,
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    );
  }

  Dio get dio => _dio;

  ServerException _handleDioError(DioException error) {
    String message = 'An unexpected network error occurred';
    int? statusCode = error.response?.statusCode;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timed out. Please check your network connection.';
    } else if (error.type == DioExceptionType.badResponse) {
      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response!.data as Map<String, dynamic>;
        message =
            data['message'] as String? ??
            'Server returned an error (${error.response?.statusCode})';
      } else {
        message = 'Server error (${error.response?.statusCode})';
      }
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Cannot reach backend server. Please verify backend status.';
    }

    return ServerException(message: message, statusCode: statusCode);
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error is ServerException
          ? e.error as ServerException
          : ServerException(message: e.message ?? 'Unknown GET error');
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error is ServerException
          ? e.error as ServerException
          : ServerException(message: e.message ?? 'Unknown POST error');
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error is ServerException
          ? e.error as ServerException
          : ServerException(message: e.message ?? 'Unknown PUT error');
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error is ServerException
          ? e.error as ServerException
          : ServerException(message: e.message ?? 'Unknown DELETE error');
    }
  }
}

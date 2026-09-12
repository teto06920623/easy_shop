import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import 'dio_factory.dart';

abstract class ApiService {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path, {dynamic data});
  Future<dynamic> put(String path, {dynamic data});
  Future<dynamic> delete(String path, {dynamic data});
}

class DioApiService implements ApiService {
  final Dio _dio = DioFactory.getDio();

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    String message = 'Unexpected error occurred';

    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('message')) {
      message = responseData['message'].toString();
    } else if (responseData is String) {
      message = responseData;
    }

    if (statusCode == 401 || statusCode == 403) {
      return UnauthorizedException(message: message);
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }
    return ServerException(message: message, statusCode: statusCode);
  }
}

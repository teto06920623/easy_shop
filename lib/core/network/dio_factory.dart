import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'api_interceptors.dart';

class DioFactory {
  static Dio? _dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio();
      _dio!
        ..options.baseUrl = ApiConstants.baseUrl
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut
          ..options.headers['Connection'] = 'close' 
        ..interceptors.add(AppInterceptors())
        ..interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            requestHeader: true,
          ),
        );
      return _dio!;
    } else {
      return _dio!;
    }
  }
}
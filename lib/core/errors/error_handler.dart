import 'package:dio/dio.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return ServerFailure(message: error.toString());
  }

  

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(message: 'Connection timed out with server');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        String message = 'Something went wrong';

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('message')) {
          final msgData = responseData['message'];

          
          if (msgData is Map) {
            
            message = msgData.values
                .map((e) => (e as List).first.toString())
                .join('\n');
          } else {
            message = msgData.toString();
          }
        } else if (responseData is String) {
          message = responseData;
        }

        if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedFailure(message: message);
        }
        return ServerFailure(message: message, statusCode: statusCode);
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      default:
        return const ServerFailure(
          message: 'Unexpected network error occurred',
        );
    }
  }
}

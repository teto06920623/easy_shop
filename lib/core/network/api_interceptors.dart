import 'package:dio/dio.dart';
import '../helpers/secure_storage_helper.dart';
import 'api_constants.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['x-api-key'] = ApiConstants.apiKey;

    final token = await SecureStorageHelper.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';

    if (options.data is! FormData) {
      options.headers['Content-Type'] = 'application/json';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await SecureStorageHelper.logout();
    }
    return handler.next(err);
  }
}

import 'package:dio/dio.dart';
import 'package:toonflix_fe/app/model/api/api_client.dart';
import 'package:toonflix_fe/app/model/service/app_logger.dart';
import 'package:toonflix_fe/app/model/service/navigation_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await ApiClient.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      AppLogger.e('Failed to read token', e);
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await ApiClient.clearToken();
        AppLogger.w('Token cleared due to 401 error');

        await NavigationService.navigateToLogin();
      } catch (e) {
        AppLogger.e('Failed to clear token or navigate', e);
      }
    }

    handler.next(err);
  }
}

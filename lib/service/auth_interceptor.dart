import 'package:dio/dio.dart';
import 'package:toonflix_fe/model/api/api_client.dart';
import 'package:toonflix_fe/service/app_logger.dart';
import 'package:toonflix_fe/service/navigation_service.dart';

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
      // 토큰 읽기 실패 시 로그 출력 (선택사항)
      AppLogger.w('Failed to read token', e);
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 Unauthorized 에러 처리
    if (err.response?.statusCode == 401) {
      try {
        // 토큰이 만료되었거나 유효하지 않은 경우 토큰 삭제
        await ApiClient.clearToken();
        AppLogger.w('Token cleared due to 401 error');

        // 로그인 화면으로 자동 리다이렉트
        if (NavigationService.hasContext) {
          await NavigationService.navigateToLogin();
        }
      } catch (e) {
        AppLogger.e('Failed to clear token or navigate', e);
      }
    }

    // 에러를 그대로 전달하여 각 화면에서 처리할 수 있도록 함
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 응답 로깅 (개발 환경에서만)
    if (response.statusCode == 200 || response.statusCode == 201) {
      AppLogger.d(
        '✅ ${response.requestOptions.method} ${response.requestOptions.path}',
      );
    }

    handler.next(response);
  }
}

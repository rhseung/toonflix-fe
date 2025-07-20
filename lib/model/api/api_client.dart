import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toonflix_fe/model/api/retrofit_client.dart';
import 'package:toonflix_fe/service/auth_interceptor.dart';
import 'package:toonflix_fe/service/logging_interceptor.dart';

class ApiClient {
  static Dio? _dio;
  static RetrofitClient? _retrofitClient;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _accessTokenKey = 'access_token';

  static Dio _createDio() {
    final dio = Dio();

    // 기본 설정
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.options.sendTimeout = const Duration(seconds: 5);

    // Auth Interceptor 추가
    dio.interceptors.add(AuthInterceptor());

    // 커스텀 로깅 Interceptor 추가 (개발 환경에서만)
    dio.interceptors.add(
      const LoggingInterceptor(
        enabled: true, // 배포 시에는 false로 변경
        logRequest: true,
        logResponse: false, // 응답은 너무 길 수 있으므로 필요시에만
        logError: true,
      ),
    );

    return dio;
  }

  static RetrofitClient get instance {
    _dio ??= _createDio();
    _retrofitClient ??= RetrofitClient(_dio!);
    return _retrofitClient!;
  }

  static void resetClient() {
    _dio = null;
    _retrofitClient = null;
  }

  // 토큰 관련 헬퍼 메서드들
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _accessTokenKey);
    return token != null && token.isNotEmpty;
  }
}

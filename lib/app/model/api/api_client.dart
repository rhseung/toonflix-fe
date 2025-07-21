import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:toonflix_fe/app/model/api/retrofit_client.dart';
import 'package:toonflix_fe/app/model/api/auth_interceptor.dart';

class ApiClient {
  static Dio? _dio;
  static RetrofitClient? _retrofitClient;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _accessTokenKey = 'access_token';

  static Dio _createDio() {
    final dio = Dio();

    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);
    dio.options.sendTimeout = const Duration(seconds: 5);

    dio.interceptors.add(AuthInterceptor());

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

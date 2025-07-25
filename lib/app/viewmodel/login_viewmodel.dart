import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toonflix_fe/app/model/api/api_client.dart';
import 'package:toonflix_fe/app/model/api/retrofit_client.dart';
import 'package:toonflix_fe/app/model/dto/login_dto.dart';
import 'package:toonflix_fe/app/model/repo/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository(RetrofitClient(Dio()));
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  bool get isFormValid {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  bool get isEmailValid {
    final email = _emailController.text.trim();
    return email.isNotEmpty && email.contains('@');
  }

  Future<bool> login() async {
    if (!isFormValid) {
      _setError('이메일과 비밀번호를 입력해주세요');
      return false;
    }

    if (!isEmailValid) {
      _setError('올바른 이메일 형식을 입력해주세요');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final loginDto = LoginDto(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final loginResult = await _authRepository.login(loginDto);

      await ApiClient.saveToken(loginResult.accessToken);

      return true;
    } catch (e) {
      _setError(_getLoginErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _clearError();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _setError(String error) {
    _errorMessage = error;
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _clearError() {
    _errorMessage = null;
    if (!_disposed) {
      notifyListeners();
    }
  }

  String _getLoginErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return '네트워크 연결이 불안정합니다';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            return '이메일 또는 비밀번호가 올바르지 않습니다';
          } else if (statusCode == 500) {
            return '서버 오류가 발생했습니다';
          } else {
            return '로그인에 실패했습니다 (코드: $statusCode)';
          }
        case DioExceptionType.connectionError:
          return '인터넷 연결을 확인해주세요';
        case DioExceptionType.cancel:
          return '요청이 취소되었습니다';
        default:
          return '알 수 없는 오류가 발생했습니다';
      }
    }
    return '로그인에 실패했습니다';
  }

  @override
  void dispose() {
    _disposed = true;
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

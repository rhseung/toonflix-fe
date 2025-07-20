import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return '네트워크 연결이 불안정합니다';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 400:
              return '잘못된 요청입니다';
            case 401:
              return '인증이 필요합니다. 다시 로그인해주세요';
            case 403:
              return '접근 권한이 없습니다';
            case 404:
              return '요청한 데이터를 찾을 수 없습니다';
            case 409:
              return '이미 존재하는 데이터입니다';
            case 422:
              return '입력한 정보를 확인해주세요';
            case 500:
              return '서버 오류가 발생했습니다';
            case 502:
            case 503:
            case 504:
              return '서버가 일시적으로 사용할 수 없습니다';
            default:
              return '요청을 처리할 수 없습니다 (코드: $statusCode)';
          }
        case DioExceptionType.connectionError:
          return '인터넷 연결을 확인해주세요';
        case DioExceptionType.cancel:
          return '요청이 취소되었습니다';
        default:
          return '알 수 없는 오류가 발생했습니다';
      }
    }
    return '오류가 발생했습니다';
  }

  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static String getLoginErrorMessage(dynamic error) {
    if (error is DioException && error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        return '이메일 또는 비밀번호가 올바르지 않습니다';
      }
    }
    return getErrorMessage(error);
  }
}

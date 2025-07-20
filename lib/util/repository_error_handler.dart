import 'package:toonflix_fe/service/app_logger.dart';
import 'package:toonflix_fe/util/error_handler.dart';

/// Repository에서 공통으로 사용할 수 있는 에러 처리 mixin
mixin RepositoryErrorHandler {
  /// API 호출을 감싸서 에러를 처리하는 헬퍼 메서드
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      // 필요시 로깅 추가
      AppLogger.e('API Error: ${ErrorHandler.getErrorMessage(e)}', e);
      rethrow; // 에러를 다시 던져서 UI에서 처리할 수 있도록 함
    }
  }
}

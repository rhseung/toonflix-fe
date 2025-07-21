import 'package:toonflix_fe/app/model/service/app_logger.dart';
import 'package:toonflix_fe/util/error_handler.dart';

mixin RepositoryErrorHandler {
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      AppLogger.e('API Error: ${ErrorHandler.getErrorMessage(e)}', e);
      rethrow;
    }
  }
}

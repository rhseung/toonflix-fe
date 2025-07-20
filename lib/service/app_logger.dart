import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  static late Logger _logger;

  // 초기화 메서드 (main에서 호출)
  static void initialize({Level level = Level.debug}) {
    _logger = Logger(
      level: level,
      printer: PrettyPrinter(
        methodCount: 0, // 메서드 스택 수 제한
        errorMethodCount: 5, // 에러 시에만 더 많은 스택 표시
        lineLength: 80, // 한 줄 최대 길이
        colors: true, // 색상 사용
        printEmojis: true, // 이모지 사용
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // 시간 표시
      ),
    );
  }

  // Getter for easy access
  static Logger get instance => _logger;

  // Convenience methods
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  // 배포 환경에서는 로그 레벨을 높여서 성능 최적화
  static void setProductionMode() {
    _logger = Logger(
      level: Level.warning, // 경고 이상만 로깅
      printer: SimplePrinter(colors: false),
    );
  }
}

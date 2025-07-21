import 'package:flutter/material.dart';
import 'package:toonflix_fe/app/view/login_screen.dart';
import 'package:toonflix_fe/app/view/main_screen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static Future<void> navigateToLogin() async {
    if (context == null) return;

    await Navigator.of(context!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  static Future<void> navigateToMain() async {
    if (context == null) return;

    await Navigator.of(context!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }

  static void goBack() {
    if (context == null) return;

    Navigator.of(context!).pop();
  }

  static Future<void> navigateTo(Widget screen) async {
    if (context == null) return;

    await Navigator.of(
      context!,
    ).push(MaterialPageRoute(builder: (context) => screen));
  }

  static Future<void> navigateAndReplace(Widget screen) async {
    if (context == null) return;

    await Navigator.of(
      context!,
    ).pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }
}

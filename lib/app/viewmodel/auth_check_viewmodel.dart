import 'package:flutter/material.dart';
import 'package:toonflix_fe/app/model/api/api_client.dart';
import 'package:toonflix_fe/app/model/service/navigation_service.dart';

class AuthCheckViewModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _disposed = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  bool get isDisposed => _disposed;

  Future<void> checkAuthStatus() async {
    _setLoading(true);

    try {
      _isLoggedIn = await ApiClient.isLoggedIn();

      if (!_disposed) {
        if (_isLoggedIn) {
          await NavigationService.navigateToMain();
        } else {
          await NavigationService.navigateToLogin();
        }
      }
    } catch (e) {
      if (!_disposed) {
        await NavigationService.navigateToLogin();
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

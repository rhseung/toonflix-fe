import 'package:flutter/material.dart';
import 'package:toonflix_fe/service/navigation_service.dart';
import 'package:toonflix_fe/viewmodel/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted && _viewModel.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() {});
  }

  Future<void> _handleLogin() async {
    final success = await _viewModel.login();
    if (success && mounted) {
      await NavigationService.navigateToMain();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Toonflix',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            TextField(
              controller: _viewModel.emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email_rounded),
                errorText: _viewModel.hasError && !_viewModel.isEmailValid
                    ? '올바른 이메일을 입력해주세요'
                    : null,
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: !_viewModel.isLoading,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _viewModel.passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_rounded),
              ),
              obscureText: true,
              enabled: !_viewModel.isLoading,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _viewModel.isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _viewModel.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('로그인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:toonflix_fe/view/login_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Toonflix', home: const LoginScreen());
  }
}

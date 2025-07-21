import 'package:flutter/material.dart';
import 'package:toonflix_fe/app/model/service/navigation_service.dart';
import 'package:toonflix_fe/app/view/auth_check_screen.dart';

// TODO: 회원가입, 게시글 작성, 좋아요, 검색, 채팅

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toonflix',
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      themeMode: ThemeMode.system,
      navigatorKey: NavigationService.navigatorKey,
      home: const AuthCheckScreen(),
    );
  }
}

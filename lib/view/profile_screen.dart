import 'package:flutter/material.dart';
import 'package:toonflix_fe/model/api/api_client.dart';
import 'package:toonflix_fe/service/navigation_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                // 다이얼로그 닫기
                Navigator.of(context).pop();

                // 토큰 제거
                await ApiClient.clearToken();

                // 로그인 화면으로 이동 (스택 초기화)
                await NavigationService.navigateToLogin();
              },
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rhseung"),
        actions: [
          IconButton(icon: Icon(Icons.settings_rounded), onPressed: () {}),
          IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () => logoutDialog(context),
          ),
        ],
        elevation: 5,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Text('R', style: TextStyle(fontSize: 44)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Rhseung',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Flexible(
              flex: 3,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 20),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Item $index'),
                      subtitle: Text('Subtitle for item $index'),
                    ),
                  );
                },
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

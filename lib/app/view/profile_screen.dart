import 'package:flutter/material.dart';
import 'package:toonflix_fe/app/model/api/api_client.dart';
import 'package:toonflix_fe/app/model/service/navigation_service.dart';
import 'package:toonflix_fe/util/error_handler.dart';
import 'package:toonflix_fe/app/viewmodel/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadProfileData();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted && _viewModel.hasError) {
      ErrorHandler.showErrorSnackBar(context, _viewModel.errorMessage!);
    }
    setState(() {});
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_viewModel.userName),
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
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _viewModel.refresh,
              child: Padding(
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
                                child: Text(
                                  _viewModel.userAvatarText,
                                  style: TextStyle(fontSize: 44),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _viewModel.userName,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Flexible(
                      flex: 3,
                      child: _viewModel.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    '작성한 포스트가 없습니다',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 20),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final post = _viewModel.myPosts[index];
                                return Card(
                                  elevation: 0,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        _viewModel.userAvatarText,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    title: Text(
                                      _viewModel.userName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      post.content,
                                      maxLines: 6,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                    onTap: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            _viewModel.getPostClickMessage(
                                              post,
                                            ),
                                          ),
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                              itemCount: _viewModel.myPosts.length,
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

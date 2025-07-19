import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toonflix_fe/model/api/retrofit_client.dart';
import 'package:toonflix_fe/model/entity/post_entity.dart';
import 'package:toonflix_fe/model/entity/user_entity.dart';
import 'package:toonflix_fe/model/repo/post_repository.dart';
import 'package:toonflix_fe/model/repo/user_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostRepository _postRepository = PostRepository(RetrofitClient(Dio()));
  final UserRepository _userRepository = UserRepository(RetrofitClient(Dio()));
  List<PostEntity> posts = [];
  Map<int, UserEntity> users = {}; // 사용자 정보를 캐시하기 위한 맵
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final fetchedPosts = await _postRepository.getPosts();

      // 각 포스트의 작성자 정보를 가져옴
      final userFutures = fetchedPosts
          .map((post) => post.authorId)
          .toSet() // 중복 제거
          .map((authorId) => _userRepository.getUser(authorId));

      final fetchedUsers = await Future.wait(userFutures);

      // 사용자 정보를 맵에 저장
      final userMap = <int, UserEntity>{};
      for (final user in fetchedUsers) {
        userMap[user.id] = user;
      }

      if (mounted) {
        setState(() {
          posts = fetchedPosts;
          users = userMap;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        // 에러 처리 - 스낵바로 사용자에게 알림
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('포스트를 불러오는데 실패했습니다: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toonflix"),
        actions: [IconButton(icon: Icon(Icons.add_rounded), onPressed: () {})],
        elevation: 5,
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
          ? const Center(child: Text('포스트가 없습니다'))
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final user = users[post.authorId];
                    return Card(
                      elevation: 0,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            user?.name.substring(0, 1).toUpperCase() ?? '?',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(
                          user?.name ?? 'Unknown User',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          post.content,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        onTap: () {
                          // 포스트 클릭 시 토스트 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('포스트 "${post.id}" 클릭됨'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  itemCount: posts.length,
                ),
              ),
            ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:toonflix_fe/model/api/api_client.dart';
import 'package:toonflix_fe/model/entity/post_entity.dart';
import 'package:toonflix_fe/model/entity/user_entity.dart';
import 'package:toonflix_fe/model/repo/post_repository.dart';
import 'package:toonflix_fe/model/repo/user_repository.dart';
import 'package:toonflix_fe/util/string_extensions.dart';

class HomeViewModel extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository(ApiClient.instance);
  final UserRepository _userRepository = UserRepository(ApiClient.instance);

  List<PostEntity> _posts = [];
  Map<int, UserEntity> _users = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<PostEntity> get posts => _posts;
  Map<int, UserEntity> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _posts.isEmpty && !_isLoading;

  // 포스트 로드
  Future<void> loadPosts() async {
    _setLoading(true);
    _clearError();

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

      _posts = fetchedPosts;
      _users = userMap;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // 새로고침
  Future<void> refresh() async {
    await loadPosts();
  }

  // 포스트 클릭 처리
  String getPostClickMessage(PostEntity post) {
    return '포스트 "${post.id}" 클릭됨';
  }

  // 사용자 정보 가져오기
  UserEntity? getUserForPost(PostEntity post) {
    return _users[post.authorId];
  }

  // 사용자 아바타 텍스트 가져오기
  String getUserAvatarText(PostEntity post) {
    final user = getUserForPost(post)!;
    return user.name.firstLetter();
  }

  // 사용자 이름 가져오기
  String getUserName(PostEntity post) {
    final user = getUserForPost(post);
    return user?.name ?? 'Unknown User';
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

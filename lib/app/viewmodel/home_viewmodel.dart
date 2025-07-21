import 'package:flutter/foundation.dart';
import 'package:toonflix_fe/app/model/api/api_client.dart';
import 'package:toonflix_fe/app/model/entity/post_entity.dart';
import 'package:toonflix_fe/app/model/entity/user_entity.dart';
import 'package:toonflix_fe/app/model/repo/post_repository.dart';
import 'package:toonflix_fe/app/model/repo/user_repository.dart';
import 'package:toonflix_fe/util/string_extensions.dart';

class HomeViewModel extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository(ApiClient.instance);
  final UserRepository _userRepository = UserRepository(ApiClient.instance);

  List<PostEntity> _posts = [];
  Map<int, UserEntity> _users = {};
  bool _isLoading = false;
  bool _disposed = false;
  String? _errorMessage;

  List<PostEntity> get posts => _posts;
  Map<int, UserEntity> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _posts.isEmpty && !_isLoading;

  Future<void> loadPosts() async {
    _setLoading(true);
    _clearError();

    try {
      final fetchedPosts = await _postRepository.getPosts();

      final userFutures = fetchedPosts
          .map((post) => post.authorId)
          .toSet() // 중복 제거
          .map((authorId) => _userRepository.getUser(authorId));

      final fetchedUsers = await Future.wait(userFutures);

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

  Future<void> refresh() async {
    await loadPosts();
  }

  String getPostClickMessage(PostEntity post) {
    return '포스트 "${post.id}" 클릭됨';
  }

  UserEntity? getUserForPost(PostEntity post) {
    return _users[post.authorId];
  }

  String getUserAvatarText(PostEntity post) {
    final user = getUserForPost(post)!;
    return user.name.firstLetter();
  }

  String getUserName(PostEntity post) {
    final user = getUserForPost(post);
    return user?.name ?? 'Unknown User';
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _clearError() {
    _errorMessage = null;
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

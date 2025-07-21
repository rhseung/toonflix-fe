import 'package:flutter/foundation.dart';
import 'package:toonflix_fe/app/model/api/api_client.dart';
import 'package:toonflix_fe/app/model/entity/post_entity.dart';
import 'package:toonflix_fe/app/model/entity/user_entity.dart';
import 'package:toonflix_fe/app/model/repo/post_repository.dart';
import 'package:toonflix_fe/app/model/repo/user_repository.dart';
import 'package:toonflix_fe/util/string_extensions.dart';

class ProfileViewModel extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository(ApiClient.instance);
  final UserRepository _userRepository = UserRepository(ApiClient.instance);

  UserEntity? _currentUser;
  List<PostEntity> _myPosts = [];
  bool _isLoading = false;
  bool _disposed = false;
  String? _errorMessage;

  UserEntity? get currentUser => _currentUser;
  List<PostEntity> get myPosts => _myPosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _myPosts.isEmpty && !_isLoading;

  String get userName => _currentUser?.name ?? 'Unknown User';
  String get userAvatarText => _currentUser?.name.firstLetter() ?? '?';

  Future<void> loadProfileData() async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _userRepository.getCurrentUser();

      final allPosts = await _postRepository.getPosts();
      _myPosts = allPosts
          .where((post) => post.authorId == _currentUser!.id)
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    await loadProfileData();
  }

  String getPostClickMessage(PostEntity post) {
    return '포스트 "${post.id}" 클릭됨';
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

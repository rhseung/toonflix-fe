import 'package:toonflix_fe/app/model/api/retrofit_client.dart';
import 'package:toonflix_fe/app/model/dto/create_post_dto.dart';
import 'package:toonflix_fe/app/model/dto/update_post_dto.dart';
import 'package:toonflix_fe/app/model/entity/post_entity.dart';

class PostRepository {
  final RetrofitClient _api;

  const PostRepository(this._api);

  Future<PostEntity> createPost(CreatePostDto post) => _api.createPost(post);

  Future<List<PostEntity>> getPosts() => _api.getPosts();

  Future<PostEntity> getPost(int id) => _api.getPost(id);

  Future<PostEntity> updatePost(int id, UpdatePostDto post) =>
      _api.updatePost(id, post);

  Future<PostEntity> deletePost(int id) => _api.deletePost(id);
}

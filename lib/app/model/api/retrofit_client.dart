import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:toonflix_fe/app/model/dto/create_post_dto.dart';
import 'package:toonflix_fe/app/model/dto/create_user_dto.dart';
import 'package:toonflix_fe/app/model/dto/login_dto.dart';
import 'package:toonflix_fe/app/model/dto/update_post_dto.dart';
import 'package:toonflix_fe/app/model/dto/update_user_dto.dart';
import 'package:toonflix_fe/app/model/entity/login_entity.dart';
import 'package:toonflix_fe/app/model/entity/post_entity.dart';
import 'package:toonflix_fe/app/model/entity/user_entity.dart';

part 'retrofit_client.g.dart';

@RestApi(baseUrl: "https://toonflix-be.vercel.app/")
abstract class RetrofitClient {
  factory RetrofitClient(Dio dio, {String baseUrl}) = _RetrofitClient;

  @GET("/")
  Future<dynamic> getRoot();

  @POST("/posts")
  Future<PostEntity> createPost(@Body() CreatePostDto post);

  @GET("/posts")
  Future<List<PostEntity>> getPosts();

  @GET("/posts/{id}")
  Future<PostEntity> getPost(@Path("id") int id);

  @PATCH("/posts/{id}")
  Future<PostEntity> updatePost(@Path("id") int id, @Body() UpdatePostDto post);

  @DELETE("/posts/{id}")
  Future<PostEntity> deletePost(@Path("id") int id);

  @POST("/users")
  Future<UserEntity> createUser(@Body() CreateUserDto user);

  @GET("/users/me")
  Future<UserEntity> getCurrentUser();

  @GET("/users")
  Future<List<UserEntity>> getUsers();

  @GET("/users/{id}")
  Future<UserEntity> getUser(@Path("id") int id);

  @GET("/users/email/{email}")
  Future<UserEntity> getUserByEmail(@Path("email") String email);

  @PATCH("/users/{id}")
  Future<UserEntity> updateUser(@Path("id") int id, @Body() UpdateUserDto user);

  @DELETE("/users/{id}")
  Future<UserEntity> deleteUser(@Path("id") int id);

  @POST("/auth/login")
  Future<LoginEntity> login(@Body() LoginDto login);
}

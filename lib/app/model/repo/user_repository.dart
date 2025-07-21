import 'package:toonflix_fe/app/model/api/retrofit_client.dart';
import 'package:toonflix_fe/app/model/dto/create_user_dto.dart';
import 'package:toonflix_fe/app/model/dto/update_user_dto.dart';
import 'package:toonflix_fe/app/model/entity/user_entity.dart';

class UserRepository {
  final RetrofitClient _api;

  const UserRepository(this._api);

  Future<UserEntity> createUser(CreateUserDto user) => _api.createUser(user);

  Future<List<UserEntity>> getUsers() => _api.getUsers();

  Future<UserEntity> getCurrentUser() => _api.getCurrentUser();

  Future<UserEntity> getUser(int id) => _api.getUser(id);

  Future<UserEntity> getUserByEmail(String email) => _api.getUserByEmail(email);

  Future<UserEntity> updateUser(int id, UpdateUserDto user) =>
      _api.updateUser(id, user);

  Future<UserEntity> deleteUser(int id) => _api.deleteUser(id);
}

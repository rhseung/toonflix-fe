import 'package:toonflix_fe/model/api/retrofit_client.dart';
import 'package:toonflix_fe/model/dto/create_user_dto.dart';
import 'package:toonflix_fe/model/dto/update_user_dto.dart';
import 'package:toonflix_fe/model/entity/user_entity.dart';

class UserRepository {
  final RetrofitClient _api;

  const UserRepository(this._api);

  Future<UserEntity> createUser(CreateUserDto user) => _api.createUser(user);

  Future<List<UserEntity>> getUsers() => _api.getUsers();

  Future<UserEntity> getUser(int id) => _api.getUser(id);

  Future<UserEntity> updateUser(int id, UpdateUserDto user) =>
      _api.updateUser(id, user);

  Future<UserEntity> deleteUser(int id) => _api.deleteUser(id);
}

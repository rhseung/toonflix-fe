import 'package:toonflix_fe/app/model/api/retrofit_client.dart';
import 'package:toonflix_fe/app/model/dto/login_dto.dart';
import 'package:toonflix_fe/app/model/entity/login_entity.dart';

class AuthRepository {
  final RetrofitClient _api;

  const AuthRepository(this._api);

  Future<LoginEntity> login(LoginDto login) => _api.login(login);
}

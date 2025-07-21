import 'package:json_annotation/json_annotation.dart';

part 'login_entity.g.dart';

@JsonSerializable()
class LoginEntity {
  final String accessToken;

  const LoginEntity({required this.accessToken});

  factory LoginEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LoginEntityToJson(this);
}

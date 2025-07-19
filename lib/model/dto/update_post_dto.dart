import 'package:json_annotation/json_annotation.dart';

part 'update_post_dto.g.dart';

@JsonSerializable()
class UpdatePostDto {
  final String? content;
  final String? authorId;

  UpdatePostDto({this.content, this.authorId});

  factory UpdatePostDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePostDtoToJson(this);
}

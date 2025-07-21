import 'package:json_annotation/json_annotation.dart';

part 'create_post_dto.g.dart';

@JsonSerializable()
class CreatePostDto {
  final String content;
  final String authorId;

  CreatePostDto({required this.content, required this.authorId});

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDtoToJson(this);
}

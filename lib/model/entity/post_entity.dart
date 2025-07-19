import 'package:json_annotation/json_annotation.dart';

part 'post_entity.g.dart';

@JsonSerializable()
class PostEntity {
  final int id;
  final String title;
  final String content;
  final int authorId;

  PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PostEntityToJson(this);
}

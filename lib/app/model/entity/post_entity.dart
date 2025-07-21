import 'package:json_annotation/json_annotation.dart';

part 'post_entity.g.dart';

@JsonSerializable()
class PostEntity {
  final int id;
  final String content;
  final int authorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostEntity({
    required this.id,
    required this.content,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PostEntityToJson(this);
}

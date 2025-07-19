// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostEntity _$PostEntityFromJson(Map<String, dynamic> json) => PostEntity(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  authorId: (json['authorId'] as num).toInt(),
);

Map<String, dynamic> _$PostEntityToJson(PostEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'authorId': instance.authorId,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostDto _$CreatePostDtoFromJson(Map<String, dynamic> json) =>
    CreatePostDto(
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
    );

Map<String, dynamic> _$CreatePostDtoToJson(CreatePostDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'authorId': instance.authorId,
    };

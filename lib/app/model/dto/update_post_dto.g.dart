// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePostDto _$UpdatePostDtoFromJson(Map<String, dynamic> json) =>
    UpdatePostDto(
      content: json['content'] as String?,
      authorId: json['authorId'] as String?,
    );

Map<String, dynamic> _$UpdatePostDtoToJson(UpdatePostDto instance) =>
    <String, dynamic>{
      'content': instance.content,
      'authorId': instance.authorId,
    };

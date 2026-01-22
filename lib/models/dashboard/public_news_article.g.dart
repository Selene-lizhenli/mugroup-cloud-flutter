// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_news_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NewsMediaImpl _$$NewsMediaImplFromJson(Map<String, dynamic> json) =>
    _$NewsMediaImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      url: json['url'] as String?,
      whiteUrl: json['white_url'] as String?,
      thumbUrl: json['thumb_url'] as String?,
      type: json['type'] as String?,
      filename: json['filename'] as String?,
      address: json['address'] as String?,
      shotAt: json['shot_at'] as String?,
      collectionName: json['collection_name'] as String?,
    );

Map<String, dynamic> _$$NewsMediaImplToJson(_$NewsMediaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'white_url': instance.whiteUrl,
      'thumb_url': instance.thumbUrl,
      'type': instance.type,
      'filename': instance.filename,
      'address': instance.address,
      'shot_at': instance.shotAt,
      'collection_name': instance.collectionName,
    };

_$PublicNewsArticleImpl _$$PublicNewsArticleImplFromJson(
        Map<String, dynamic> json) =>
    _$PublicNewsArticleImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      summary: json['summary'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => NewsMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PublicNewsArticleImplToJson(
        _$PublicNewsArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'summary': instance.summary,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'media': instance.media,
    };

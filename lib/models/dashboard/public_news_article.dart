import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_news_article.freezed.dart';
part 'public_news_article.g.dart';

/// 新闻文章媒体模型
@freezed
class NewsMedia with _$NewsMedia {
  const factory NewsMedia({
    int? id,
    String? name,
    String? url,
    @JsonKey(name: 'white_url') String? whiteUrl,
    @JsonKey(name: 'thumb_url') String? thumbUrl,
    String? type,
    String? filename,
    String? address,
    @JsonKey(name: 'shot_at') String? shotAt,
    @JsonKey(name: 'collection_name') String? collectionName,
  }) = _NewsMedia;

  factory NewsMedia.fromJson(Map<String, dynamic> json) =>
      _$NewsMediaFromJson(json);
}

/// 新闻文章数据模型
@freezed
class PublicNewsArticle with _$PublicNewsArticle {
  const factory PublicNewsArticle({
    int? id,
    String? title,
    String? content,
     String? summary,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    List<NewsMedia>? media,
  }) = _PublicNewsArticle;

  factory PublicNewsArticle.fromJson(Map<String, dynamic> json) =>
      _$PublicNewsArticleFromJson(json);
}

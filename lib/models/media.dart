import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

@freezed
abstract class Media with _$Media {
  const Media._();

  const factory Media({
    int? id,
    String? name,
    String? url,
    String? filename,
    @JsonKey(name: 'thumb_url') String? thumbUrl,
    @JsonKey(name: 'collection_name') String? collectionName,
  }) = _Media;

  factory Media.fromJson(Map<String, Object?> json) => _$MediaFromJson(json);

  String? get thumbOrUrl {
    return thumbUrl ?? url;
  }
}

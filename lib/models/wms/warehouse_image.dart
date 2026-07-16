import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_image.freezed.dart';
part 'warehouse_image.g.dart';

@freezed
abstract class WarehouseImage with _$WarehouseImage {
  const factory WarehouseImage({
    int? id,
    String? name,
    String? url,
    int? categoryId,
    @JsonKey(name: 'white_url') String? whiteUrl,
    @JsonKey(name: 'thumb_url') String? thumbUrl,
    String? type,
    String? filename,
    String? address,
    @JsonKey(name: 'shot_at') String? shotAt,
    @JsonKey(name: 'collection_name') String? collectionName,
  }) = _WarehouseImage;

  factory WarehouseImage.fromJson(Map<String, Object?> json) =>
      _$WarehouseImageFromJson(json);
}

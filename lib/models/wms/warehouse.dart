import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud/models/wms/warehouse_image.dart';

part 'warehouse.freezed.dart';
part 'warehouse.g.dart';

@freezed
abstract class Warehouse with _$Warehouse {
  const factory Warehouse({
    int? id,
    String? name,
    String? address,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @Default([]) List<WarehouseImage>? image,
    bool? abandoned,
  }) = _Warehouse;

  factory Warehouse.fromJson(Map<String, Object?> json) =>
      _$WarehouseFromJson(json);
}

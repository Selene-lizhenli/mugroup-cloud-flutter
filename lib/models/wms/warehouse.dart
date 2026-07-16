import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud/models/wms/warehouse_image.dart';

part 'warehouse.freezed.dart';
part 'warehouse.g.dart';

String? _stringFromAny(Object? value) => value?.toString();

@freezed
abstract class Warehouse with _$Warehouse {
  const factory Warehouse({
    int? id,
    String? name,
    String? address,
    String? type,
    String? permission, 
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'tenant_id') int? tenantId,
    @JsonKey(name: 'order_column', fromJson: _stringFromAny)
    String? orderColumn,
    @Default([]) List<WarehouseImage>? image,
    bool? abandoned, 
  }) = _Warehouse;

  factory Warehouse.fromJson(Map<String, Object?> json) =>
      _$WarehouseFromJson(json);
}

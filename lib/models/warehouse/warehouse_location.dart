import 'package:cloud/models/warehouse/warehouse_zone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_location.freezed.dart';
part 'warehouse_location.g.dart';

@freezed
abstract class WarehouseLocation with _$WarehouseLocation {
  const WarehouseLocation._();

  const factory WarehouseLocation({
    int? id,
    String? name,
    String? code,
    @JsonKey(name: 'zone_id') int? zoneId,
    WarehouseZone? zone,
  }) = _WarehouseLocation;

  factory WarehouseLocation.fromJson(Map<String, Object?> json) =>
      _$WarehouseLocationFromJson(json);

  String get displayName {
    final zoneName = zone?.name;
    if (zoneName != null && name != null) return '$zoneName - $name';
    return name ?? '';
  }
}

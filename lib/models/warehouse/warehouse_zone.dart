import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_zone.freezed.dart';
part 'warehouse_zone.g.dart';

@freezed
abstract class WarehouseZone with _$WarehouseZone {
  const factory WarehouseZone({
    int? id,
    String? name,
    String? code,
    @JsonKey(name: 'locations_count') int? locationsCount,
  }) = _WarehouseZone;

  factory WarehouseZone.fromJson(Map<String, Object?> json) =>
      _$WarehouseZoneFromJson(json);
}

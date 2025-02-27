import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse.freezed.dart';
part 'warehouse.g.dart';

@freezed
abstract class Warehouse with _$Warehouse {
  const factory Warehouse({
    int? id,
    String? name,
    String? address,
  }) = _Warehouse;

  factory Warehouse.fromJson(Map<String, Object?> json) =>
      _$WarehouseFromJson(json);
}

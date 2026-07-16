import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_type.freezed.dart';
part 'supplier_type.g.dart';

@freezed
class SupplierType with _$SupplierType {
  factory SupplierType(
    int? id,
    String? name,
  ) = _SupplierType;

  factory SupplierType.fromJson(Map<String, dynamic> json) => _$SupplierTypeFromJson(json);
}
import 'package:cloud/models/media.dart';
import 'package:cloud/models/supply/cert.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_cert.freezed.dart';
part 'supplier_cert.g.dart';

@freezed
class SupplierCert with _$SupplierCert {
  factory SupplierCert(
    int? id,
    User? user,
    Cert? cert,
    Supplier? supplier,
    @JsonKey(name: 'expired_at') DateTime? expiredAt,
    List<Media>? media,
    String? remark,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  ) = _SupplierCert;

  factory SupplierCert.fromJson(Map<String, dynamic> json) =>
      _$SupplierCertFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cert.freezed.dart';
part 'cert.g.dart';

@freezed
class Cert with _$Cert {
  factory Cert(
    int? id,
    String? name,
    String? remark,
  ) = _Cert;

  factory Cert.fromJson(Map<String, dynamic> json) => _$CertFromJson(json);
}

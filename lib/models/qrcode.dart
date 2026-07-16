import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qrcode.freezed.dart';
part 'qrcode.g.dart';

@freezed
abstract class Qrcode with _$Qrcode {
  const factory Qrcode({
    int? id,
    String? type,
    String? code,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'expired_at') String? expiredAt,
    @JsonKey(name: 'used_at') String? usedAt,
    @JsonKey(name: 'user') User? user,
  }) = _Qrcode;

  factory Qrcode.fromJson(Map<String, Object?> json) => _$QrcodeFromJson(json);
}

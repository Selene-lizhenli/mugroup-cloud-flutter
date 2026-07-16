import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_station_inquiries.freezed.dart';
part 'single_station_inquiries.g.dart';

//独立站 询盘列表项
@freezed
class SingleStationInquiries with _$SingleStationInquiries {
  factory SingleStationInquiries({
    int? id,
    @JsonKey(name: 'station_id') int? stationId,
    @JsonKey(name: 'user_id') int? userId,
    String? name,
    String? email,
    String? phone,
    String? ip,
    String? ua,
    String? message,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    User? user,
    SingleStationItem? station,
  }) = _SingleStationInquiries;

  factory SingleStationInquiries.fromJson(Map<String, dynamic> json) =>
      _$SingleStationInquiriesFromJson(json);
}

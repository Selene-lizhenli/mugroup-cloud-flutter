import 'package:cloud/models/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer.freezed.dart';
part 'transfer.g.dart';

enum TransferStatus { draft, finished, processing, cancelled }

@freezed
class Transfer with _$Transfer {
  factory Transfer({
    int? id,
    @JsonKey(name: 'order_no') String? orderNo,
    @JsonKey(name: 'out_warehouse') String? outWarehouse,
    @JsonKey(name: 'in_warehouse') String? inWarehouse,
    User? creator,
    TransferStatus? status,
    @JsonKey(name: 'transfer_at') DateTime? transferAt,
    String? remark,
  }) = _Transfer;

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
}

import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms/transfer_item.dart';
import 'package:cloud/models/wms/warehouse.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer.freezed.dart';
part 'transfer.g.dart';

enum TransferStatus { draft, finished, processing, cancelled }

@freezed
class Transfer with _$Transfer {
  factory Transfer({
    int? id,
    @JsonKey(name: 'order_no') String? orderNo,
    @JsonKey(name: 'outWarehouse') Warehouse? outWarehouse,
    @JsonKey(name: 'inWarehouse') Warehouse? inWarehouse,
    User? creator,
    TransferStatus? status,
    @JsonKey(name: 'transfer_at') DateTime? transferAt,
    String? remark,
    @JsonKey(name: 'items') List<TransferItem>? items,
  }) = _Transfer;

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
}

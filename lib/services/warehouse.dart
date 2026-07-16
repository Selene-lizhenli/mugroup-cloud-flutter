import 'package:cloud/http/api.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/warehouse/warehouse_location.dart';
import 'package:cloud/models/warehouse/warehouse_receipt.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_item.dart';
import 'package:cloud/models/warehouse/warehouse_receipt_item_entry.dart';
import 'package:cloud/models/warehouse/warehouse_zone.dart';

Future<ApiResponse<List<WarehouseReceipt>>> getWarehouseReceipts(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/warehouse/receipts", queryParameters: queryParameters)
      .then((res) => ApiResponse<List<WarehouseReceipt>>.fromJson(
            res.data,
            (data) {
              final list = (data as List).cast<Map<String, dynamic>>();
              return list.map(WarehouseReceipt.fromJson).toList();
            },
          ));
}

Future<WarehouseReceipt> fetchWarehouseReceipt(int id) async {
  final res = await api.get("api/tenant/warehouse/receipts/$id");
  return WarehouseReceipt.fromJson(res.data);
}

Future<WarehouseReceipt> fetchWarehouseReceiptByHashid(String hashid) async {
  final res = await api.get("api/tenant/warehouse/receipts/hash/$hashid");
  return WarehouseReceipt.fromJson(res.data);
}

Future<WarehouseReceiptItem> fetchWarehouseReceiptItem(int id) async {
  final results = await Future.wait([
    api.get("api/tenant/warehouse/receipt-items/$id"),
    api.get("api/tenant/warehouse/receipt-items/$id/entries"),
  ]);
  final item = WarehouseReceiptItem.fromJson(results[0].data);
  final entries = (results[1].data['data'] as List)
      .cast<Map<String, dynamic>>()
      .map(WarehouseReceiptItemEntry.fromJson)
      .toList();
  return item.copyWith(entries: entries, entriesCount: entries.length);
}

Future<WarehouseReceiptItem> fetchWarehouseReceiptItemByHashid(
    String hashid) async {
  final res = await api.get("api/tenant/warehouse/receipt-items/hash/$hashid");
  return WarehouseReceiptItem.fromJson(res.data);
}

Future<ApiResponse<List<WarehouseReceiptItem>>> getWarehouseReceiptItems(
    {Map<String, dynamic>? queryParameters}) async {
  return api
      .get("api/tenant/warehouse/receipt-items",
          queryParameters: queryParameters)
      .then((res) => ApiResponse<List<WarehouseReceiptItem>>.fromJson(
            res.data,
            (data) {
              var list = (data as List).cast<Map<String, dynamic>>();
              return list.map(WarehouseReceiptItem.fromJson).toList();
            },
          ));
}

Future<List<WarehouseReceiptItem>> getWarehouseReceiptFlatItems(
  int receiptId, {
  Map<String, dynamic>? queryParameters,
}) async {
  final res = await api.get(
    "api/tenant/warehouse/receipts/$receiptId/item-groups",
    queryParameters: queryParameters,
  );
  final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
  return list.map(WarehouseReceiptItem.fromJson).toList();
}

/// Search purchase-contract details that can be added to this receipt. Results
/// are returned as [WarehouseReceiptItem] candidates (keyed by `record_id`,
/// with a null local `id`).
Future<ApiResponse<List<WarehouseReceiptItem>>>
    searchReceiptPurchaseContractDetails(
  int receiptId, {
  Map<String, dynamic>? queryParameters,
}) async {
  final res = await api.get(
    "api/tenant/warehouse/receipts/$receiptId/purchase-contract-details",
    queryParameters: queryParameters,
  );
  return ApiResponse<List<WarehouseReceiptItem>>.fromJson(
    res.data,
    (data) => (data as List)
        .cast<Map<String, dynamic>>()
        .map(_parsePurchaseContractDetail)
        .toList(),
  );
}

/// The purchase-contract search endpoint returns numeric fields as strings
/// (e.g. `"0.00"`). Coerce them to numbers before mapping to
/// [WarehouseReceiptItem], whose numeric fields are typed `num`/`int`.
WarehouseReceiptItem _parsePurchaseContractDetail(Map<String, dynamic> json) {
  const numKeys = {
    'shipping_qty',
    'outer_length',
    'outer_width',
    'outer_height',
    'outer_volume',
    'volume',
    'outer_gross_weight',
    'gross_weight',
    'outer_net_weight',
    'net_weight',
  };
  const intKeys = {'inner_capacity', 'outer_capacity', 'carton_qty'};

  final normalized = Map<String, dynamic>.from(json);
  for (final key in numKeys) {
    final value = normalized[key];
    if (value is String) normalized[key] = num.tryParse(value);
  }
  for (final key in intKeys) {
    final value = normalized[key];
    if (value is String) {
      normalized[key] = int.tryParse(value) ?? num.tryParse(value)?.toInt();
    }
  }
  return WarehouseReceiptItem.fromJson(normalized);
}

/// Add a searched purchase-contract detail to this receipt as a new item.
Future<WarehouseReceiptItem> addReceiptPurchaseContractDetailItem(
  int receiptId,
  WarehouseReceiptItem detail,
) async {
  final res = await api.post(
    "api/tenant/warehouse/receipts/$receiptId/purchase-contract-details/items",
    data: {'item': detail.toJson()},
  );
  return WarehouseReceiptItem.fromJson(res.data);
}

Future<List<WarehouseReceiptItemEntry>> getWarehouseReceiptItemEntries(
    int itemId) async {
  final res =
      await api.get("api/tenant/warehouse/receipt-items/$itemId/entries");
  final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
  return list.map(WarehouseReceiptItemEntry.fromJson).toList();
}

Future<WarehouseReceiptItemEntry> createWarehouseReceiptItemEntry(
  int itemId,
  Map<String, dynamic> data,
) async {
  final res = await api.post(
    "api/tenant/warehouse/receipt-items/$itemId/entries",
    data: data,
  );
  return WarehouseReceiptItemEntry.fromJson(res.data);
}

Future<WarehouseReceiptItemEntry> updateWarehouseReceiptItemEntry(
  int itemId,
  int entryId,
  Map<String, dynamic> data,
) async {
  final res = await api.put(
    "api/tenant/warehouse/receipt-items/$itemId/entries/$entryId",
    data: data,
  );
  return WarehouseReceiptItemEntry.fromJson(res.data);
}

Future<void> deleteWarehouseReceiptItemEntry(int itemId, int entryId) async {
  await api
      .delete("api/tenant/warehouse/receipt-items/$itemId/entries/$entryId");
}

Future<List<WarehouseZone>> getWarehouseZones() async {
  final res = await api.get("api/tenant/warehouse/zones");
  final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
  return list.map(WarehouseZone.fromJson).toList();
}

Future<List<WarehouseLocation>> getWarehouseZoneLocations(int zoneId) async {
  final res = await api.get("api/tenant/warehouse/zones/$zoneId/locations");
  final list = (res.data['data'] as List).cast<Map<String, dynamic>>();
  return list.map(WarehouseLocation.fromJson).toList();
}

Future<List<WarehouseLocation>> getAllWarehouseLocations() async {
  final zones = await getWarehouseZones();
  final locationLists = await Future.wait(
    zones.where((z) => z.id != null).map((zone) async {
      final locs = await getWarehouseZoneLocations(zone.id!);
      return locs.map((loc) => loc.copyWith(zone: zone)).toList();
    }),
  );
  return locationLists.expand((l) => l).toList();
}

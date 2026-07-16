// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_receipt_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WarehouseReceiptItem _$WarehouseReceiptItemFromJson(Map<String, dynamic> json) {
  return _WarehouseReceiptItem.fromJson(json);
}

/// @nodoc
mixin _$WarehouseReceiptItem {
  int? get id => throw _privateConstructorUsedError;
  String? get hashid => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_id')
  int? get receiptId => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_id')
  String? get recordId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt')
  WarehouseReceipt? get receipt => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_no')
  String? get itemNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_item_no')
  String? get customerItemNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_short_name')
  String? get supplierShortName => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_order_no')
  String? get purchaseOrderNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_qty')
  num? get shippingQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit')
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'inner_capacity')
  int? get innerCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_capacity')
  int? get outerCapacity => throw _privateConstructorUsedError;
  @JsonKey(name: 'carton_qty')
  int? get cartonQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_length')
  num? get outerLength => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_width')
  num? get outerWidth => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_height')
  num? get outerHeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_volume')
  num? get outerVolume => throw _privateConstructorUsedError;
  @JsonKey(name: 'volume')
  num? get volume => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_gross_weight')
  num? get outerGrossWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'gross_weight')
  num? get grossWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'outer_net_weight')
  num? get outerNetWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'net_weight')
  num? get netWeight => throw _privateConstructorUsedError;
  @JsonKey(name: 'entries_count')
  int? get entriesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'entries')
  List<WarehouseReceiptItemEntry>? get entries =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarehouseReceiptItemCopyWith<WarehouseReceiptItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseReceiptItemCopyWith<$Res> {
  factory $WarehouseReceiptItemCopyWith(WarehouseReceiptItem value,
          $Res Function(WarehouseReceiptItem) then) =
      _$WarehouseReceiptItemCopyWithImpl<$Res, WarehouseReceiptItem>;
  @useResult
  $Res call(
      {int? id,
      String? hashid,
      @JsonKey(name: 'receipt_id') int? receiptId,
      @JsonKey(name: 'record_id') String? recordId,
      @JsonKey(name: 'receipt') WarehouseReceipt? receipt,
      @JsonKey(name: 'item_no') String? itemNo,
      @JsonKey(name: 'customer_item_no') String? customerItemNo,
      @JsonKey(name: 'supplier_short_name') String? supplierShortName,
      @JsonKey(name: 'purchase_order_no') String? purchaseOrderNo,
      @JsonKey(name: 'shipping_qty') num? shippingQty,
      @JsonKey(name: 'unit') String? unit,
      @JsonKey(name: 'inner_capacity') int? innerCapacity,
      @JsonKey(name: 'outer_capacity') int? outerCapacity,
      @JsonKey(name: 'carton_qty') int? cartonQty,
      @JsonKey(name: 'outer_length') num? outerLength,
      @JsonKey(name: 'outer_width') num? outerWidth,
      @JsonKey(name: 'outer_height') num? outerHeight,
      @JsonKey(name: 'outer_volume') num? outerVolume,
      @JsonKey(name: 'volume') num? volume,
      @JsonKey(name: 'outer_gross_weight') num? outerGrossWeight,
      @JsonKey(name: 'gross_weight') num? grossWeight,
      @JsonKey(name: 'outer_net_weight') num? outerNetWeight,
      @JsonKey(name: 'net_weight') num? netWeight,
      @JsonKey(name: 'entries_count') int? entriesCount,
      @JsonKey(name: 'entries') List<WarehouseReceiptItemEntry>? entries,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  $WarehouseReceiptCopyWith<$Res>? get receipt;
}

/// @nodoc
class _$WarehouseReceiptItemCopyWithImpl<$Res,
        $Val extends WarehouseReceiptItem>
    implements $WarehouseReceiptItemCopyWith<$Res> {
  _$WarehouseReceiptItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? hashid = freezed,
    Object? receiptId = freezed,
    Object? recordId = freezed,
    Object? receipt = freezed,
    Object? itemNo = freezed,
    Object? customerItemNo = freezed,
    Object? supplierShortName = freezed,
    Object? purchaseOrderNo = freezed,
    Object? shippingQty = freezed,
    Object? unit = freezed,
    Object? innerCapacity = freezed,
    Object? outerCapacity = freezed,
    Object? cartonQty = freezed,
    Object? outerLength = freezed,
    Object? outerWidth = freezed,
    Object? outerHeight = freezed,
    Object? outerVolume = freezed,
    Object? volume = freezed,
    Object? outerGrossWeight = freezed,
    Object? grossWeight = freezed,
    Object? outerNetWeight = freezed,
    Object? netWeight = freezed,
    Object? entriesCount = freezed,
    Object? entries = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      hashid: freezed == hashid
          ? _value.hashid
          : hashid // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptId: freezed == receiptId
          ? _value.receiptId
          : receiptId // ignore: cast_nullable_to_non_nullable
              as int?,
      recordId: freezed == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String?,
      receipt: freezed == receipt
          ? _value.receipt
          : receipt // ignore: cast_nullable_to_non_nullable
              as WarehouseReceipt?,
      itemNo: freezed == itemNo
          ? _value.itemNo
          : itemNo // ignore: cast_nullable_to_non_nullable
              as String?,
      customerItemNo: freezed == customerItemNo
          ? _value.customerItemNo
          : customerItemNo // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierShortName: freezed == supplierShortName
          ? _value.supplierShortName
          : supplierShortName // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseOrderNo: freezed == purchaseOrderNo
          ? _value.purchaseOrderNo
          : purchaseOrderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingQty: freezed == shippingQty
          ? _value.shippingQty
          : shippingQty // ignore: cast_nullable_to_non_nullable
              as num?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      innerCapacity: freezed == innerCapacity
          ? _value.innerCapacity
          : innerCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      outerCapacity: freezed == outerCapacity
          ? _value.outerCapacity
          : outerCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      cartonQty: freezed == cartonQty
          ? _value.cartonQty
          : cartonQty // ignore: cast_nullable_to_non_nullable
              as int?,
      outerLength: freezed == outerLength
          ? _value.outerLength
          : outerLength // ignore: cast_nullable_to_non_nullable
              as num?,
      outerWidth: freezed == outerWidth
          ? _value.outerWidth
          : outerWidth // ignore: cast_nullable_to_non_nullable
              as num?,
      outerHeight: freezed == outerHeight
          ? _value.outerHeight
          : outerHeight // ignore: cast_nullable_to_non_nullable
              as num?,
      outerVolume: freezed == outerVolume
          ? _value.outerVolume
          : outerVolume // ignore: cast_nullable_to_non_nullable
              as num?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as num?,
      outerGrossWeight: freezed == outerGrossWeight
          ? _value.outerGrossWeight
          : outerGrossWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      grossWeight: freezed == grossWeight
          ? _value.grossWeight
          : grossWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      outerNetWeight: freezed == outerNetWeight
          ? _value.outerNetWeight
          : outerNetWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      netWeight: freezed == netWeight
          ? _value.netWeight
          : netWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      entriesCount: freezed == entriesCount
          ? _value.entriesCount
          : entriesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      entries: freezed == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<WarehouseReceiptItemEntry>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WarehouseReceiptCopyWith<$Res>? get receipt {
    if (_value.receipt == null) {
      return null;
    }

    return $WarehouseReceiptCopyWith<$Res>(_value.receipt!, (value) {
      return _then(_value.copyWith(receipt: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WarehouseReceiptItemImplCopyWith<$Res>
    implements $WarehouseReceiptItemCopyWith<$Res> {
  factory _$$WarehouseReceiptItemImplCopyWith(_$WarehouseReceiptItemImpl value,
          $Res Function(_$WarehouseReceiptItemImpl) then) =
      __$$WarehouseReceiptItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? hashid,
      @JsonKey(name: 'receipt_id') int? receiptId,
      @JsonKey(name: 'record_id') String? recordId,
      @JsonKey(name: 'receipt') WarehouseReceipt? receipt,
      @JsonKey(name: 'item_no') String? itemNo,
      @JsonKey(name: 'customer_item_no') String? customerItemNo,
      @JsonKey(name: 'supplier_short_name') String? supplierShortName,
      @JsonKey(name: 'purchase_order_no') String? purchaseOrderNo,
      @JsonKey(name: 'shipping_qty') num? shippingQty,
      @JsonKey(name: 'unit') String? unit,
      @JsonKey(name: 'inner_capacity') int? innerCapacity,
      @JsonKey(name: 'outer_capacity') int? outerCapacity,
      @JsonKey(name: 'carton_qty') int? cartonQty,
      @JsonKey(name: 'outer_length') num? outerLength,
      @JsonKey(name: 'outer_width') num? outerWidth,
      @JsonKey(name: 'outer_height') num? outerHeight,
      @JsonKey(name: 'outer_volume') num? outerVolume,
      @JsonKey(name: 'volume') num? volume,
      @JsonKey(name: 'outer_gross_weight') num? outerGrossWeight,
      @JsonKey(name: 'gross_weight') num? grossWeight,
      @JsonKey(name: 'outer_net_weight') num? outerNetWeight,
      @JsonKey(name: 'net_weight') num? netWeight,
      @JsonKey(name: 'entries_count') int? entriesCount,
      @JsonKey(name: 'entries') List<WarehouseReceiptItemEntry>? entries,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

  @override
  $WarehouseReceiptCopyWith<$Res>? get receipt;
}

/// @nodoc
class __$$WarehouseReceiptItemImplCopyWithImpl<$Res>
    extends _$WarehouseReceiptItemCopyWithImpl<$Res, _$WarehouseReceiptItemImpl>
    implements _$$WarehouseReceiptItemImplCopyWith<$Res> {
  __$$WarehouseReceiptItemImplCopyWithImpl(_$WarehouseReceiptItemImpl _value,
      $Res Function(_$WarehouseReceiptItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? hashid = freezed,
    Object? receiptId = freezed,
    Object? recordId = freezed,
    Object? receipt = freezed,
    Object? itemNo = freezed,
    Object? customerItemNo = freezed,
    Object? supplierShortName = freezed,
    Object? purchaseOrderNo = freezed,
    Object? shippingQty = freezed,
    Object? unit = freezed,
    Object? innerCapacity = freezed,
    Object? outerCapacity = freezed,
    Object? cartonQty = freezed,
    Object? outerLength = freezed,
    Object? outerWidth = freezed,
    Object? outerHeight = freezed,
    Object? outerVolume = freezed,
    Object? volume = freezed,
    Object? outerGrossWeight = freezed,
    Object? grossWeight = freezed,
    Object? outerNetWeight = freezed,
    Object? netWeight = freezed,
    Object? entriesCount = freezed,
    Object? entries = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WarehouseReceiptItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      hashid: freezed == hashid
          ? _value.hashid
          : hashid // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptId: freezed == receiptId
          ? _value.receiptId
          : receiptId // ignore: cast_nullable_to_non_nullable
              as int?,
      recordId: freezed == recordId
          ? _value.recordId
          : recordId // ignore: cast_nullable_to_non_nullable
              as String?,
      receipt: freezed == receipt
          ? _value.receipt
          : receipt // ignore: cast_nullable_to_non_nullable
              as WarehouseReceipt?,
      itemNo: freezed == itemNo
          ? _value.itemNo
          : itemNo // ignore: cast_nullable_to_non_nullable
              as String?,
      customerItemNo: freezed == customerItemNo
          ? _value.customerItemNo
          : customerItemNo // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierShortName: freezed == supplierShortName
          ? _value.supplierShortName
          : supplierShortName // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseOrderNo: freezed == purchaseOrderNo
          ? _value.purchaseOrderNo
          : purchaseOrderNo // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingQty: freezed == shippingQty
          ? _value.shippingQty
          : shippingQty // ignore: cast_nullable_to_non_nullable
              as num?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      innerCapacity: freezed == innerCapacity
          ? _value.innerCapacity
          : innerCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      outerCapacity: freezed == outerCapacity
          ? _value.outerCapacity
          : outerCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      cartonQty: freezed == cartonQty
          ? _value.cartonQty
          : cartonQty // ignore: cast_nullable_to_non_nullable
              as int?,
      outerLength: freezed == outerLength
          ? _value.outerLength
          : outerLength // ignore: cast_nullable_to_non_nullable
              as num?,
      outerWidth: freezed == outerWidth
          ? _value.outerWidth
          : outerWidth // ignore: cast_nullable_to_non_nullable
              as num?,
      outerHeight: freezed == outerHeight
          ? _value.outerHeight
          : outerHeight // ignore: cast_nullable_to_non_nullable
              as num?,
      outerVolume: freezed == outerVolume
          ? _value.outerVolume
          : outerVolume // ignore: cast_nullable_to_non_nullable
              as num?,
      volume: freezed == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as num?,
      outerGrossWeight: freezed == outerGrossWeight
          ? _value.outerGrossWeight
          : outerGrossWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      grossWeight: freezed == grossWeight
          ? _value.grossWeight
          : grossWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      outerNetWeight: freezed == outerNetWeight
          ? _value.outerNetWeight
          : outerNetWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      netWeight: freezed == netWeight
          ? _value.netWeight
          : netWeight // ignore: cast_nullable_to_non_nullable
              as num?,
      entriesCount: freezed == entriesCount
          ? _value.entriesCount
          : entriesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      entries: freezed == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<WarehouseReceiptItemEntry>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WarehouseReceiptItemImpl implements _WarehouseReceiptItem {
  const _$WarehouseReceiptItemImpl(
      {this.id,
      this.hashid,
      @JsonKey(name: 'receipt_id') this.receiptId,
      @JsonKey(name: 'record_id') this.recordId,
      @JsonKey(name: 'receipt') this.receipt,
      @JsonKey(name: 'item_no') this.itemNo,
      @JsonKey(name: 'customer_item_no') this.customerItemNo,
      @JsonKey(name: 'supplier_short_name') this.supplierShortName,
      @JsonKey(name: 'purchase_order_no') this.purchaseOrderNo,
      @JsonKey(name: 'shipping_qty') this.shippingQty,
      @JsonKey(name: 'unit') this.unit,
      @JsonKey(name: 'inner_capacity') this.innerCapacity,
      @JsonKey(name: 'outer_capacity') this.outerCapacity,
      @JsonKey(name: 'carton_qty') this.cartonQty,
      @JsonKey(name: 'outer_length') this.outerLength,
      @JsonKey(name: 'outer_width') this.outerWidth,
      @JsonKey(name: 'outer_height') this.outerHeight,
      @JsonKey(name: 'outer_volume') this.outerVolume,
      @JsonKey(name: 'volume') this.volume,
      @JsonKey(name: 'outer_gross_weight') this.outerGrossWeight,
      @JsonKey(name: 'gross_weight') this.grossWeight,
      @JsonKey(name: 'outer_net_weight') this.outerNetWeight,
      @JsonKey(name: 'net_weight') this.netWeight,
      @JsonKey(name: 'entries_count') this.entriesCount,
      @JsonKey(name: 'entries') final List<WarehouseReceiptItemEntry>? entries,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : _entries = entries;

  factory _$WarehouseReceiptItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseReceiptItemImplFromJson(json);

  @override
  final int? id;
  @override
  final String? hashid;
  @override
  @JsonKey(name: 'receipt_id')
  final int? receiptId;
  @override
  @JsonKey(name: 'record_id')
  final String? recordId;
  @override
  @JsonKey(name: 'receipt')
  final WarehouseReceipt? receipt;
  @override
  @JsonKey(name: 'item_no')
  final String? itemNo;
  @override
  @JsonKey(name: 'customer_item_no')
  final String? customerItemNo;
  @override
  @JsonKey(name: 'supplier_short_name')
  final String? supplierShortName;
  @override
  @JsonKey(name: 'purchase_order_no')
  final String? purchaseOrderNo;
  @override
  @JsonKey(name: 'shipping_qty')
  final num? shippingQty;
  @override
  @JsonKey(name: 'unit')
  final String? unit;
  @override
  @JsonKey(name: 'inner_capacity')
  final int? innerCapacity;
  @override
  @JsonKey(name: 'outer_capacity')
  final int? outerCapacity;
  @override
  @JsonKey(name: 'carton_qty')
  final int? cartonQty;
  @override
  @JsonKey(name: 'outer_length')
  final num? outerLength;
  @override
  @JsonKey(name: 'outer_width')
  final num? outerWidth;
  @override
  @JsonKey(name: 'outer_height')
  final num? outerHeight;
  @override
  @JsonKey(name: 'outer_volume')
  final num? outerVolume;
  @override
  @JsonKey(name: 'volume')
  final num? volume;
  @override
  @JsonKey(name: 'outer_gross_weight')
  final num? outerGrossWeight;
  @override
  @JsonKey(name: 'gross_weight')
  final num? grossWeight;
  @override
  @JsonKey(name: 'outer_net_weight')
  final num? outerNetWeight;
  @override
  @JsonKey(name: 'net_weight')
  final num? netWeight;
  @override
  @JsonKey(name: 'entries_count')
  final int? entriesCount;
  final List<WarehouseReceiptItemEntry>? _entries;
  @override
  @JsonKey(name: 'entries')
  List<WarehouseReceiptItemEntry>? get entries {
    final value = _entries;
    if (value == null) return null;
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WarehouseReceiptItem(id: $id, hashid: $hashid, receiptId: $receiptId, recordId: $recordId, receipt: $receipt, itemNo: $itemNo, customerItemNo: $customerItemNo, supplierShortName: $supplierShortName, purchaseOrderNo: $purchaseOrderNo, shippingQty: $shippingQty, unit: $unit, innerCapacity: $innerCapacity, outerCapacity: $outerCapacity, cartonQty: $cartonQty, outerLength: $outerLength, outerWidth: $outerWidth, outerHeight: $outerHeight, outerVolume: $outerVolume, volume: $volume, outerGrossWeight: $outerGrossWeight, grossWeight: $grossWeight, outerNetWeight: $outerNetWeight, netWeight: $netWeight, entriesCount: $entriesCount, entries: $entries, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseReceiptItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hashid, hashid) || other.hashid == hashid) &&
            (identical(other.receiptId, receiptId) ||
                other.receiptId == receiptId) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.receipt, receipt) || other.receipt == receipt) &&
            (identical(other.itemNo, itemNo) || other.itemNo == itemNo) &&
            (identical(other.customerItemNo, customerItemNo) ||
                other.customerItemNo == customerItemNo) &&
            (identical(other.supplierShortName, supplierShortName) ||
                other.supplierShortName == supplierShortName) &&
            (identical(other.purchaseOrderNo, purchaseOrderNo) ||
                other.purchaseOrderNo == purchaseOrderNo) &&
            (identical(other.shippingQty, shippingQty) ||
                other.shippingQty == shippingQty) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.innerCapacity, innerCapacity) ||
                other.innerCapacity == innerCapacity) &&
            (identical(other.outerCapacity, outerCapacity) ||
                other.outerCapacity == outerCapacity) &&
            (identical(other.cartonQty, cartonQty) ||
                other.cartonQty == cartonQty) &&
            (identical(other.outerLength, outerLength) ||
                other.outerLength == outerLength) &&
            (identical(other.outerWidth, outerWidth) ||
                other.outerWidth == outerWidth) &&
            (identical(other.outerHeight, outerHeight) ||
                other.outerHeight == outerHeight) &&
            (identical(other.outerVolume, outerVolume) ||
                other.outerVolume == outerVolume) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.outerGrossWeight, outerGrossWeight) ||
                other.outerGrossWeight == outerGrossWeight) &&
            (identical(other.grossWeight, grossWeight) ||
                other.grossWeight == grossWeight) &&
            (identical(other.outerNetWeight, outerNetWeight) ||
                other.outerNetWeight == outerNetWeight) &&
            (identical(other.netWeight, netWeight) ||
                other.netWeight == netWeight) &&
            (identical(other.entriesCount, entriesCount) ||
                other.entriesCount == entriesCount) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        hashid,
        receiptId,
        recordId,
        receipt,
        itemNo,
        customerItemNo,
        supplierShortName,
        purchaseOrderNo,
        shippingQty,
        unit,
        innerCapacity,
        outerCapacity,
        cartonQty,
        outerLength,
        outerWidth,
        outerHeight,
        outerVolume,
        volume,
        outerGrossWeight,
        grossWeight,
        outerNetWeight,
        netWeight,
        entriesCount,
        const DeepCollectionEquality().hash(_entries),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseReceiptItemImplCopyWith<_$WarehouseReceiptItemImpl>
      get copyWith =>
          __$$WarehouseReceiptItemImplCopyWithImpl<_$WarehouseReceiptItemImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseReceiptItemImplToJson(
      this,
    );
  }
}

abstract class _WarehouseReceiptItem implements WarehouseReceiptItem {
  const factory _WarehouseReceiptItem(
      {final int? id,
      final String? hashid,
      @JsonKey(name: 'receipt_id') final int? receiptId,
      @JsonKey(name: 'record_id') final String? recordId,
      @JsonKey(name: 'receipt') final WarehouseReceipt? receipt,
      @JsonKey(name: 'item_no') final String? itemNo,
      @JsonKey(name: 'customer_item_no') final String? customerItemNo,
      @JsonKey(name: 'supplier_short_name') final String? supplierShortName,
      @JsonKey(name: 'purchase_order_no') final String? purchaseOrderNo,
      @JsonKey(name: 'shipping_qty') final num? shippingQty,
      @JsonKey(name: 'unit') final String? unit,
      @JsonKey(name: 'inner_capacity') final int? innerCapacity,
      @JsonKey(name: 'outer_capacity') final int? outerCapacity,
      @JsonKey(name: 'carton_qty') final int? cartonQty,
      @JsonKey(name: 'outer_length') final num? outerLength,
      @JsonKey(name: 'outer_width') final num? outerWidth,
      @JsonKey(name: 'outer_height') final num? outerHeight,
      @JsonKey(name: 'outer_volume') final num? outerVolume,
      @JsonKey(name: 'volume') final num? volume,
      @JsonKey(name: 'outer_gross_weight') final num? outerGrossWeight,
      @JsonKey(name: 'gross_weight') final num? grossWeight,
      @JsonKey(name: 'outer_net_weight') final num? outerNetWeight,
      @JsonKey(name: 'net_weight') final num? netWeight,
      @JsonKey(name: 'entries_count') final int? entriesCount,
      @JsonKey(name: 'entries') final List<WarehouseReceiptItemEntry>? entries,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$WarehouseReceiptItemImpl;

  factory _WarehouseReceiptItem.fromJson(Map<String, dynamic> json) =
      _$WarehouseReceiptItemImpl.fromJson;

  @override
  int? get id;
  @override
  String? get hashid;
  @override
  @JsonKey(name: 'receipt_id')
  int? get receiptId;
  @override
  @JsonKey(name: 'record_id')
  String? get recordId;
  @override
  @JsonKey(name: 'receipt')
  WarehouseReceipt? get receipt;
  @override
  @JsonKey(name: 'item_no')
  String? get itemNo;
  @override
  @JsonKey(name: 'customer_item_no')
  String? get customerItemNo;
  @override
  @JsonKey(name: 'supplier_short_name')
  String? get supplierShortName;
  @override
  @JsonKey(name: 'purchase_order_no')
  String? get purchaseOrderNo;
  @override
  @JsonKey(name: 'shipping_qty')
  num? get shippingQty;
  @override
  @JsonKey(name: 'unit')
  String? get unit;
  @override
  @JsonKey(name: 'inner_capacity')
  int? get innerCapacity;
  @override
  @JsonKey(name: 'outer_capacity')
  int? get outerCapacity;
  @override
  @JsonKey(name: 'carton_qty')
  int? get cartonQty;
  @override
  @JsonKey(name: 'outer_length')
  num? get outerLength;
  @override
  @JsonKey(name: 'outer_width')
  num? get outerWidth;
  @override
  @JsonKey(name: 'outer_height')
  num? get outerHeight;
  @override
  @JsonKey(name: 'outer_volume')
  num? get outerVolume;
  @override
  @JsonKey(name: 'volume')
  num? get volume;
  @override
  @JsonKey(name: 'outer_gross_weight')
  num? get outerGrossWeight;
  @override
  @JsonKey(name: 'gross_weight')
  num? get grossWeight;
  @override
  @JsonKey(name: 'outer_net_weight')
  num? get outerNetWeight;
  @override
  @JsonKey(name: 'net_weight')
  num? get netWeight;
  @override
  @JsonKey(name: 'entries_count')
  int? get entriesCount;
  @override
  @JsonKey(name: 'entries')
  List<WarehouseReceiptItemEntry>? get entries;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WarehouseReceiptItemImplCopyWith<_$WarehouseReceiptItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quotation_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuotationList _$QuotationListFromJson(Map<String, dynamic> json) {
  return _QuotationList.fromJson(json);
}

/// @nodoc
mixin _$QuotationList {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_no')
  String? get quoteNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'inquiry_at')
  String? get inquiryAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'quote_at')
  String? get quoteAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_company')
  String? get subCompany => throw _privateConstructorUsedError;
  String? get curreny => throw _privateConstructorUsedError;
  String? get exchange => throw _privateConstructorUsedError;
  @JsonKey(name: 'offer_type')
  String? get offerType => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_clause')
  String? get priceClause => throw _privateConstructorUsedError;
  @JsonKey(name: 'settlement_type')
  String? get settlementType => throw _privateConstructorUsedError;
  @JsonKey(name: 'trade_country')
  String? get tradeCountry => throw _privateConstructorUsedError;
  @JsonKey(name: 'out_port')
  String? get outPort => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_port')
  String? get arrivalPort => throw _privateConstructorUsedError;
  String? get transport => throw _privateConstructorUsedError;
  @JsonKey(name: 'commission_rate')
  String? get commissionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'trade_type')
  String? get tradeType => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_user')
  String? get saleUser => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection_source')
  String? get collectionSource => throw _privateConstructorUsedError;
  @JsonKey(name: 'collection_content')
  String? get collectionContent => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'creator_id')
  int? get creatorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int? get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_type')
  String? get itemType => throw _privateConstructorUsedError;
  @JsonKey(name: 'department_id')
  int? get departmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_tax_inclusive')
  bool? get isTaxInclusive => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_count')
  int? get productCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'sum_qty')
  String? get sumQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'language')
  String? get language => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_id')
  String? get contactId => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_sent_at')
  DateTime? get lastSentAt => throw _privateConstructorUsedError;
  List<User>? get collaborators => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  User? get creator => throw _privateConstructorUsedError;
  Company? get company => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuotationListCopyWith<QuotationList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuotationListCopyWith<$Res> {
  factory $QuotationListCopyWith(
          QuotationList value, $Res Function(QuotationList) then) =
      _$QuotationListCopyWithImpl<$Res, QuotationList>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'quote_no') String? quoteNo,
      @JsonKey(name: 'inquiry_at') String? inquiryAt,
      @JsonKey(name: 'quote_at') String? quoteAt,
      @JsonKey(name: 'sub_company') String? subCompany,
      String? curreny,
      String? exchange,
      @JsonKey(name: 'offer_type') String? offerType,
      @JsonKey(name: 'price_clause') String? priceClause,
      @JsonKey(name: 'settlement_type') String? settlementType,
      @JsonKey(name: 'trade_country') String? tradeCountry,
      @JsonKey(name: 'out_port') String? outPort,
      @JsonKey(name: 'arrival_port') String? arrivalPort,
      String? transport,
      @JsonKey(name: 'commission_rate') String? commissionRate,
      @JsonKey(name: 'trade_type') String? tradeType,
      String? status,
      @JsonKey(name: 'sale_user') String? saleUser,
      @JsonKey(name: 'collection_source') String? collectionSource,
      @JsonKey(name: 'collection_content') String? collectionContent,
      String? remark,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'creator_id') int? creatorId,
      @JsonKey(name: 'company_id') int? companyId,
      @JsonKey(name: 'item_type') String? itemType,
      @JsonKey(name: 'department_id') int? departmentId,
      @JsonKey(name: 'is_tax_inclusive') bool? isTaxInclusive,
      @JsonKey(name: 'product_count') int? productCount,
      @JsonKey(name: 'sum_qty') String? sumQty,
      @JsonKey(name: 'language') String? language,
      @JsonKey(name: 'contact_id') String? contactId,
      @JsonKey(name: 'last_sent_at') DateTime? lastSentAt,
      List<User>? collaborators,
      User? user,
      User? creator,
      Company? company});

  $UserCopyWith<$Res>? get user;
  $UserCopyWith<$Res>? get creator;
  $CompanyCopyWith<$Res>? get company;
}

/// @nodoc
class _$QuotationListCopyWithImpl<$Res, $Val extends QuotationList>
    implements $QuotationListCopyWith<$Res> {
  _$QuotationListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? quoteNo = freezed,
    Object? inquiryAt = freezed,
    Object? quoteAt = freezed,
    Object? subCompany = freezed,
    Object? curreny = freezed,
    Object? exchange = freezed,
    Object? offerType = freezed,
    Object? priceClause = freezed,
    Object? settlementType = freezed,
    Object? tradeCountry = freezed,
    Object? outPort = freezed,
    Object? arrivalPort = freezed,
    Object? transport = freezed,
    Object? commissionRate = freezed,
    Object? tradeType = freezed,
    Object? status = freezed,
    Object? saleUser = freezed,
    Object? collectionSource = freezed,
    Object? collectionContent = freezed,
    Object? remark = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userId = freezed,
    Object? creatorId = freezed,
    Object? companyId = freezed,
    Object? itemType = freezed,
    Object? departmentId = freezed,
    Object? isTaxInclusive = freezed,
    Object? productCount = freezed,
    Object? sumQty = freezed,
    Object? language = freezed,
    Object? contactId = freezed,
    Object? lastSentAt = freezed,
    Object? collaborators = freezed,
    Object? user = freezed,
    Object? creator = freezed,
    Object? company = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      quoteNo: freezed == quoteNo
          ? _value.quoteNo
          : quoteNo // ignore: cast_nullable_to_non_nullable
              as String?,
      inquiryAt: freezed == inquiryAt
          ? _value.inquiryAt
          : inquiryAt // ignore: cast_nullable_to_non_nullable
              as String?,
      quoteAt: freezed == quoteAt
          ? _value.quoteAt
          : quoteAt // ignore: cast_nullable_to_non_nullable
              as String?,
      subCompany: freezed == subCompany
          ? _value.subCompany
          : subCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      curreny: freezed == curreny
          ? _value.curreny
          : curreny // ignore: cast_nullable_to_non_nullable
              as String?,
      exchange: freezed == exchange
          ? _value.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String?,
      offerType: freezed == offerType
          ? _value.offerType
          : offerType // ignore: cast_nullable_to_non_nullable
              as String?,
      priceClause: freezed == priceClause
          ? _value.priceClause
          : priceClause // ignore: cast_nullable_to_non_nullable
              as String?,
      settlementType: freezed == settlementType
          ? _value.settlementType
          : settlementType // ignore: cast_nullable_to_non_nullable
              as String?,
      tradeCountry: freezed == tradeCountry
          ? _value.tradeCountry
          : tradeCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      outPort: freezed == outPort
          ? _value.outPort
          : outPort // ignore: cast_nullable_to_non_nullable
              as String?,
      arrivalPort: freezed == arrivalPort
          ? _value.arrivalPort
          : arrivalPort // ignore: cast_nullable_to_non_nullable
              as String?,
      transport: freezed == transport
          ? _value.transport
          : transport // ignore: cast_nullable_to_non_nullable
              as String?,
      commissionRate: freezed == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as String?,
      tradeType: freezed == tradeType
          ? _value.tradeType
          : tradeType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      saleUser: freezed == saleUser
          ? _value.saleUser
          : saleUser // ignore: cast_nullable_to_non_nullable
              as String?,
      collectionSource: freezed == collectionSource
          ? _value.collectionSource
          : collectionSource // ignore: cast_nullable_to_non_nullable
              as String?,
      collectionContent: freezed == collectionContent
          ? _value.collectionContent
          : collectionContent // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      creatorId: freezed == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as int?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int?,
      itemType: freezed == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String?,
      departmentId: freezed == departmentId
          ? _value.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      isTaxInclusive: freezed == isTaxInclusive
          ? _value.isTaxInclusive
          : isTaxInclusive // ignore: cast_nullable_to_non_nullable
              as bool?,
      productCount: freezed == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int?,
      sumQty: freezed == sumQty
          ? _value.sumQty
          : sumQty // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      contactId: freezed == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSentAt: freezed == lastSentAt
          ? _value.lastSentAt
          : lastSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      collaborators: freezed == collaborators
          ? _value.collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as User?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as Company?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get creator {
    if (_value.creator == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.creator!, (value) {
      return _then(_value.copyWith(creator: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CompanyCopyWith<$Res>? get company {
    if (_value.company == null) {
      return null;
    }

    return $CompanyCopyWith<$Res>(_value.company!, (value) {
      return _then(_value.copyWith(company: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuotationListImplCopyWith<$Res>
    implements $QuotationListCopyWith<$Res> {
  factory _$$QuotationListImplCopyWith(
          _$QuotationListImpl value, $Res Function(_$QuotationListImpl) then) =
      __$$QuotationListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'quote_no') String? quoteNo,
      @JsonKey(name: 'inquiry_at') String? inquiryAt,
      @JsonKey(name: 'quote_at') String? quoteAt,
      @JsonKey(name: 'sub_company') String? subCompany,
      String? curreny,
      String? exchange,
      @JsonKey(name: 'offer_type') String? offerType,
      @JsonKey(name: 'price_clause') String? priceClause,
      @JsonKey(name: 'settlement_type') String? settlementType,
      @JsonKey(name: 'trade_country') String? tradeCountry,
      @JsonKey(name: 'out_port') String? outPort,
      @JsonKey(name: 'arrival_port') String? arrivalPort,
      String? transport,
      @JsonKey(name: 'commission_rate') String? commissionRate,
      @JsonKey(name: 'trade_type') String? tradeType,
      String? status,
      @JsonKey(name: 'sale_user') String? saleUser,
      @JsonKey(name: 'collection_source') String? collectionSource,
      @JsonKey(name: 'collection_content') String? collectionContent,
      String? remark,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'creator_id') int? creatorId,
      @JsonKey(name: 'company_id') int? companyId,
      @JsonKey(name: 'item_type') String? itemType,
      @JsonKey(name: 'department_id') int? departmentId,
      @JsonKey(name: 'is_tax_inclusive') bool? isTaxInclusive,
      @JsonKey(name: 'product_count') int? productCount,
      @JsonKey(name: 'sum_qty') String? sumQty,
      @JsonKey(name: 'language') String? language,
      @JsonKey(name: 'contact_id') String? contactId,
      @JsonKey(name: 'last_sent_at') DateTime? lastSentAt,
      List<User>? collaborators,
      User? user,
      User? creator,
      Company? company});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $UserCopyWith<$Res>? get creator;
  @override
  $CompanyCopyWith<$Res>? get company;
}

/// @nodoc
class __$$QuotationListImplCopyWithImpl<$Res>
    extends _$QuotationListCopyWithImpl<$Res, _$QuotationListImpl>
    implements _$$QuotationListImplCopyWith<$Res> {
  __$$QuotationListImplCopyWithImpl(
      _$QuotationListImpl _value, $Res Function(_$QuotationListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? quoteNo = freezed,
    Object? inquiryAt = freezed,
    Object? quoteAt = freezed,
    Object? subCompany = freezed,
    Object? curreny = freezed,
    Object? exchange = freezed,
    Object? offerType = freezed,
    Object? priceClause = freezed,
    Object? settlementType = freezed,
    Object? tradeCountry = freezed,
    Object? outPort = freezed,
    Object? arrivalPort = freezed,
    Object? transport = freezed,
    Object? commissionRate = freezed,
    Object? tradeType = freezed,
    Object? status = freezed,
    Object? saleUser = freezed,
    Object? collectionSource = freezed,
    Object? collectionContent = freezed,
    Object? remark = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userId = freezed,
    Object? creatorId = freezed,
    Object? companyId = freezed,
    Object? itemType = freezed,
    Object? departmentId = freezed,
    Object? isTaxInclusive = freezed,
    Object? productCount = freezed,
    Object? sumQty = freezed,
    Object? language = freezed,
    Object? contactId = freezed,
    Object? lastSentAt = freezed,
    Object? collaborators = freezed,
    Object? user = freezed,
    Object? creator = freezed,
    Object? company = freezed,
  }) {
    return _then(_$QuotationListImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      quoteNo: freezed == quoteNo
          ? _value.quoteNo
          : quoteNo // ignore: cast_nullable_to_non_nullable
              as String?,
      inquiryAt: freezed == inquiryAt
          ? _value.inquiryAt
          : inquiryAt // ignore: cast_nullable_to_non_nullable
              as String?,
      quoteAt: freezed == quoteAt
          ? _value.quoteAt
          : quoteAt // ignore: cast_nullable_to_non_nullable
              as String?,
      subCompany: freezed == subCompany
          ? _value.subCompany
          : subCompany // ignore: cast_nullable_to_non_nullable
              as String?,
      curreny: freezed == curreny
          ? _value.curreny
          : curreny // ignore: cast_nullable_to_non_nullable
              as String?,
      exchange: freezed == exchange
          ? _value.exchange
          : exchange // ignore: cast_nullable_to_non_nullable
              as String?,
      offerType: freezed == offerType
          ? _value.offerType
          : offerType // ignore: cast_nullable_to_non_nullable
              as String?,
      priceClause: freezed == priceClause
          ? _value.priceClause
          : priceClause // ignore: cast_nullable_to_non_nullable
              as String?,
      settlementType: freezed == settlementType
          ? _value.settlementType
          : settlementType // ignore: cast_nullable_to_non_nullable
              as String?,
      tradeCountry: freezed == tradeCountry
          ? _value.tradeCountry
          : tradeCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      outPort: freezed == outPort
          ? _value.outPort
          : outPort // ignore: cast_nullable_to_non_nullable
              as String?,
      arrivalPort: freezed == arrivalPort
          ? _value.arrivalPort
          : arrivalPort // ignore: cast_nullable_to_non_nullable
              as String?,
      transport: freezed == transport
          ? _value.transport
          : transport // ignore: cast_nullable_to_non_nullable
              as String?,
      commissionRate: freezed == commissionRate
          ? _value.commissionRate
          : commissionRate // ignore: cast_nullable_to_non_nullable
              as String?,
      tradeType: freezed == tradeType
          ? _value.tradeType
          : tradeType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      saleUser: freezed == saleUser
          ? _value.saleUser
          : saleUser // ignore: cast_nullable_to_non_nullable
              as String?,
      collectionSource: freezed == collectionSource
          ? _value.collectionSource
          : collectionSource // ignore: cast_nullable_to_non_nullable
              as String?,
      collectionContent: freezed == collectionContent
          ? _value.collectionContent
          : collectionContent // ignore: cast_nullable_to_non_nullable
              as String?,
      remark: freezed == remark
          ? _value.remark
          : remark // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      creatorId: freezed == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as int?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int?,
      itemType: freezed == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as String?,
      departmentId: freezed == departmentId
          ? _value.departmentId
          : departmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      isTaxInclusive: freezed == isTaxInclusive
          ? _value.isTaxInclusive
          : isTaxInclusive // ignore: cast_nullable_to_non_nullable
              as bool?,
      productCount: freezed == productCount
          ? _value.productCount
          : productCount // ignore: cast_nullable_to_non_nullable
              as int?,
      sumQty: freezed == sumQty
          ? _value.sumQty
          : sumQty // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      contactId: freezed == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSentAt: freezed == lastSentAt
          ? _value.lastSentAt
          : lastSentAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      collaborators: freezed == collaborators
          ? _value._collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as List<User>?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      creator: freezed == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as User?,
      company: freezed == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as Company?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuotationListImpl implements _QuotationList {
  _$QuotationListImpl(
      {this.id,
      @JsonKey(name: 'quote_no') this.quoteNo,
      @JsonKey(name: 'inquiry_at') this.inquiryAt,
      @JsonKey(name: 'quote_at') this.quoteAt,
      @JsonKey(name: 'sub_company') this.subCompany,
      this.curreny,
      this.exchange,
      @JsonKey(name: 'offer_type') this.offerType,
      @JsonKey(name: 'price_clause') this.priceClause,
      @JsonKey(name: 'settlement_type') this.settlementType,
      @JsonKey(name: 'trade_country') this.tradeCountry,
      @JsonKey(name: 'out_port') this.outPort,
      @JsonKey(name: 'arrival_port') this.arrivalPort,
      this.transport,
      @JsonKey(name: 'commission_rate') this.commissionRate,
      @JsonKey(name: 'trade_type') this.tradeType,
      this.status,
      @JsonKey(name: 'sale_user') this.saleUser,
      @JsonKey(name: 'collection_source') this.collectionSource,
      @JsonKey(name: 'collection_content') this.collectionContent,
      this.remark,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'creator_id') this.creatorId,
      @JsonKey(name: 'company_id') this.companyId,
      @JsonKey(name: 'item_type') this.itemType,
      @JsonKey(name: 'department_id') this.departmentId,
      @JsonKey(name: 'is_tax_inclusive') this.isTaxInclusive,
      @JsonKey(name: 'product_count') this.productCount,
      @JsonKey(name: 'sum_qty') this.sumQty,
      @JsonKey(name: 'language') this.language,
      @JsonKey(name: 'contact_id') this.contactId,
      @JsonKey(name: 'last_sent_at') this.lastSentAt,
      final List<User>? collaborators,
      this.user,
      this.creator,
      this.company})
      : _collaborators = collaborators;

  factory _$QuotationListImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuotationListImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'quote_no')
  final String? quoteNo;
  @override
  @JsonKey(name: 'inquiry_at')
  final String? inquiryAt;
  @override
  @JsonKey(name: 'quote_at')
  final String? quoteAt;
  @override
  @JsonKey(name: 'sub_company')
  final String? subCompany;
  @override
  final String? curreny;
  @override
  final String? exchange;
  @override
  @JsonKey(name: 'offer_type')
  final String? offerType;
  @override
  @JsonKey(name: 'price_clause')
  final String? priceClause;
  @override
  @JsonKey(name: 'settlement_type')
  final String? settlementType;
  @override
  @JsonKey(name: 'trade_country')
  final String? tradeCountry;
  @override
  @JsonKey(name: 'out_port')
  final String? outPort;
  @override
  @JsonKey(name: 'arrival_port')
  final String? arrivalPort;
  @override
  final String? transport;
  @override
  @JsonKey(name: 'commission_rate')
  final String? commissionRate;
  @override
  @JsonKey(name: 'trade_type')
  final String? tradeType;
  @override
  final String? status;
  @override
  @JsonKey(name: 'sale_user')
  final String? saleUser;
  @override
  @JsonKey(name: 'collection_source')
  final String? collectionSource;
  @override
  @JsonKey(name: 'collection_content')
  final String? collectionContent;
  @override
  final String? remark;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'creator_id')
  final int? creatorId;
  @override
  @JsonKey(name: 'company_id')
  final int? companyId;
  @override
  @JsonKey(name: 'item_type')
  final String? itemType;
  @override
  @JsonKey(name: 'department_id')
  final int? departmentId;
  @override
  @JsonKey(name: 'is_tax_inclusive')
  final bool? isTaxInclusive;
  @override
  @JsonKey(name: 'product_count')
  final int? productCount;
  @override
  @JsonKey(name: 'sum_qty')
  final String? sumQty;
  @override
  @JsonKey(name: 'language')
  final String? language;
  @override
  @JsonKey(name: 'contact_id')
  final String? contactId;
  @override
  @JsonKey(name: 'last_sent_at')
  final DateTime? lastSentAt;
  final List<User>? _collaborators;
  @override
  List<User>? get collaborators {
    final value = _collaborators;
    if (value == null) return null;
    if (_collaborators is EqualUnmodifiableListView) return _collaborators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final User? user;
  @override
  final User? creator;
  @override
  final Company? company;

  @override
  String toString() {
    return 'QuotationList(id: $id, quoteNo: $quoteNo, inquiryAt: $inquiryAt, quoteAt: $quoteAt, subCompany: $subCompany, curreny: $curreny, exchange: $exchange, offerType: $offerType, priceClause: $priceClause, settlementType: $settlementType, tradeCountry: $tradeCountry, outPort: $outPort, arrivalPort: $arrivalPort, transport: $transport, commissionRate: $commissionRate, tradeType: $tradeType, status: $status, saleUser: $saleUser, collectionSource: $collectionSource, collectionContent: $collectionContent, remark: $remark, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, creatorId: $creatorId, companyId: $companyId, itemType: $itemType, departmentId: $departmentId, isTaxInclusive: $isTaxInclusive, productCount: $productCount, sumQty: $sumQty, language: $language, contactId: $contactId, lastSentAt: $lastSentAt, collaborators: $collaborators, user: $user, creator: $creator, company: $company)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuotationListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quoteNo, quoteNo) || other.quoteNo == quoteNo) &&
            (identical(other.inquiryAt, inquiryAt) ||
                other.inquiryAt == inquiryAt) &&
            (identical(other.quoteAt, quoteAt) || other.quoteAt == quoteAt) &&
            (identical(other.subCompany, subCompany) ||
                other.subCompany == subCompany) &&
            (identical(other.curreny, curreny) || other.curreny == curreny) &&
            (identical(other.exchange, exchange) ||
                other.exchange == exchange) &&
            (identical(other.offerType, offerType) ||
                other.offerType == offerType) &&
            (identical(other.priceClause, priceClause) ||
                other.priceClause == priceClause) &&
            (identical(other.settlementType, settlementType) ||
                other.settlementType == settlementType) &&
            (identical(other.tradeCountry, tradeCountry) ||
                other.tradeCountry == tradeCountry) &&
            (identical(other.outPort, outPort) || other.outPort == outPort) &&
            (identical(other.arrivalPort, arrivalPort) ||
                other.arrivalPort == arrivalPort) &&
            (identical(other.transport, transport) ||
                other.transport == transport) &&
            (identical(other.commissionRate, commissionRate) ||
                other.commissionRate == commissionRate) &&
            (identical(other.tradeType, tradeType) ||
                other.tradeType == tradeType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.saleUser, saleUser) ||
                other.saleUser == saleUser) &&
            (identical(other.collectionSource, collectionSource) ||
                other.collectionSource == collectionSource) &&
            (identical(other.collectionContent, collectionContent) ||
                other.collectionContent == collectionContent) &&
            (identical(other.remark, remark) || other.remark == remark) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.departmentId, departmentId) ||
                other.departmentId == departmentId) &&
            (identical(other.isTaxInclusive, isTaxInclusive) ||
                other.isTaxInclusive == isTaxInclusive) &&
            (identical(other.productCount, productCount) ||
                other.productCount == productCount) &&
            (identical(other.sumQty, sumQty) || other.sumQty == sumQty) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.lastSentAt, lastSentAt) ||
                other.lastSentAt == lastSentAt) &&
            const DeepCollectionEquality()
                .equals(other._collaborators, _collaborators) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.company, company) || other.company == company));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        quoteNo,
        inquiryAt,
        quoteAt,
        subCompany,
        curreny,
        exchange,
        offerType,
        priceClause,
        settlementType,
        tradeCountry,
        outPort,
        arrivalPort,
        transport,
        commissionRate,
        tradeType,
        status,
        saleUser,
        collectionSource,
        collectionContent,
        remark,
        createdAt,
        updatedAt,
        userId,
        creatorId,
        companyId,
        itemType,
        departmentId,
        isTaxInclusive,
        productCount,
        sumQty,
        language,
        contactId,
        lastSentAt,
        const DeepCollectionEquality().hash(_collaborators),
        user,
        creator,
        company
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuotationListImplCopyWith<_$QuotationListImpl> get copyWith =>
      __$$QuotationListImplCopyWithImpl<_$QuotationListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuotationListImplToJson(
      this,
    );
  }
}

abstract class _QuotationList implements QuotationList {
  factory _QuotationList(
      {final int? id,
      @JsonKey(name: 'quote_no') final String? quoteNo,
      @JsonKey(name: 'inquiry_at') final String? inquiryAt,
      @JsonKey(name: 'quote_at') final String? quoteAt,
      @JsonKey(name: 'sub_company') final String? subCompany,
      final String? curreny,
      final String? exchange,
      @JsonKey(name: 'offer_type') final String? offerType,
      @JsonKey(name: 'price_clause') final String? priceClause,
      @JsonKey(name: 'settlement_type') final String? settlementType,
      @JsonKey(name: 'trade_country') final String? tradeCountry,
      @JsonKey(name: 'out_port') final String? outPort,
      @JsonKey(name: 'arrival_port') final String? arrivalPort,
      final String? transport,
      @JsonKey(name: 'commission_rate') final String? commissionRate,
      @JsonKey(name: 'trade_type') final String? tradeType,
      final String? status,
      @JsonKey(name: 'sale_user') final String? saleUser,
      @JsonKey(name: 'collection_source') final String? collectionSource,
      @JsonKey(name: 'collection_content') final String? collectionContent,
      final String? remark,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'creator_id') final int? creatorId,
      @JsonKey(name: 'company_id') final int? companyId,
      @JsonKey(name: 'item_type') final String? itemType,
      @JsonKey(name: 'department_id') final int? departmentId,
      @JsonKey(name: 'is_tax_inclusive') final bool? isTaxInclusive,
      @JsonKey(name: 'product_count') final int? productCount,
      @JsonKey(name: 'sum_qty') final String? sumQty,
      @JsonKey(name: 'language') final String? language,
      @JsonKey(name: 'contact_id') final String? contactId,
      @JsonKey(name: 'last_sent_at') final DateTime? lastSentAt,
      final List<User>? collaborators,
      final User? user,
      final User? creator,
      final Company? company}) = _$QuotationListImpl;

  factory _QuotationList.fromJson(Map<String, dynamic> json) =
      _$QuotationListImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'quote_no')
  String? get quoteNo;
  @override
  @JsonKey(name: 'inquiry_at')
  String? get inquiryAt;
  @override
  @JsonKey(name: 'quote_at')
  String? get quoteAt;
  @override
  @JsonKey(name: 'sub_company')
  String? get subCompany;
  @override
  String? get curreny;
  @override
  String? get exchange;
  @override
  @JsonKey(name: 'offer_type')
  String? get offerType;
  @override
  @JsonKey(name: 'price_clause')
  String? get priceClause;
  @override
  @JsonKey(name: 'settlement_type')
  String? get settlementType;
  @override
  @JsonKey(name: 'trade_country')
  String? get tradeCountry;
  @override
  @JsonKey(name: 'out_port')
  String? get outPort;
  @override
  @JsonKey(name: 'arrival_port')
  String? get arrivalPort;
  @override
  String? get transport;
  @override
  @JsonKey(name: 'commission_rate')
  String? get commissionRate;
  @override
  @JsonKey(name: 'trade_type')
  String? get tradeType;
  @override
  String? get status;
  @override
  @JsonKey(name: 'sale_user')
  String? get saleUser;
  @override
  @JsonKey(name: 'collection_source')
  String? get collectionSource;
  @override
  @JsonKey(name: 'collection_content')
  String? get collectionContent;
  @override
  String? get remark;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'creator_id')
  int? get creatorId;
  @override
  @JsonKey(name: 'company_id')
  int? get companyId;
  @override
  @JsonKey(name: 'item_type')
  String? get itemType;
  @override
  @JsonKey(name: 'department_id')
  int? get departmentId;
  @override
  @JsonKey(name: 'is_tax_inclusive')
  bool? get isTaxInclusive;
  @override
  @JsonKey(name: 'product_count')
  int? get productCount;
  @override
  @JsonKey(name: 'sum_qty')
  String? get sumQty;
  @override
  @JsonKey(name: 'language')
  String? get language;
  @override
  @JsonKey(name: 'contact_id')
  String? get contactId;
  @override
  @JsonKey(name: 'last_sent_at')
  DateTime? get lastSentAt;
  @override
  List<User>? get collaborators;
  @override
  User? get user;
  @override
  User? get creator;
  @override
  Company? get company;
  @override
  @JsonKey(ignore: true)
  _$$QuotationListImplCopyWith<_$QuotationListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

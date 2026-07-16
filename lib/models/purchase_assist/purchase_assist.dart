/// 解析可能为 String 或 num 的字段，统一转为 int?
int? _intFromJson(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

/// 解析可能为 String 或 int 的字段，统一转为 String?
String? _stringOrIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num) return value.toString();
  return value.toString();
}

/// 比价助手 - 多平台搜索产品项（api/tenant/multi-platform/search 返回列表项）
class PurchaseAssistSearchProduct {
  const PurchaseAssistSearchProduct({
    this.id,
    this.name,
    this.price,
    this.imageUrl,
    this.productUrl,
    this.location,
    this.moq,
    this.rateScore,
    this.supplierName,
    this.supplier,
    this.tags,
  });

  final int? id;
  final String? name;
  final String? price;
  final String? imageUrl;
  final String? productUrl;
  final String? location;
  final String? moq;
  final String? rateScore;
  final String? supplierName;
  final int? supplier;
  final List<String>? tags;

  factory PurchaseAssistSearchProduct.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistSearchProduct(
      id: _intFromJson(json['id']),
      name: json['name'] as String?,
      price: _stringOrIntFromJson(json['price']),
      moq: _stringOrIntFromJson(json['moq']),
      rateScore: _stringOrIntFromJson(json['rate_score']),
      imageUrl: json['image_url'] as String?,
      productUrl: json['product_url'] as String?,
      location: json['location'] as String?,
      supplierName: json['supplier_name'] as String?,
      supplier: (json['supplier'] as num?)?.toInt(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }
}

// ----- 任务列表（GET api/tenant/product-comparison/tasks） -----

/// 任务列表中的用户信息
class PurchaseAssistTaskUser {
  const PurchaseAssistTaskUser({
    this.id,
    this.name,
    this.sourceFrom,
    this.jobNumber,
    this.lastLoginAt,
    this.hasPassword,
    this.phone,
    this.contactEmail,
    this.contactPhone,
    this.contactWechat,
    this.contactFax,
    this.contactAddress,
    this.workLocation,
    this.job,
    this.position,
    this.employStatus,
  });

  final int? id;
  final String? name;
  final String? sourceFrom;
  final String? jobNumber;
  final String? lastLoginAt;
  final bool? hasPassword;
  final String? phone;
  final String? contactEmail;
  final String? contactPhone;
  final String? contactWechat;
  final String? contactFax;
  final String? contactAddress;
  final String? workLocation;
  final String? job;
  final String? position;
  final int? employStatus;

  factory PurchaseAssistTaskUser.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistTaskUser(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      sourceFrom: json['source_from'] as String?,
      jobNumber: json['job_number'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      hasPassword: json['has_password'] as bool?,
      phone: json['phone'] as String?,
      contactEmail: json['contact_email'] as String?,
      contactPhone: json['contact_phone'] as String?,
      contactWechat: json['contact_wechat'] as String?,
      contactFax: json['contact_fax'] as String?,
      contactAddress: json['contact_address'] as String?,
      workLocation: json['work_location'] as String?,
      job: json['job'] as String?,
      position: json['position'] as String?,
      employStatus: (json['employ_status'] as num?)?.toInt(),
    );
  }
}

/// 任务摘要
class PurchaseAssistTaskSummary {
  const PurchaseAssistTaskSummary({
    this.total,
    this.failed,
    this.success,
  });

  final int? total;
  final int? failed;
  final int? success;

  factory PurchaseAssistTaskSummary.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistTaskSummary(
      total: (json['total'] as num?)?.toInt(),
      failed: (json['failed'] as num?)?.toInt(),
      success: (json['success'] as num?)?.toInt(),
    );
  }
}

/// 任务中的媒体项
class PurchaseAssistTaskMediaItem {
  const PurchaseAssistTaskMediaItem({
    this.id,
    this.name,
    this.url,
    this.whiteUrl,
    this.thumbUrl,
    this.type,
    this.filename,
    this.address,
    this.shotAt,
    this.collectionName,
    this.categoryId,
  });

  final int? id;
  final String? name;
  final String? url;
  final String? whiteUrl;
  final String? thumbUrl;
  final String? type;
  final String? filename;
  final String? address;
  final String? shotAt;
  final String? collectionName;
  final dynamic categoryId;

  factory PurchaseAssistTaskMediaItem.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistTaskMediaItem(
      id: _intFromJson(json['id']),
      name: json['name'] as String?,
      url: json['url'] as String?,
      whiteUrl: json['white_url'] as String?,
      thumbUrl: json['thumb_url'] as String?,
      type: json['type'] as String?,
      filename: json['filename'] as String?,
      address: json['address'] as String?,
      shotAt: json['shot_at'] as String?,
      collectionName: json['collection_name'] as String?,
      categoryId: json['categoryId'],
    );
  }
}

/// 比价助手任务列表项（api/tenant/product-comparison/tasks）
class PurchaseAssistTaskListItem {
  const PurchaseAssistTaskListItem({
    this.id,
    this.platform,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.total,
    this.failedCount,
    this.successCount,
    this.user,
    this.summary,
    this.media,
  });

  final int? id;
  final List? platform;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;
  final int? total;
  final int? failedCount;
  final int? successCount;
  final PurchaseAssistTaskUser? user;
  final PurchaseAssistTaskSummary? summary;
  final List<PurchaseAssistTaskMediaItem>? media;

  static List? _parsePlatform(dynamic value) {
    if (value == null) return null;
    if (value is String) return [value];
    if (value is List) {
      return value;
    }
    return value;
  }

  factory PurchaseAssistTaskListItem.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistTaskListItem(
      id: (json['id'] as num?)?.toInt(),
      platform: _parsePlatform(json['platform']),
      userId: (json['user_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      total: (json['total'] as num?)?.toInt(),
      failedCount: (json['failed_count'] as num?)?.toInt(),
      successCount: (json['success_count'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : PurchaseAssistTaskUser.fromJson(
              json['user'] as Map<String, dynamic>),
      // summary: json['summary'] == null
      //     ? null
      //     : PurchaseAssistTaskSummary.fromJson(
      //         json['summary'] as Map<String, dynamic>),
      media: (json['media'] as List<dynamic>?)
          ?.map((e) =>
              PurchaseAssistTaskMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  get title => null;
}

/// 任务详情中的单个结果商品
class PurchaseAssistTaskResultProduct {
  const PurchaseAssistTaskResultProduct({
    this.id,
    this.name,
    this.imageUrl,
    this.productUrl,
    this.price,
    this.supplierName,
    this.saleNumber,
    this.moq,
    this.rateScore,
    this.location,
    this.tags,
  });

  final int? id;
  final String? name;
  final String? imageUrl;
  final String? productUrl;
  final String? price;
  final String? supplierName;
  final int? saleNumber;
  final int? moq;
  final String? rateScore;
  final String? location;
  final List<String>? tags;

  factory PurchaseAssistTaskResultProduct.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistTaskResultProduct(
      id: _intFromJson(json['id']),
      price: _stringOrIntFromJson(json['price']),
      saleNumber: _intFromJson(json['sale_number']),
      moq: _intFromJson(json['moq']),
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      productUrl: json['product_url'] as String?,
      supplierName: json['supplier_name'] as String?,
      rateScore: json['rate_score'] as String?,
      location: json['location'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }
}

/// 任务详情单条（每条对应一张图搜的结果）
class PurchaseAssistTaskDetailItem {
  const PurchaseAssistTaskDetailItem({
    this.id,
    this.taskId,
    this.results,
    this.status,
    this.selectedItemId,
    this.createdAt,
    this.updatedAt,
    this.media,
    this.productUrl,
  });

  final int? id;
  final int? taskId;
  final Map<String, List<PurchaseAssistTaskResultProduct>>? results;
  final String? status;
  final dynamic selectedItemId;
  final String? createdAt;
  final String? updatedAt;
  final PurchaseAssistTaskMediaItem? media;
  final String? productUrl;

  static Map<String, List<PurchaseAssistTaskResultProduct>>? _parseResults(
    dynamic value,
  ) {
    if (value == null) return null;
    if (value is! Map) return null;

    final result = <String, List<PurchaseAssistTaskResultProduct>>{};
    final grouped = Map<String, dynamic>.from(value);
    for (final entry in grouped.entries) {
      final platform = entry.key;
      final rawList = entry.value;
      if (rawList is! List) continue;
      final products = rawList
          .whereType<Map>()
          .map((e) => PurchaseAssistTaskResultProduct.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
      result[platform] = products;
    }

    return result.isEmpty ? null : result;
  }

  factory PurchaseAssistTaskDetailItem.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistTaskDetailItem(
      id: _intFromJson(json['id']),
      taskId: _intFromJson(json['task_id']),
      results: _parseResults(json['results']),
      status: json['status'] as String?,
      productUrl: json['product_url'] as String?,
      selectedItemId: json['selected_item_id'],
      media: json['media'] == null
          ? null
          : PurchaseAssistTaskMediaItem.fromJson(
              json['media'] as Map<String, dynamic>),
    );
  }
}

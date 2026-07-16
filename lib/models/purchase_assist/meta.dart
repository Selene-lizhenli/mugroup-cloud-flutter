List<dynamic>? _parsePlatform(dynamic value) {
  if (value == null) return null;
  if (value is List) return value;
  if (value is String) return [value];
  if (value is Map) return [value];
  return [value];
}

int _parseInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

Map<String, dynamic>? _parseMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

/// 任务详情接口返回的 meta 结构
class PurchaseAssistMeta {
  const PurchaseAssistMeta({
    this.platform, 
  });

  final List<dynamic>? platform; 

  factory PurchaseAssistMeta.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistMeta(
      platform: _parsePlatform(json['platform']),
    );
  }
}

class PurchaseAssistPagination {
  const PurchaseAssistPagination({
    required this.total,
    required this.count,
    this.perPage,
    this.currentPage,
    required this.totalPages,
    this.links,
  });

  final int total;
  final int count;
  final int? perPage;
  final int? currentPage;
  final int totalPages;
  final Map<String, dynamic>? links;

  factory PurchaseAssistPagination.fromJson(Map<String, dynamic> json) {
    return PurchaseAssistPagination(
      total: _parseInt(json['total']),
      count: _parseInt(json['count']),
      perPage: json['per_page'] == null ? null : _parseInt(json['per_page']),
      currentPage:
          json['current_page'] == null ? null : _parseInt(json['current_page']),
      totalPages: _parseInt(json['total_pages']),
      links: _parseMap(json['links']),
    );
  }
}
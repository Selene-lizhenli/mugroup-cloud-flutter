
/// 租户相关常量（与 core.currentTenant 判断逻辑对应）
class TenantConstants {
  /// 样品列表查询时按仓库过滤的租户 id， 6是云链的租户
  static const int warehouseMainTenantId = 6;
}

/// 搜索平台单项
class SearchPlatformItem {
  final String label;
  final String value;
  const SearchPlatformItem({required this.label, required this.value});
}

/// 比价/搜索可选平台列表（用于标签展示与请求参数）
const List<SearchPlatformItem> searchPlatform = [
  SearchPlatformItem(label: '云链', value: 'cloud'),
  SearchPlatformItem(label: '1688', value: '1688'),
  SearchPlatformItem(label: '国际站', value: 'alibabaglobal'),
  SearchPlatformItem(label: '义乌市场', value: 'yiwugo'),
  SearchPlatformItem(label: '小商品城', value: 'chinagoods'),
];
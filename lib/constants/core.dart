/// 租户相关常量（与 core.currentTenant 判断逻辑对应）
class TenantConstants {
  /// 租户信息（id + 用于展示的文案）
  static const warehouseMain =
      TenantInfo(id: warehouseMainTenantId, label: '云链');
  static const dolphin = TenantInfo(id: dolphinTenantId, label: '海豚');

  /// 样品列表查询时按仓库过滤的租户 id，6 是云链租户（云链）
  static const int warehouseMainTenantId = 6; 
  /// 海豚租户 id（海豚）；拥有 [permissionShowroomDolphin] 时，部分请求需带请求头 `X-Tenant-ID: $dolphinTenantId`。
  static const int dolphinTenantId = 16;
}

/// 海豚独立样品间权限（后端 permissions 中的 key）
const String permissionShowroomDolphin = 'showroom.dp.show';
//海豚独立样品间id
const int departmentWarehouseIdDolphin = 7;

// 公开的展厅(样品间)
class PublicWarehouseId {
  static const int yiwuqiushi = 1;
  static const int yiwuhongji = 2;
  static const int guangzhouweisiting = 3;
  static const int ningboxicun = 4;
  static const int yiwukaiyuedasha = 5;
  static const int chegnhai = 6;

  /// 公开展厅（样品间）id，与上方常量一一对应。
  static const Set<int> ids = {
    yiwuqiushi,
    yiwuhongji,
    guangzhouweisiting,
    ningboxicun,
    yiwukaiyuedasha,
    chegnhai,
  };
}

class TenantInfo {
  final int id;
  final String label;
  const TenantInfo({required this.id, required this.label});
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
  SearchPlatformItem(label: '亚马逊', value: 'amazon'),
  SearchPlatformItem(label: '国际站', value: 'alibabaglobal'),
  SearchPlatformItem(label: '义乌市场', value: 'yiwugo'),
  SearchPlatformItem(label: '小商品城', value: 'chinagoods'),
];

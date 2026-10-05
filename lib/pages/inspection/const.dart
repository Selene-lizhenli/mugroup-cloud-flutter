// 展示用状态映射（含微瑕，兼容旧数据）
const Map<int, String> inspectionStatusLabelMap = {
  1: '合格',
  2: '微瑕',
  3: '不合格',
  4: '返工',
};

// 表单/编辑用状态映射（不含微瑕，新数据不可选微瑕）
const Map<int, String> inspectionStatusFormLabelMap = {
  0: '未验货',
  1: '合格',
  3: '不合格',
  4: '返工',
};

const String inspectionStatusPendingLabel = '未验货';

// 状态颜色映射
const Map<int, int> inspectionStatusColorValueMap = {
  0: 0xFF999999, // 灰
  1: 0xFF52C41A, // 绿
  2: 0xFFFAAD14, // 黄/橙
  3: 0xFFFF4D4F, // 红
  4: 0xFF1890FF, // 蓝
};

const Map<String, Object> inspectionGroupBasicTemplate = {
  'name': '义乌仓库验货模板',
  'value': 0,
};

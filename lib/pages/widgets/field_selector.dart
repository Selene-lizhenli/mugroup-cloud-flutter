import 'package:cloud/models/field_config.dart';
import 'package:flutter/material.dart';

class FieldSelector extends StatefulWidget {
  final List<FieldConfig> fields; // 当前的配置
  final List<FieldConfig> defaultFields; // 新增：默认配置源
  final ValueChanged<List<FieldConfig>>? onConfigChanged;

  const FieldSelector({
    super.key,
    required this.fields,
    required this.defaultFields, // 必传，否则不知道恢复成什么样
    this.onConfigChanged,
  });

  @override
  State<FieldSelector> createState() => _FieldSelectorState();
}

class _FieldSelectorState extends State<FieldSelector> {
  late List<FieldConfig> _localFields;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  // 初始化数据提取出来，方便重置时复用
  void _initData() {
    // 这里的深拷贝很重要，防止 List 引用污染
    _localFields = widget.fields.map((e) => e.copyWith()).toList();
  }

  // 恢复默认设置逻辑
  void _resetToDefault() {
    setState(() {
      // 从 widget.defaultFields 重新拷贝一份数据
      _localFields = widget.defaultFields.map((e) => e.copyWith()).toList();
    });
  }

  void _toggleItem(int index, bool value) {
    setState(() {
      final oldItem = _localFields[index];
      _localFields[index] = oldItem.copyWith(isVisible: value);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _localFields.removeAt(oldIndex);
      _localFields.insert(newIndex, item);
    });
  }

  bool get _isAllVisible => _localFields.every((e) => e.isVisible);

  void _toggleAll() {
    final bool targetStatus = !_isAllVisible;
    setState(() {
      for (int i = 0; i < _localFields.length; i++) {
        _localFields[i] = _localFields[i].copyWith(isVisible: targetStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // --- 1. 顶部标题栏 ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '基本信息',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Row(
                  children: [
                    Text(
                      '长按排序',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _toggleAll,
                      child: Text(
                        _isAllVisible ? '全部隐藏' : '全部显示',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- 2. 列表区域 ---
          Expanded(
            child: Theme(
              data: theme.copyWith(
                canvasColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: ReorderableListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                itemCount: _localFields.length,
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) {
                      return Material(
                        elevation: 8,
                        color: Colors.transparent,
                        shadowColor: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final item = _localFields[index];

                  return Container(
                    key: ValueKey(item.name),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _toggleItem(index, !item.isVisible),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              ReorderableDragStartListener(
                                index: index,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      right: 12, top: 8, bottom: 8),
                                  color: Colors.transparent,
                                  child: Icon(Icons.drag_indicator,
                                      color: Colors.grey[300], size: 20),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: item.isVisible,
                                  activeColor: Colors.white,
                                  activeTrackColor: theme.primaryColor,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey[200],
                                  trackOutlineColor:
                                      MaterialStateProperty.resolveWith(
                                    (states) => Colors.transparent,
                                  ),
                                  onChanged: (val) => _toggleItem(index, val),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // --- 3. 底部按钮区域 (修改了这里) ---
          Container(
            padding: EdgeInsets.fromLTRB(
                20, 10, 20, MediaQuery.of(context).padding.bottom + 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              children: [
                // 左侧：恢复默认按钮
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700], // 文字颜色
                        side: BorderSide(color: Colors.grey[300]!), // 边框颜色
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _resetToDefault,
                      child: const Text(
                        '恢复默认',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12), // 两个按钮之间的间距
                // 右侧：保存配置按钮
                Expanded(
                  flex: 2, // 权重设为 2，让保存按钮稍微宽一点（可选，也可以设为1）
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, _localFields);
                        if (widget.onConfigChanged != null) {
                          widget.onConfigChanged!(_localFields);
                        }
                      },
                      child: const Text(
                        '保存配置',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud/models/field_config.dart';
import 'package:flutter/material.dart';

class FieldSelector extends StatefulWidget {
  final List<FieldConfig> fields;
  final ValueChanged<List<FieldConfig>> onConfigChanged;

  const FieldSelector({
    super.key,
    required this.fields,
    required this.onConfigChanged,
  });

  @override
  State<FieldSelector> createState() => _FieldSelectorState();
}

class _FieldSelectorState extends State<FieldSelector> {
  // 本地暂存一份数据，用于弹窗内的即时刷新
  late List<FieldConfig> _localFields;

  @override
  void initState() {
    super.initState();
    // 初始化时，复制一份外部传入的数据
    // 注意：这里需要浅拷贝列表，防止直接修改引用
    _localFields = List.from(widget.fields);
  }

  void _toggleItem(int index, bool value) {
    setState(() {
      // 1. 修改本地状态（让开关动起来）
      final oldItem = _localFields[index];
      // 使用 copyWith 生成新对象
      _localFields[index] = oldItem.copyWith(isVisible: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 设置弹窗高度为屏幕的 70%
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // --- 顶部标题栏 ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '字段显示配置',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // 关闭按钮
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onConfigChanged(_localFields);
                  },
                  child: const Text('完成', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // --- 列表区域 ---
          Expanded(
            child: ListView.separated(
              itemCount: _localFields.length,
              separatorBuilder: (ctx, i) =>
                  const Divider(height: 1, indent: 16),
              itemBuilder: (context, index) {
                final item = _localFields[index];

                return SwitchListTile(
                  // 样式调整
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  activeColor: Theme.of(context).primaryColor,

                  // 左侧显示标签
                  title: Text(
                    item.label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  // 下方显示字段名（可选，方便开发调试，正式上线可以去掉）
                  subtitle: Text(
                    item.name,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),

                  // 开关状态
                  value: item.isVisible,

                  // 点击事件
                  onChanged: (bool newValue) {
                    _toggleItem(index, newValue);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

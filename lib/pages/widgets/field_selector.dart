import 'package:cloud/models/field_config.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FieldSelector extends StatefulWidget {
  final List<FieldConfig> fields; // 当前的配置
  final int? companyId;
  final List<FieldConfig> defaultFields; // 默认配置源
  final ValueChanged<List<FieldConfig>>? onConfigChanged;

  // 点击上传和下载的回调
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;

  final bool showActionButtons;

  const FieldSelector({
    super.key,
    required this.fields,
    this.companyId,
    required this.defaultFields,
    this.onConfigChanged,
    this.onUpload,
    this.onDownload,
    this.showActionButtons = false,
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

  void _initData() {
    _localFields = widget.fields.map((e) => e.copyWith()).toList();
  }

  void _resetToDefault() {
    setState(() {
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
    final primaryColor = theme.primaryColor;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
          if (widget.showActionButtons)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          final bool isConfirmed = await ConfirmDialog.show(
                            context,
                            content: '确定要将当前字段配置上传到该客户吗？这将盖该客户现有的字段设置。',
                          );
                          if (isConfirmed) {
                            if (widget.companyId == null) return;

                            await updateCrmCompany(
                              widget.companyId!,
                              {
                                'form_schema': widget.fields,
                              },
                            );
                            EasyLoading.showSuccess('上传成功');
                          }
                        },
                        icon: const Icon(Icons.upload, size: 16),
                        label: const Text(
                          '上传客户字段',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,
                          side: BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          final bool isConfirmed = await ConfirmDialog.show(
                            context,
                            content: '确定要将当前字段配置上传到该客户吗？这将盖该客户现有的字段设置。',
                          );
                          if (isConfirmed) {
                            if (widget.companyId == null) return;

                            final resp =
                                await showCrmCompany(widget.companyId!);

                            setState(() {
                              _localFields = (resp?.formSchema ?? [])
                                  .map((e) => FieldConfig.fromJson(e))
                                  .toList();
                            });
                            EasyLoading.showSuccess('同步成功');
                          }
                        },
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text(
                          '下载客户字段',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                                      WidgetStateProperty.resolveWith(
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
          Container(
            padding: EdgeInsets.fromLTRB(
                20, 10, 20, MediaQuery.of(context).padding.bottom + 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
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
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
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
                        EasyLoading.showSuccess('字段设置保存成功');
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

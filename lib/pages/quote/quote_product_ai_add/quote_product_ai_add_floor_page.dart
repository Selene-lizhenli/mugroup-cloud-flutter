import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/form_definitions.dart';
import 'package:cloud/models/field_config.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/supplier_select.dart';
import 'package:cloud/providers/field_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteProductAiAddFloorPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductAiAddFloorPage({super.key, this.quoteId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final supplierController = useTextEditingController();

    final selectedSupplierState = useState<Map<String, dynamic>?>(null);

    final imageList = useState<List<TemporaryMedia>?>(null);

    final configParams = useMemoized(() => FieldConfigParams(
          storageKey: 'quote_product_ai_add_v1',
          defaultFields: quoteAIFloorDefaultFields,
        ));

    final fieldConfigs = ref.watch(fieldConfigProvider(configParams));
    final notifier = ref.read(fieldConfigProvider(configParams).notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // appBar: AppBar(
      //   title: const Text(
      //     'AI自动录入产品',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 17,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ImageUploader(
                              value: imageList.value,
                              onChanged: (value) {
                                imageList.value = value;
                              },
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    color: const Color(0xFFEef6FF),
                    child: Row(
                      children: [
                        Icon(Icons.volume_up_outlined,
                            color: colorScheme.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '您正在使用AI录入功能，信息将会由自动识别录入!!!',
                            style: TextStyle(
                                color: colorScheme.primary, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E1),
                            border: const Border(
                              left: BorderSide(color: Colors.orange, width: 4),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '当前录入模式：地板/白板',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Text('*', style: TextStyle(color: Colors.red)),
                            Text('供应商',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: TextField(
                                  controller: supplierController,
                                  readOnly: true,
                                  onTap: () async {
                                    final Map<String, dynamic>? result =
                                        await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => const SupplierSelect(),
                                    );

                                    if (result != null) {
                                      supplierController.text =
                                          result['name'] ?? '';

                                      selectedSupplierState.value = result;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: '输入供应商名称搜索或添加',
                                    hintStyle: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                    prefixIcon: Icon(Icons.search,
                                        size: 20, color: Colors.grey),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                minimumSize: const Size(80, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              child: const Text('SKU设置',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (fieldConfigs.isNotEmpty)
                    InlineFieldSelector(
                      fields: fieldConfigs,
                      defaultFields: quoteAIFloorDefaultFields,
                      onConfigChanged: (newConfig) {
                        notifier.updateConfigs(newConfig);
                      },
                    )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                .copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                )
              ],
            ),
            child: SizedBox(
              height: 44, // 按钮高度
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 这里写保存逻辑
                  print('点击保存产品');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('保存产品'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InlineFieldSelector extends StatefulWidget {
  final List<FieldConfig> fields; // 当前的配置
  final int? companyId;
  final List<FieldConfig> defaultFields; // 默认配置源
  final ValueChanged<List<FieldConfig>>? onConfigChanged;
  final bool showActionButtons;

  const InlineFieldSelector({
    super.key,
    required this.fields,
    this.companyId,
    required this.defaultFields,
    this.onConfigChanged,
    this.showActionButtons = true, // 默认为true，方便操作
  });

  @override
  State<InlineFieldSelector> createState() => _InlineFieldSelectorState();
}

class _InlineFieldSelectorState extends State<InlineFieldSelector> {
  late List<FieldConfig> _localFields;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(covariant InlineFieldSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fields != widget.fields) {
      _initData();
    }
  }

  void _initData() {
    _localFields = widget.fields.map((e) => e.copyWith()).toList();
  }

  void _resetToDefault() {
    setState(() {
      _localFields = widget.defaultFields.map((e) => e.copyWith()).toList();
    });
    widget.onConfigChanged?.call(_localFields);
  }

  void _toggleItem(int index, bool value) {
    setState(() {
      final oldItem = _localFields[index];
      _localFields[index] = oldItem.copyWith(isVisible: value);
    });
    widget.onConfigChanged?.call(_localFields);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _localFields.removeAt(oldIndex);
      _localFields.insert(newIndex, item);
    });
    widget.onConfigChanged?.call(_localFields);
  }

  bool get _isAllVisible => _localFields.every((e) => e.isVisible);

  void _toggleAll() {
    final bool targetStatus = !_isAllVisible;
    setState(() {
      for (int i = 0; i < _localFields.length; i++) {
        _localFields[i] = _localFields[i].copyWith(isVisible: targetStatus);
      }
    });
    widget.onConfigChanged?.call(_localFields);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '选择识别字段',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Row(
                  children: [
                    Text(
                      '长按拖拽排序',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _toggleAll,
                      child: Text(
                        _isAllVisible ? '全部隐藏' : '全部显示',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                        onTap: _resetToDefault,
                        child: Text(
                          '重置',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor),
                        )),
                  ],
                ),
              ],
            ),
          ),
          Theme(
            data: theme.copyWith(
              canvasColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              itemCount: _localFields.length,
              proxyDecorator: (child, index, animation) {
                return Material(
                  elevation: 8,
                  color: Colors.transparent,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                  child: child,
                );
              },
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                final item = _localFields[index];
                return Container(
                  key: ValueKey(item.name),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFEEEEEE)), // 轻微边框
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => _toggleItem(index, !item.isVisible),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 0),
                        child: Row(
                          children: [
                            ReorderableDragStartListener(
                              index: index,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    right: 8, top: 8, bottom: 8),
                                color: Colors.transparent,
                                child: Icon(Icons.drag_indicator,
                                    color: Colors.grey[300], size: 18),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: item.isVisible
                                      ? Colors.black87
                                      : Colors.grey,
                                  decoration: item.isVisible
                                      ? null
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: item.isVisible,
                                activeColor: Colors.white,
                                activeTrackColor: theme.primaryColor,
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey[200],
                                trackOutlineColor:
                                    WidgetStateProperty.all(Colors.transparent),
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
        ],
      ),
    );
  }
}

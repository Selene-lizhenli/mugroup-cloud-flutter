import 'package:cloud/pages/widgets/select.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplierTypeSelect extends HookConsumerWidget {
  final String label;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? hintText;

  const SupplierTypeSelect({
    super.key,
    this.label = '',
    this.value,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final options = useState<List<SelectOption>?>(null);

    // 请求接口
    useEffect(() {
      Future<void> loadSupplierType() async {
        final resp = await getAllSupplySupplierTypes();
        if (resp != null) {
          options.value = resp.map((item) {
            return SelectOption(
              label: item.name ?? '',
              value: item.id.toString(),
            );
          }).toList();
        }
      }

      loadSupplierType();
      return null;
    }, []);

    final controller = useTextEditingController();

    useEffect(() {
      if (options.value != null && value != null) {
        final matched = options.value!.firstWhere(
          (o) => o.value == value,
          orElse: () => SelectOption(label: '', value: ''),
        );
        controller.text = matched.label;
      }
      return null;
    }, [options.value, value]);

    void showSelectSheet() {
      final list = options.value;
      if (list == null || list.isEmpty) return;
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, // 底部抽屉宽度占满屏幕
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('请选择$label',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, index) {
                      final option = list[index];
                      final isSelected = option.value == value;
                      return Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            onChanged?.call(option.value);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            child: Text(
                              option.label,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label,
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          readOnly: true,
          onTap: showSelectSheet,
          style:
              const TextStyle(fontSize: 14, color: Colors.black87, height: 1),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText ?? "请选择$label",
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 1.5)),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade600,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          ),
        ),
      ],
    );
  }
}

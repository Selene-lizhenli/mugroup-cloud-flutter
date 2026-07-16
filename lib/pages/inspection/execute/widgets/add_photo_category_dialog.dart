import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddPhotoCategoryDialog extends HookWidget {
  const AddPhotoCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Hook 自动管理控制器，无需 initState/dispose
    final nameController = useTextEditingController();
    // 状态管理
    final columns = useState(4);
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      backgroundColor: colorScheme.surface,
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.02,
        vertical: 12,
      ),
      child: SizedBox(
        width: double.maxFinite,
        height: 260,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: colorScheme.tertiary.withOpacity(0.65),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    color: Colors.amber[700],
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '增加验货图片类别',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(
                  width: 80,
                  child: Text(
                    '名称:',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 68, 68, 68)),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '请输入名称',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceTint.withOpacity(0.85),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            width: 0,
                            color: colorScheme.surfaceTint.withOpacity(0.85)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: colorScheme.surfaceTint.withOpacity(0.85),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(
                  width: 80,
                  child: Text(
                    '每行数量:',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromARGB(255, 68, 68, 68)),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceTint.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed:
                              columns.value > 1 ? () => columns.value-- : null,
                          icon: const Icon(Icons.remove),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${columns.value}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed:
                              columns.value < 6 ? () => columns.value++ : null,
                          icon: const Icon(Icons.add),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 90), 
                Icon(Icons.info_outline, size: 16, color: colorScheme.outline),
                SizedBox(
                  child: Text(
                    '《每行数量》用于生成验货报告时每行展示的图片数量',
                    style: TextStyle(fontSize: 11, color: colorScheme.outline),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: Colors.amber[700],
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: Colors.amber[900],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(30, 4, 30, 4),
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    backgroundColor: colorScheme.tertiary.withOpacity(0.65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    Navigator.of(context)
                        .pop((name: name, columns: columns.value));
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(
                      color: Colors.amber[900],
                    ),
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

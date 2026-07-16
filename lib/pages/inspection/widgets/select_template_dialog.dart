import 'package:cloud/pages/inspection/const.dart';
import 'package:cloud/pages/inspection/providers/inspection_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectTemplateDialog extends HookConsumerWidget {
  const SelectTemplateDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final templateKeys = ref.watch(
      inspectionDetailProvider.select((s) => s.templateKeys),
    );
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
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: colorScheme.primary.withOpacity(0.1),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_view_outlined,
                      color: Colors.amber[700],
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '请选择您要使用的验货模板',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 4, 16, 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.surface,
                              colorScheme.surfaceTint,
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          title: Row(
                            children: [
                              Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 32,
                                  height: 1,
                                  color: Colors.amber[700],
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                inspectionGroupBasicTemplate['name'] as String,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context, inspectionGroupBasicTemplate);
                          },
                        ),
                      ),
                      for (final template in templateKeys)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.surface,
                                colorScheme.surfaceTint,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.fromLTRB(16, 4, 16, 3),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            title: Row(
                              children: [
                                Text(
                                  '•',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.amber[700],
                                    height: 1,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  (template['name'] ?? '').toString(),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context, {
                                "name": template['name'],
                                "value": template['id'],
                              });
                            },
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/services/tenant.dart';
import 'package:flutter/material.dart';

enum ExportTemplateType {
  normal, // 出货清单
  encrypt, // 出货清单（含加密信息）
}

class EmployeePickerSheet extends StatefulWidget {
  final int? quoteId;
  const EmployeePickerSheet(this.quoteId);

  @override
  State<EmployeePickerSheet> createState() => _EmployeePickerSheetState();
}

class _EmployeePickerSheetState extends State<EmployeePickerSheet> {
  final TextEditingController _controller = TextEditingController();

  List<User> _list = [];
  User? _selected;
  bool _loading = false;
  bool _searched = false;
  ExportTemplateType _templateType = ExportTemplateType.normal;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final keyword = _controller.text.trim();

    if (keyword.isEmpty || _loading) return;

    setState(() {
      _loading = true;
      _searched = true;
      _list = [];
      _selected = null;
    });

    try {
      final result = await fetchCurrentUsers(queryParameters: {
        "search": keyword,
        "pageSize": 50,
      });

      if (!mounted) return;

      setState(() {
        _list = result ?? [];
      });
    } catch (e, s) {
      if (!mounted) return;

      debugPrint('搜索员工失败: $e\n$s');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('搜索失败，请稍后重试'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          children: [
            // ===== 顶部操作栏 =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '发送到企微',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_selected == null) {
                        return;
                      }
                      final params = {
                        "channel": "wework",
                        "template": _templateType == ExportTemplateType.encrypt
                            ? "chqd_secret"
                            : "chqd",
                        "user_id": _selected?.id,
                      };

                      params;

                      final result = await exportQuotationFile(
                        widget.quoteId ?? 0,
                        params,
                      );

                      if (!context.mounted) return;
                      if (result.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('导出成功，请到企微查看！'),
                            backgroundColor: Colors.green.shade600,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message ?? '导出失败'),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                        );
                      }

                      Navigator.pop(context);
                    },
                    child: const Text('确认'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),
            // ===== 模板选择（单选）=====
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '请选择模板',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _RadioItem(
                        title: '出货清单',
                        value: ExportTemplateType.normal,
                        groupValue: _templateType,
                        onChanged: (v) {
                          setState(() => _templateType = v);
                        },
                      ),
                      _RadioItem(
                        title: '出货清单（含加密信息）',
                        value: ExportTemplateType.encrypt,
                        groupValue: _templateType,
                        onChanged: (v) {
                          setState(() => _templateType = v);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            // ===== 搜索框 =====
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '请选择目标员工',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                enabled: !_loading, //   loading 时禁用
                decoration: InputDecoration(
                  hintText: '根据关键字搜索员工',
                  // prefixIcon: const Icon(Icons.search),
                  suffixIcon: _loading
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _search,
                        ),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
              ),
            ),

            // ===== 内容区 =====
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_searched) {
      return const Center(child: Text('请输入关键词搜索员工'));
    }

    if (_list.isEmpty) {
      return const Center(child: Text('未搜索到员工'));
    }

    return ListView.separated(
      itemCount: _list.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final emp = _list[index];
        final selected = _selected?.id == emp.id;

        return ListTile(
          title: Text(emp?.name ?? "-"),
          trailing: selected
              ? Icon(Icons.check, color: Theme.of(context).primaryColor)
              : null,
          onTap: () {
            setState(() {
              _selected = emp;
            });
          },
        );
      },
    );
  }
}

class _RadioItem extends StatelessWidget {
  final String title;
  final ExportTemplateType value;
  final ExportTemplateType groupValue;
  final ValueChanged<ExportTemplateType> onChanged;

  const _RadioItem({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Radio<ExportTemplateType>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

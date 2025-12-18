import 'dart:async';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CompanySelect extends HookConsumerWidget {
  final String label;
  final int? value;
  final ValueChanged<int?>? onChanged;

  const CompanySelect({
    super.key,
    this.label = '',
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final isLoading = useState(false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    useEffect(() {
      if (value == null) {
        controller.text = '';
        return null;
      }

      Future<void> loadCompany() async {
        try {
          isLoading.value = true;
          final company = await getCrmCompany(value!);
          controller.text = company?.name ?? '';
        } finally {
          isLoading.value = false;
        }
      }

      loadCompany();
      return null;
    }, [value]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          readOnly: true,
          style:
              const TextStyle(fontSize: 16, color: Colors.black87, height: 1),
          decoration: InputDecoration(
            isDense: true,
            hintText: "请输入$label",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // 更圆润的圆角
              borderSide:
                  BorderSide(color: Colors.grey.shade300), // 平时无边框(配合背景色)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 30,
              minWidth: 40,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon:
                        const Icon(Icons.cancel, color: Colors.grey, size: 20),
                    onPressed: () {
                      controller.clear();
                      onChanged?.call(null);
                    },
                  )
                : null,
          ),
          onTap: () async {
            final result = await showModalBottomSheet<Map<String, dynamic>>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _CompanySelectSheet(
                label: label,
                value: value,
              ),
            );

            if (result != null) {
              controller.text = result['name'] ?? '';
              onChanged?.call(result['id'] as int?);
            }
          },
        ),
      ],
    );
  }
}

class _CompanySelectSheet extends HookConsumerWidget {
  final String label;
  final int? value;

  const _CompanySelectSheet({
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double height = MediaQuery.of(context).size.height * 0.75;

    final searchController = useTextEditingController();
    useListenable(searchController);

    final search = useState<String?>(null);
    final companies = useState<List<Company>?>(null);
    final isLoading = useState<bool>(true);
    final debounceTimer = useRef<Timer?>(null);

    useEffect(() {
      Future<void> loadCompanies() async {
        try {
          isLoading.value = true;
          final resp = await getCrmCompanies(
            queryParameters: {"search": search.value},
          );
          companies.value = resp.data;
        } finally {
          isLoading.value = false;
        }
      }

      loadCompanies();
      return () => debounceTimer.value?.cancel();
    }, [search.value]);

    void onSearchChanged(String val) {
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
        search.value = val.isEmpty ? null : val;
      });
    }

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 顶部拖拽条
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // 标题
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // 搜索框
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: '搜索名称',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                prefixIcon:
                    const Icon(Icons.search, size: 18, color: Colors.grey),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel,
                            size: 16, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                          debounceTimer.value?.cancel();
                          search.value = null;
                        },
                      )
                    : null,
                isDense: true,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 列表
          Expanded(
            child: isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : (companies.value == null || companies.value!.isEmpty)
                    ? Center(
                        child: Text(
                          '暂无数据',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                      )
                    : ListView.separated(
                        itemCount: companies.value!.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final company = companies.value![index];
                          final isSelected = company.id == value;

                          return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.2),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(
                                      context,
                                      company.toJson(),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          company.name ?? '未知客户',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          company.address ?? '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

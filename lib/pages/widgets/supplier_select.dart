import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplierSelect extends HookConsumerWidget {
  const SupplierSelect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double height = MediaQuery.of(context).size.height * 0.75;
    final searchController = useTextEditingController();
    useListenable(searchController);
    final search = useState<String?>(null);
    final suppliers = useState<List<Supplier>?>(null);
    final isLoading = useState<bool>(true);

    final debounceTimer = useRef<Timer?>(null);

    // 2. 接口请求逻辑
    useEffect(() {
      Future<void> loadSuppliers() async {
        try {
          isLoading.value = true;
          final resp = await getSupplySuppliers(queryParameters: {
            "search": search.value,
          });
          suppliers.value = resp.data;
        } finally {
          isLoading.value = false;
        }
      }

      loadSuppliers();
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("选择供应商",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: '搜索名称或编号...',
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
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                      )
                    : null,
                prefixIconConstraints: const BoxConstraints(minWidth: 32),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading.value
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (suppliers.value == null || suppliers.value!.isEmpty)
                    ? Center(
                        child: Text("暂无数据",
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 13)))
                    : Expanded(
                        child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.6)),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    if (context.mounted) {
                                      context.router.push(
                                          const SupplySupplierCreateRoute());
                                      return;
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 18),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 24,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: ListView.separated(
                            padding: EdgeInsets.all(4),
                            itemCount: suppliers.value!.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 4),
                            itemBuilder: (context, index) {
                              final supplier = suppliers.value![index];

                              final supplierName = supplier.shortName ??
                                  supplier.name ??
                                  '未知供应商';

                              final supplierNo = supplier.supplierNo;

                              final address = supplier.address;

                              return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(supplier.toJson());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    supplierName,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  "$supplierNo",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    address ?? '',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[400],
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          )),
                        ],
                      )),
          ),
        ],
      ),
    );
  }
}

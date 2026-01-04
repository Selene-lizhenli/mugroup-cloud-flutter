import 'package:cloud/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/models/response.dart';
import 'package:cloud/models/sample/category.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/services/supply.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ProductDropdownMenu extends HookConsumerWidget {
  final List<FacetCount> facetCounts;
  final Map<String, dynamic> value;
  final void Function(Map<String, dynamic> query) onChange;

  const ProductDropdownMenu({
    super.key,
    required this.value,
    required this.facetCounts,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useState<Map<String, dynamic>>({});
    final supportFacet = {
      "supplier_ids": "供应商",
      "category_id": "产品分类",
      "trade_country": "贸易国别", 
    };
    final menuOptions = {
      "supplier_ids": (multiple: true, optionsColumns: 1),
      "category_id": (multiple: true, optionsColumns: 2),
      "trade_country": (multiple: false, optionsColumns: 2), 
    };
    final suppliers = useState(<Supplier>[]);
    final categories = useState(<Category>[]);
    final isMounted = useRef(true);

    useEffect(() {
      isMounted.value = true;
      return () {
        isMounted.value = false;
      };
    }, []);

    useEffect(() {
      query.value = value;
      return null;
    }, [value]);

    final fetchSuppliers = useCallback((List<String> ids) async {
      final resp = await getSupplySuppliers(queryParameters: {
        "ids": ids,
        "pageSize": ids.length,
      });

      // 只有在组件仍然 mounted 时才更新状态
      if (isMounted.value) {
        try {
          suppliers.value = resp.data;
        } catch (e) {
          // 如果 ValueNotifier 已被 dispose，忽略错误
        }
      }
    }, []);

    final fetchCategories = useCallback(() async {
      final resp = await getAllShowroomCategories();

      // 只有在组件仍然 mounted 时才更新状态
      if (isMounted.value) {
        try {
          categories.value = resp ?? [];
        } catch (e) {
          // 如果 ValueNotifier 已被 dispose，忽略错误
        }
      }
    }, []);

    useEffect(() {
      final ids = facetCounts
              .firstWhereOrNull(
                  (facetCount) => facetCount.fieldName == "supplier_ids")
              ?.counts
              .map((count) => count.value)
              .toList() ??
          [];

      if (ids.isEmpty) {
        return null;
      }

      fetchSuppliers(ids);

      return null;
    }, [fetchSuppliers, facetCounts]);

    useEffect(() {
      if (categories.value.isNotEmpty) {
        return null;
      }
      final categoryFacetCount = facetCounts.firstWhereOrNull(
          (facetCount) => facetCount.fieldName == "category_id");

      if (categoryFacetCount == null) {
        return null;
      }

      fetchCategories();

      return null;
    }, [fetchCategories, facetCounts]);

    final menus = <TDDropdownItem>[];
    logger.d(facetCounts);
    for (var facetCount in facetCounts) {
      final field = facetCount.fieldName;
      if (!supportFacet.containsKey(field)) {
        continue;
      }

      if (facetCount.counts.length <= 1) {
        continue;
      }

      TDDropdownItem? item;
      final option = menuOptions[field];
      final options = <TDDropdownItemOption>[];
      final selectValues = query.value[field];

      for (var count in facetCount.counts) {
        var label = count.value;
        var selected = false;
        if (selectValues is List) {
          selected = selectValues.contains(count.value);
        }
        if (field == "supplier_ids") {
          final supplier = suppliers.value
              .firstWhereOrNull((item) => item.id.toString() == count.value);
          if (supplier == null) {
            continue;
          }

          label = supplier.name ?? label;
        } else if (field == "category_id") {
          final category = categories.value
              .firstWhereOrNull((item) => item.id.toString() == count.value);

          label = category?.name ?? label;
        } 
    

        options.add(TDDropdownItemOption(
          label: label,
          value: count.value,
          selected: selected,
        ));
      }

      item = TDDropdownItem(
        label: supportFacet[field],
        multiple: option?.multiple,
        optionsColumns: option?.optionsColumns,
        options: options,
        onChange: (value) {
          query.value = {
            ...query.value,
            field: value,
          };
        },
        onConfirm: (value) {
          if (value is List && value.isEmpty) {
            query.value = {...query.value}..remove(field);
            return;
          }
          query.value = {
            ...query.value,
            field: value,
          };
        },
        onReset: () {
          query.value = {...query.value}..remove(field);
        },
      );

      menus.add(item);
    }

    // 在贸易国别后添加样品间筛选
    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final warehouses = home.warehouses;
    final currentSelectedWarehouse = home.currentSelectedWarehouse;

    if (warehouses.isNotEmpty) {
      // 找到贸易国别菜单的索引
      int tradeCountryIndex = -1;
      for (int i = 0; i < menus.length; i++) {
        if (menus[i].label == "贸易国别") {
          tradeCountryIndex = i;
          break;
        }
      }

      // 构建样品间选项
      final warehouseOptions = <TDDropdownItemOption>[];
      for (var warehouse in warehouses) {
        warehouseOptions.add(TDDropdownItemOption(
          label: warehouse.name ?? '-',
          value: warehouse.id.toString(),
          selected: currentSelectedWarehouse?.id == warehouse.id,
        ));
      }

      // 创建样品间菜单项
      final warehouseItem = TDDropdownItem(
        label: "样品间",
        multiple: false,
        optionsColumns: 2,
        options: warehouseOptions,
        onChange: (value) {
          // onChange 不需要处理，只在 onConfirm 时处理
        },
        onConfirm: (value) {
          final selectedWarehouse = warehouses.firstWhereOrNull(
            (w) => w.id.toString() == value.toString(),
          );
          homeNotifier.setCurrentSelectedWarehouse(selectedWarehouse);
          // 通知查询变更
          query.value = {...query.value};
          onChange(query.value);
        },
        onReset: () {
          homeNotifier.setCurrentSelectedWarehouse(null);
          query.value = {...query.value};
          onChange(query.value);
        },
      );

      // 在贸易国别后插入样品间菜单
      if (tradeCountryIndex >= 0) {
        menus.insert(tradeCountryIndex + 1, warehouseItem);
      } else {
        // 如果没找到贸易国别，就添加到末尾
        menus.add(warehouseItem);
      }
    }

    if (menus.isEmpty) return const SizedBox.shrink();

    return Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TDDropdownMenu(
              direction: TDDropdownMenuDirection.down,
              isScrollable: true,
              onMenuClosed: (index) {
                if (const DeepCollectionEquality().equals(query.value, value)) {
                  return;
                }
                onChange(query.value);
              },
              items: menus,
            ),
            // Text(query.value.toString()),
          ],
        ));
  }
}

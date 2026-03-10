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

const String warehousesIdField = "warehouse_id";

class ProductDropdownMenu extends HookConsumerWidget {
  final List<FacetCount> facetCounts;

  const ProductDropdownMenu({
    super.key,
    required this.facetCounts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final query = home.query;
    final homeNotifier = ref.read(homeProvider.notifier);
    final supportFacet = {
      "supplier_ids": "供应商",
      "category_id": "产品分类",
      "trade_country": "贸易国别",
      warehousesIdField: "样品间",
    };
    final menuOptions = {
      "supplier_ids": (multiple: true, optionsColumns: 1),
      "category_id": (multiple: true, optionsColumns: 2),
      "trade_country": (multiple: false, optionsColumns: 2),
      warehousesIdField: (multiple: false, optionsColumns: 2),
    };
    final suppliers = useState(<Supplier>[]);
    final categories = useState(<Category>[]);
    final isMounted = useRef(true);

    List<TDDropdownItem> handleWarehouseDropdown(menus) {
      final home = ref.watch(homeProvider);
      final homeNotifier = ref.read(homeProvider.notifier);
      final warehouses = home.warehouses;
      final currentSelectedWarehouse = home.currentSelectedWarehouse;
      final lable = supportFacet[warehousesIdField] ?? "";
      final option = menuOptions[warehousesIdField];

      if (warehouses.isNotEmpty) {
        // 构建样品间选项
        final warehouseOptions = <TDDropdownItemOption>[];
        for (var warehouse in warehouses) {
          if (warehouse.abandoned == true || warehouse.id == null) {
            continue;
          }
          warehouseOptions.add(TDDropdownItemOption(
            label: warehouse.name ?? '-',
            value: warehouse.id.toString(),
            selected: currentSelectedWarehouse?.id == warehouse.id,
          ));
        }

        // 创建样品间菜单项
        final warehouseItem = TDDropdownItem(
          label: lable,
          multiple: option?.multiple,
          optionsColumns: option?.optionsColumns,
          options: warehouseOptions,
          onChange: (value) {
            // 选中的样品间的数据放在provider中，不放在query中
            // 单选时，value  是数组，需要取第一个元素
            final selectedValue =
                value is List ? (value.isNotEmpty ? value.first : null) : value;
            if (selectedValue == null) {
              homeNotifier.setCurrentSelectedWarehouse(null);
              return;
            }

            final selectedWarehouse = warehouses.firstWhereOrNull(
              (w) => w.id.toString() == selectedValue.toString(),
            );
            homeNotifier.setCurrentSelectedWarehouse(selectedWarehouse);
          },
          onConfirm: (value) {},
          onReset: () {
            homeNotifier.setCurrentSelectedWarehouse(null);
          },
        );

        menus.add(warehouseItem);
      }
      return menus;
    }

    useEffect(() {
      isMounted.value = true;
      return () {
        isMounted.value = false;
      };
    }, []);

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
    //添加样品间筛选项
    handleWarehouseDropdown(menus);

    useEffect(() {
      if (categories.value.isEmpty) fetchCategories();
      return null;
    }, []);

    //添加供应商等筛选项
    for (var facetCount in facetCounts) {
      final field = facetCount.fieldName;
      if (!supportFacet.containsKey(field)) continue;

      final isCategory = field == "category_id";

      // 如果不是分类且数量少于等于1，则跳过
      if (!isCategory && facetCount.counts.length <= 1) {
        continue;
      }

      final option = menuOptions[field];
      final selectValues = query[field];

      final options =
          (isCategory ? categories.value : facetCount.counts).map((item) {
        final String val = isCategory
            ? (item as Category).id.toString()
            : (item as FacetCountCount).value;
        String label = isCategory ? (item as Category).name ?? val : val;

        if (field == "supplier_ids") {
          final supplier =
              suppliers.value.firstWhereOrNull((s) => s.id.toString() == val);
          label = supplier?.name ?? label;
        }

        return TDDropdownItemOption(
          label: label,
          value: val,
          selected: selectValues is List &&
              selectValues.map((e) => e.toString()).contains(val),
        );
      }).toList();

      menus.add(TDDropdownItem(
        label: supportFacet[field],
        multiple: option?.multiple,
        optionsColumns: option?.optionsColumns,
        options: options,
        onChange: (value) {
          if (option?.multiple == false) {
            final newQuery = Map<String, dynamic>.from(query);

            final val =
                (value is List && value.isNotEmpty) ? value.first : value;

            if (val == null || (val is List && val.isEmpty)) {
              newQuery.remove(field);
            } else {
              newQuery[field] = [val];
            }
            homeNotifier.setQuery(newQuery);
          }
        },
        onConfirm: (value) {
          final newQuery = Map<String, dynamic>.from(query);
          if (value == null || (value is List && value.isEmpty)) {
            newQuery.remove(field);
          } else {
            newQuery[field] = value;
          }
          homeNotifier.setQuery(newQuery);
        },
        onReset: () {
          final newQuery = Map<String, dynamic>.from(query);
          newQuery.remove(field);
          homeNotifier.setQuery(newQuery);
        },
      ));
    }

    if (menus.isEmpty) return const SizedBox.shrink();
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: TDDropdownMenu(
          direction: TDDropdownMenuDirection.down,
          isScrollable: true,
          onMenuClosed: (index) {
            // Query is now updated directly through callbacks, no need for additional onChange
          },
          items: menus,
        ),
      ),
    );
  }
}

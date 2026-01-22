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

const String warehousesIdField = "warehouse_id";

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
            // 单选时，value  是数组，需要取第一个元素
            final selectedValue =
                value is List ? (value.isNotEmpty ? value.first : null) : value;
            if (selectedValue == null ||
                selectedValue == '0' ||
                selectedValue == 0) {
              query.value = {...query.value}..remove(warehousesIdField);
              homeNotifier.setCurrentSelectedWarehouse(null);
              return;
            }

            final selectedWarehouse = warehouses.firstWhereOrNull(
              (w) => w.id.toString() == selectedValue.toString(),
            );
            homeNotifier.setCurrentSelectedWarehouse(selectedWarehouse);

            query.value = {...query.value, warehousesIdField: selectedValue};
          },
          onConfirm: (value) {},
          onReset: () {
            homeNotifier.setCurrentSelectedWarehouse(null);
            query.value = {...query.value}..remove(warehousesIdField);
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
    //添加样品间筛选项
    handleWarehouseDropdown(menus);
   //添加供应商等筛选项
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
            if (const DeepCollectionEquality().equals(query.value, value)) {
              return;
            }
            onChange(query.value);
          },
          items: menus,
        ),
      ),
    );
  }
}

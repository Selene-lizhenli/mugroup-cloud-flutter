import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SampleSubmitBar extends HookConsumerWidget {
  final Sample? sample;
  const SampleSubmitBar({super.key, this.sample});

  void _handleSupplierTap(BuildContext context) {
    final quotes = sample?.supplyQuotes ?? [];

    if (quotes.isEmpty) {
      EasyLoading.showError("暂无供应商信息");
      return;
    }

    final Map<int, Supplier> uniqueSuppliersMap = {};

    for (var quote in quotes) {
      final supplier = quote.supplier;
      if (supplier != null && supplier.id != null) {
        uniqueSuppliersMap[supplier.id!] = supplier;
      }
    }

    final uniqueSuppliers = uniqueSuppliersMap.values.toList();

    if (uniqueSuppliers.isEmpty) {
      EasyLoading.showError("未找到有效供应商");
    } else if (uniqueSuppliers.length == 1) {
      _navigateToSupplier(context, uniqueSuppliers.first);
    } else {
      _showSupplierSelectSheet(context, uniqueSuppliers);
    }
  }

  void _navigateToSupplier(BuildContext context, dynamic supplier) {
    if (context.mounted) {
      final supplierId = supplier?.id;
      if (supplierId == null) return;
      context.router.push(SupplySupplierDetailRoute(id: supplierId));
      return;
    }
  }

  void _showSupplierSelectSheet(
      BuildContext context, List<Supplier> suppliers) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),
                    const Text(
                      '请选择供应商',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 24,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: suppliers.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Color(0xFFEEEEEE),
                    ),
                    itemBuilder: (context, index) {
                      final supplier = suppliers[index];
                      return Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToSupplier(context, supplier);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: Text(
                              supplier.name ?? "未知供应商",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final cart = ref.read(cartProvider.notifier);
    final cartState = ref.watch(cartProvider);
    final user = ref.watch(userProvider).user;

    // 购物车数量逻辑
    final badgeCount = cartState.items.length.toString();
    final showBadge = cartState.items.isNotEmpty;

    return FlanActionBar(
      safeAreaInsetBottom: true,
      children: [
        FlanActionBarIcon(
          iconName: FlanIcons.shop_o,
          text: '供应商',
          onClick: () => _handleSupplierTap(context),
        ),
        FlanActionBarIcon(
          iconName: FlanIcons.cart_o,
          text: '选样车',
          badge: showBadge ? badgeCount : '',
          onClick: () {
            context.router.push(const CartRoute());
          },
        ),
        FlanActionBarButton(
          type: FlanButtonType.warning,
          text: '加入选样车',
          color: colorScheme.primary,
          onClick: () {
            final currentSample = sample;
            if (currentSample != null) {
              cart.addSample(currentSample, 1);
            }
          },
        ),
        if (user?.permissions?.contains('showroom.quotation.store') ?? false)
          FlanActionBarButton(
            type: FlanButtonType.danger,
            text: '编辑样品',
            color: colorScheme.secondary,
            onClick: () {
              if (sample?.id != null) {
                context.router.push(ShowroomSampleEditRoute(id: sample!.id!));
              }
            },
          ),
      ],
    );
  }
}

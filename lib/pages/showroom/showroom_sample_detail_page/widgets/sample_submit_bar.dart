import 'dart:async';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SampleSubmitBar extends HookConsumerWidget {
  final Sample? sample;
  const SampleSubmitBar({super.key, this.sample});

  void _handleSupplierTap(BuildContext context) {
    final quotes = sample?.supplyQuotes ?? [];

    if (quotes.isEmpty) {
      EasyLoading.showInfo("暂无供应商信息");
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

  Future<void> _playAddToCartAnimation(
      BuildContext context, GlobalKey startKey, GlobalKey endKey) async {
    final RenderBox? startRenderBox =
        startKey.currentContext?.findRenderObject() as RenderBox?;

    final RenderBox? endRenderBox =
        endKey.currentContext?.findRenderObject() as RenderBox?;

    if (startRenderBox == null || endRenderBox == null) return;

    final startOffset = startRenderBox.localToGlobal(
        Offset(startRenderBox.size.width / 2, startRenderBox.size.height / 2));

    final endOffset = endRenderBox.localToGlobal(
        Offset(endRenderBox.size.width / 2, endRenderBox.size.height / 2));

    OverlayEntry? overlayEntry;
    final completer = Completer<void>();

    const duration = Duration(milliseconds: 600);

    final path = Path();
    path.moveTo(startOffset.dx, startOffset.dy);

    final controlPointX = (startOffset.dx + endOffset.dx) / 2;
    final controlPointY = min(startOffset.dy, endOffset.dy) - 200.0; // 向上抛150像素
    path.quadraticBezierTo(
        controlPointX, controlPointY, endOffset.dx, endOffset.dy);

    // 计算路径上的点
    final pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) return;
    final pathMetric = pathMetrics.first;

    overlayEntry = OverlayEntry(
      builder: (ctx) {
        return HookBuilder(
          builder: (context) {
            final controller = useAnimationController(duration: duration);

            final animation =
                useAnimation(Tween(begin: 0.0, end: 1.0).animate(controller));

            useEffect(() {
              controller.forward().then((_) {
                overlayEntry?.remove();
                completer.complete();
              });
              return null;
            }, []);

            final currentPosition =
                pathMetric.getTangentForOffset(pathMetric.length * animation);

            if (currentPosition == null) return const SizedBox.shrink();

            return Positioned(
              top: currentPosition.position.dy - 10,
              left: currentPosition.position.dx - 10,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    await completer.future;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final cart = ref.read(cartProvider.notifier);
    final cartState = ref.watch(cartProvider);
    final user = ref.watch(userProvider).user;

    final cartIconKey = useMemoized(() => GlobalKey(), [sample?.id]);
    final updateButtonKey = useMemoized(() => GlobalKey(), [sample?.id]);

    // 购物车数量逻辑
    final badgeCount = cartState.items.length.toString();
    final showBadge = cartState.items.isNotEmpty;

    bool canEdit = false;
    final permissions = user?.permissions ?? [];
    final itemType = sample?.itemType;

    if (itemType == 'sample') {
      canEdit = permissions.contains('showroom.sample.update');
    } else if (itemType == 'market_product') {
      canEdit = permissions.contains('showroom.market_product.update');
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: true,
        top: false,
        child: FlanActionBar(
          children: [
            FlanActionBarIcon(
              iconName: FlanIcons.shop_o,
              text: '供应商',
              onClick: () => _handleSupplierTap(context),
            ),
            FlanActionBarIcon(
              key: cartIconKey,
              iconName: FlanIcons.cart_o,
              text: '选样车',
              badge: showBadge ? badgeCount : '',
              onClick: () {
                context.router.push(const CartRoute());
              },
            ),
            if (canEdit)
              FlanActionBarButton(
                type: FlanButtonType.danger,
                text: '编辑样品',
                color: colorScheme.secondary,
                onClick: () {
                  if (sample?.id != null) {
                    context.router
                        .push(ShowroomSampleEditRoute(id: sample!.id!));
                  }
                },
              ),
            FlanActionBarButton(
              key: updateButtonKey,
              type: FlanButtonType.warning,
              text: '加入选样车',
              color: colorScheme.primary,
              onClick: () async {
                final currentSample = sample;
                if (currentSample != null) {
                  await _playAddToCartAnimation(
                      context, updateButtonKey, cartIconKey);
                  cart.addSample(currentSample, 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

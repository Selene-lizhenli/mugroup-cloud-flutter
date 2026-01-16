import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_page.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_pad_add_page.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

@RoutePage()
class QuoteProductAddAdaptivePage extends HookConsumerWidget {
  final int? quoteId;
  final int? companyId;
  final QuotationList? quoteDetail;
  final int? initialMode;
  final String? supplierId; // 页面级参数：供应商 ID

  const QuoteProductAddAdaptivePage({
    super.key,
    this.quoteId,
    this.companyId,
    this.quoteDetail,
    this.initialMode,
    this.supplierId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final hasAppliedInitial = useRef(false);
    final currentMode = useState<int>(
        initialMode ?? (orientation == Orientation.portrait ? 0 : 1));
    final initialSupplier = useState<Map<String, dynamic>?>(null);
    // 页面加载后，如果有 supplierId，则请求供应商数据
    useEffect(() {
      if (supplierId == null) return null;

      Future<void> loadInitialSupplier() async {
        try {
          final resp = await getSupplier(int.parse(supplierId!));
          if (resp != null) {
            initialSupplier.value = resp.toJson();
          }
        } catch (e) {
          logger.e('加载供应商失败: $e');
        }
      }

      loadInitialSupplier();
      return null;
    }, [supplierId]);

    useEffect(() {
      if (initialMode != null && !hasAppliedInitial.value) {
        currentMode.value = initialMode!;
        hasAppliedInitial.value = true;
        return null;
      }

      currentMode.value = orientation == Orientation.portrait ? 0 : 1;
      return null;
    }, [orientation, initialMode]);

    // 使用 IndexedStack 保持两个widget的状态，避免切换时重建导致的hooks冲突
    // 两个widget各自有独立的formKey，通过provider同步数据
    return IndexedStack(
      index: currentMode.value,
      children: [
        QuoteProductAddPortraitView(
          key: const ValueKey('portrait'),
          quoteId: quoteId,
          companyId: quoteDetail?.company?.id,
          initialSupplier: initialSupplier.value,
          isActive: currentMode.value == 0,
        ),
        QuoteProductAddLandscapeView(
          key: const ValueKey('landscape'),
          quoteId: quoteId,
          companyId: companyId,
          initialSupplier: initialSupplier.value,
          isActive: currentMode.value == 1,
        ),
      ],
    );
  }
}

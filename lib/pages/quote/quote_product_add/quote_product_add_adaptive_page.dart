import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/exchange.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_page.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_pad_add_page.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';


/// 获取翻译目标语言
String _getTranslationLanguage(String? quoteLanguage, String? customerCountry) {
  if (quoteLanguage != null && quoteLanguage.isNotEmpty) {
    return quoteLanguage.toLowerCase();
  }
  final countryLanguage = mapCountryToLanguage(customerCountry);
  return countryLanguage?['value'] ?? 'en';
}

@RoutePage()
class QuoteProductAddAdaptivePage extends HookConsumerWidget {
  final int? initialMode;
  final int? quoteId;
  final String? supplierId;

  const QuoteProductAddAdaptivePage({
    super.key,
    this.initialMode,
    this.quoteId,
    this.supplierId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final hasAppliedInitial = useRef(false);

    // 默认模式：竖屏为0，横屏为1
    final currentMode = useState<int>(
        initialMode ?? (orientation == Orientation.portrait ? 0 : 1));

    final initialSupplier = useState<Map<String, dynamic>?>(null);
    final quoteDetailState = ref.watch(quoteDetailProvider);

    // === 修复点：使用 ?. 安全访问，防止 baseInfo 为 null 时崩溃 ===
    final baseInfo = quoteDetailState.baseInfo;
    final quoteLanguage = baseInfo?.language;
    final customerCountry = baseInfo?.company?.location;


    //先看quoteDetailState有没有报价单id 然后再看外面传进来的有没有
    final quoteIdDate = baseInfo?.id ?? quoteId;

    final companyId = baseInfo?.company?.id;

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

    // 监听方向变化或初始模式变化
    useEffect(() {
      if (initialMode != null && !hasAppliedInitial.value) {
        currentMode.value = initialMode!;
        hasAppliedInitial.value = true;
        return null;
      }
      currentMode.value = orientation == Orientation.portrait ? 0 : 1;
      return null;
    }, [orientation, initialMode]);

    // 计算翻译目标语言
    final translationLanguage =
        _getTranslationLanguage(quoteLanguage, customerCountry);

    return IndexedStack(
      index: currentMode.value,
      children: [
        QuoteProductAddPortraitView(
          key: const ValueKey('portrait'),
          quoteId: quoteIdDate,
          companyId: companyId,
          initialSupplier: initialSupplier.value,
          isActive: currentMode.value == 0,
          translationLanguage: translationLanguage,
        ),
        QuoteProductAddLandscapeView(
          key: const ValueKey('landscape'),
          quoteId: quoteIdDate,
          companyId: companyId,
          initialSupplier: initialSupplier.value,
          isActive: currentMode.value == 1,
          translationLanguage: translationLanguage,
        ),
      ],
    );
  }
}

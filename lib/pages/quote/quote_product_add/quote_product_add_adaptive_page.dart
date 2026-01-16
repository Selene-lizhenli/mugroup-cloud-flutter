import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_page.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_pad_add_page.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

/// 国家到语言的映射
/// 返回小写的语言代码（用于翻译 API）
String? _mapCountryToLanguage(String? country) {
  if (country == null || country.isEmpty) return null;

  // 国家名称到语言代码的映射（不区分大小写）
  final countryLower = country.toLowerCase();

  // 英语国家
  if (countryLower.contains('美国') ||
      countryLower.contains('united states') ||
      countryLower.contains('usa') ||
      countryLower.contains('uk') ||
      countryLower.contains('united kingdom') ||
      countryLower.contains('英国') ||
      countryLower.contains('canada') ||
      countryLower.contains('加拿大') ||
      countryLower.contains('australia') ||
      countryLower.contains('澳大利亚') ||
      countryLower.contains('new zealand') ||
      countryLower.contains('新西兰')) {
    return 'en';
  }

  // 日语国家
  if (countryLower.contains('japan') || countryLower.contains('日本')) {
    return 'ja';
  }

  // 西班牙语国家
  if (countryLower.contains('spain') ||
      countryLower.contains('西班牙') ||
      countryLower.contains('mexico') ||
      countryLower.contains('墨西哥') ||
      countryLower.contains('argentina') ||
      countryLower.contains('阿根廷') ||
      countryLower.contains('chile') ||
      countryLower.contains('智利') ||
      countryLower.contains('colombia') ||
      countryLower.contains('哥伦比亚') ||
      countryLower.contains('peru') ||
      countryLower.contains('秘鲁')) {
    return 'es';
  }

  // 葡萄牙语国家
  if (countryLower.contains('portugal') ||
      countryLower.contains('葡萄牙') ||
      countryLower.contains('brazil') ||
      countryLower.contains('巴西')) {
    return 'pt';
  }

  // 俄语国家
  if (countryLower.contains('russia') ||
      countryLower.contains('俄罗斯') ||
      countryLower.contains('russian')) {
    return 'ru';
  }

  // 法语国家
  if (countryLower.contains('france') ||
      countryLower.contains('法国') ||
      countryLower.contains('belgium') ||
      countryLower.contains('比利时') ||
      (countryLower.contains('switzerland') &&
          countryLower.contains('french')) ||
      (countryLower.contains('canada') && countryLower.contains('quebec'))) {
    return 'fr';
  }

  // 德语国家
  if (countryLower.contains('germany') ||
      countryLower.contains('德国') ||
      countryLower.contains('austria') ||
      countryLower.contains('奥地利') ||
      countryLower.contains('switzerland') ||
      countryLower.contains('瑞士')) {
    return 'de';
  }

  // 默认返回英语
  return 'en';
}

/// 获取翻译目标语言
/// 优先使用报价单语言，如果没有则根据客户国家映射
String _getTranslationLanguage(String? quoteLanguage, String? customerCountry) {
  // 优先使用报价单语言
  if (quoteLanguage != null && quoteLanguage.isNotEmpty) {
    // 将大写的语言代码转换为小写（如 'EN' -> 'en'）
    return quoteLanguage.toLowerCase();
  }

  // 如果没有报价单语言，则根据客户国家映射
  final countryLanguage = _mapCountryToLanguage(customerCountry);
  return countryLanguage ?? 'en'; // 默认使用英语
}

@RoutePage()
class QuoteProductAddAdaptivePage extends HookConsumerWidget { 
  final int? initialMode;
  final String? supplierId; // 页面级参数：供应商 ID

  const QuoteProductAddAdaptivePage({
    super.key, 
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
    final quoteDetailState = ref.watch(quoteDetailProvider);
    final quoteLanguage =
        quoteDetailState.baseInfo?.language; // 报价单语言代码（如 'EN', 'JA', 'ES' 等）
    final customerCountry =
        quoteDetailState.baseInfo!.company?.location; // 客户国家
    final quoteId = quoteDetailState.baseInfo?.id;
    final companyId =  quoteDetailState.baseInfo!.company?.id;

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

    // 计算翻译目标语言
    final translationLanguage =
        _getTranslationLanguage(quoteLanguage, customerCountry);

    // 使用 IndexedStack 保持两个widget的状态，避免切换时重建导致的hooks冲突
    // 两个widget各自有独立的formKey，通过provider同步数据
    return IndexedStack(
      index: currentMode.value,
      children: [
        QuoteProductAddPortraitView(
          key: const ValueKey('portrait'),
          quoteId: quoteId,
          companyId: companyId,
          initialSupplier: initialSupplier.value,
          isActive: currentMode.value == 0,
          translationLanguage: translationLanguage,
        ),
        QuoteProductAddLandscapeView(
          key: const ValueKey('landscape'),
          quoteId: quoteId,
          companyId: companyId,
          initialSupplier: initialSupplier.value,
          isActive: currentMode.value == 1,
          translationLanguage: translationLanguage,
        ),
      ],
    );
  }
}

 
import 'package:auto_route/auto_route.dart'; 
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_page.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_pad_add_page.dart'; 
import 'package:flutter/material.dart'; 
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; 

@RoutePage()
class QuoteProductAddAdaptivePage extends HookConsumerWidget {
  final int? quoteId;
  final int? initialMode;

  const QuoteProductAddAdaptivePage({
    super.key,
    this.quoteId,
    this.initialMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final hasAppliedInitial = useRef(false);
    final currentMode =
        useState<int>(initialMode ?? (orientation == Orientation.portrait ? 0 : 1));

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
          isActive: currentMode.value == 0,
        ),
        QuoteProductAddLandscapeView(
          key: const ValueKey('landscape'),
          quoteId: quoteId,
          isActive: currentMode.value == 1,
        ),
      ],
    );
  }
}
 


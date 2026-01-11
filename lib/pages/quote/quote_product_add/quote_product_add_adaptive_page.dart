import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_page.dart';
import 'package:cloud/pages/quote/quote_product_add/quote_product_pad_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 自适应报价产品添加页面 - 根据设备方向自动切换
@RoutePage()
class QuoteProductAddAdaptivePage extends HookConsumerWidget {
  final int? quoteId;
  final int? initialMode; // 0: 手机模式(竖屏), 1: 平板横屏
  
  const QuoteProductAddAdaptivePage({
    super.key,
    this.quoteId,
    this.initialMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 跟踪是否是第一次打开页面
    final isFirstBuild = useRef(true);
    // 当前显示的模式：0=竖屏，1=横屏
    final currentMode = useState<int?>(null);
    
    // 获取当前设备方向
    final orientation = MediaQuery.of(context).orientation;
    
    // 计算应该显示的模式
    int targetMode;
    
    // 第一次打开时，使用传入的 initialMode
    if (isFirstBuild.value) {
      if (initialMode != null) {
        // initialMode: 0=手机模式(竖屏), 1=平板横屏
        targetMode = initialMode!;
        currentMode.value = targetMode;
      } else {
        // 如果没有传入 initialMode，使用当前方向
        targetMode = orientation == Orientation.portrait ? 0 : 1;
        currentMode.value = targetMode;
      }
      isFirstBuild.value = false;
    } else {
      // 之后都使用监听的方向变化
      targetMode = orientation == Orientation.portrait ? 0 : 1;
      currentMode.value = targetMode;
    }
    
    // 使用 IndexedStack 保持两个组件的状态，但使用不同的 key 避免 GlobalKey 冲突
    return IndexedStack(
      index: targetMode,
      children: [
        // 竖屏显示手机版页面 - 使用唯一的 key
        QuoteProductAddPage(
          key: const ValueKey('portrait'),
          quoteId: quoteId,
        ),
        // 横屏显示平板版页面 - 使用唯一的 key
        QuoteProductPadAddPage(
          key: const ValueKey('landscape'),
          quoteId: quoteId,
        ),
      ],
    );
  }
}


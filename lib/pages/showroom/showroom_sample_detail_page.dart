import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:cloud/pages/home/widgets/product_card.dart';
import 'package:cloud/services/sample.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleDetailPage extends HookConsumerWidget {
  final int id;
  const ShowroomSampleDetailPage({super.key, @pathParam required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final colorScheme = Theme.of(context).colorScheme;
    final sample = useState<Sample?>(null);
    final currentIndex = useState<int>(0);
    final appBarOpacity = useState(1.0);
    final appElevatorOpacity = useState(0.0);
    final sampleSimilars = useState(<Sample>[]);
    final similarPage = useRef(1);

    final isLoading = useState<bool>(true);
    final hasMounted = useState(false);

    loadSample(int id) async {
      try {
        final data = await getSample(id);
        sample.value = data;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      calAppOpacity() {
        final offset = scrollController.offset;

        final newOpacity = (1 - offset / 200).clamp(0.0, 1.0);

        final eleVatorOpacity = ((offset - 200) / 200).clamp(0.0, 1.0);

        appBarOpacity.value = newOpacity;
        appElevatorOpacity.value = eleVatorOpacity;
      }

      scrollController.addListener(calAppOpacity);

      return () {
        scrollController.removeListener(calAppOpacity);
      };
    }, []);

    useEffect(() {
      // 等页面真正挂载后再加载数据
      Future.delayed(Duration.zero, () {
        hasMounted.value = true;
        loadSample(id);
      });
      return () {};
    }, [id]);

    if (!hasMounted.value || isLoading.value) {
      return Scaffold(
        body: Skeleton(
          isLoading: true,
          skeleton: SkeletonListView(),
          child: Container(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          EasyRefresh(
            onLoad: () async {
              final resp = await getSampleSimilars(
                id: id,
                queryParameters: {
                  "page": similarPage.value,
                },
              );

              sampleSimilars.value = [...sampleSimilars.value, ...resp.data];

              if (similarPage.value >= resp.meta!.pagination!.totalPages) {
                return IndicatorResult.noMore;
              }

              similarPage.value = similarPage.value + 1;

              return IndicatorResult.success;
            },
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // 图片轮播区域
                SliverToBoxAdapter(
                  child: (sample.value?.image != null &&
                          sample.value!.image!.isNotEmpty)
                      ? Stack(
                          children: [
                            CarouselSlider(
                              items: sample.value!.image!.indexed.map((item) {
                                final index = item.$1;
                                final media = item.$2;
                                return GestureDetector(
                                  onTap: () {
                                    showFlanImagePreview(
                                      context,
                                      images: sample.value!.image!
                                          .map((item) => item.url!)
                                          .toList(),
                                      startPosition: index,
                                      loop: false,
                                    );
                                  },
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double containerWidth =
                                          constraints.maxWidth;
                                      return ClipRRect(
                                        child: Image.network(
                                          media.url!,
                                          fit: BoxFit.contain,
                                          width: containerWidth,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                              options: CarouselOptions(
                                viewportFraction: 1.0,
                                aspectRatio: 1,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  currentIndex.value = index;
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 8.0,
                              right: 8.0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  '${currentIndex.value + 1} / ${sample.value!.image!.length}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Image.asset(
                          'assets/noImage.png',
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                ),

                // 产品编号和价格信息
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '¥${(double.tryParse(sample.value!.purchaseCost.toString()) ?? 0.0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '产品编号: ${sample.value!.productNo}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 产品名称区域
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6),
                    child: Text(
                      sample.value!.nameCn ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)), // 添加间隔
                // 其他信息区域
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '规格: ${sample.value!.spec}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '分类: ${sample.value!.category?.name ?? '未知'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '条形码: ${sample.value!.barcode ?? '未知'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '税率: ${sample.value!.taxRate?.toString() ?? '未知'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final quote = sample.value?.supplyQuotes?[index];
                      logger.d('wixi');
                      if (quote == null) {
                        return const SizedBox(); // 处理空的报价
                      }
                      return SupplyQuoteCard(quote: quote);
                    },
                    childCount: sample.value?.supplyQuotes?.length ?? 0,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            '为你推荐',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 瀑布流
                        MasonryGridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          itemCount: sampleSimilars.value.length,
                          padding: const EdgeInsets.all(4),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final sample = sampleSimilars.value[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade200, width: 1.5),
                                borderRadius: BorderRadius.circular(8), // 可选，圆角
                              ),
                              child: ProductCard(sample: sample),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Sample AppBar
          Positioned(
            top: 0,
            left: 10,
            right: 10,
            child: IgnorePointer(
              ignoring: appBarOpacity.value == 0,
              child: AnimatedOpacity(
                opacity: appBarOpacity.value,
                duration: const Duration(milliseconds: 100),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (Navigator.canPop(context))
                        Material(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 电梯
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: appElevatorOpacity.value < 1,
              child: AnimatedOpacity(
                opacity: appElevatorOpacity.value,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (Navigator.canPop(context))
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 15,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SupplyQuoteCard extends HookConsumerWidget {
  final Quote quote;

  final VoidCallback? onTap;

  const SupplyQuoteCard({
    super.key,
    required this.quote,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const orange600 = Color(0xFFEA580C);
    const orange100 = Color(0xFFFFEDD5);
    const slate50 = Color(0xFFF8FAFC);
    const slate100 = Color(0xFFF1F5F9);
    const slate200 = Color(0xFFE2E8F0);
    const slate400 = Color(0xFF94A3B8);
    const slate600 = Color(0xFF475569);
    const slate800 = Color(0xFF1E293B);

    // 价格处理逻辑
    final priceParts = (quote.purchaseCost ?? '0.00').split('.');
    final priceInt = priceParts[0];
    final priceDec = priceParts.length > 1 ? priceParts[1] : '00';
    final currencySymbol = quote.currency == 'USD' ? '\$' : '¥';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: slate200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 14, color: slate800, height: 1.4),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: orange100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '包装',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFFC2410C), // orange-700
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: quote.packing ?? "未填写包装详情",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: slate50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: slate100),
              ),
              child: Column(
                children: [
                  _buildSpecItem(
                    Icons.inventory_2_outlined, // Box
                    '装箱:',
                    quote.outerCapacity ?? '-',
                    slate400,
                    slate600,
                  ),
                  const SizedBox(height: 4),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 4),
                  _buildSpecItem(
                    Icons.check_box_outlined,
                    '体积:',
                    quote.outerVolume ?? '-',
                    slate400,
                    slate600,
                  ),
                  const SizedBox(height: 4),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 4),
                  // 交期
                  _buildSpecItem(
                    Icons.calendar_today_outlined,
                    '交期:',
                    quote.chuhuoAt != null
                        ? "${quote.chuhuoAt!.year}-${quote.chuhuoAt!.month}-${quote.chuhuoAt!.day}"
                        : '待定',
                    slate400,
                    slate600,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          currencySymbol,
                          style: const TextStyle(
                            fontSize: 12,
                            color: orange600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          priceInt,
                          style: const TextStyle(
                            fontSize: 24,
                            color: orange600,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          '.$priceDec',
                          style: const TextStyle(
                            fontSize: 14,
                            color: orange600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: slate100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '不含运费',
                            style: TextStyle(fontSize: 10, color: slate400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (quote.canBill ?? false)
                          _buildBottomTag(
                            label: '含税${quote.taxRate ?? ''}',
                            color: Colors.indigo,
                            bgColor: const Color(0xFFEEF2FF),
                            borderColor: const Color(0xFFC7D2FE),
                          )
                        else
                          _buildBottomTag(
                            label: '不含税',
                            color: Colors.grey,
                            bgColor: slate50,
                            borderColor: slate200,
                          ),
                      ],
                    )
                  ],
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 工厂名称
                    Text(
                      quote.supplier?.shortName ?? "未知工厂",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: slate600),
                    ),
                    const SizedBox(height: 2),
                    // 地址
                    Text(
                      "${quote.supplier?.province ?? ''} ${quote.supplier?.city ?? ''}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: slate400),
                    ),
                  ],
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value,
      Color labelColor, Color valueColor,
      {bool isFullWidth = false}) {
    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: labelColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: labelColor),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 12, color: valueColor, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomTag({
    required String label,
    IconData? icon,
    required Color color,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: TextStyle(
                fontSize: 10, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:cloud/pages/home/widgets/product_card.dart';
import 'package:cloud/pages/showroom/showroom_sample_detail_page/widgets/sample_app_bar.dart';
import 'package:cloud/pages/showroom/showroom_sample_detail_page/widgets/sample_submit_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flant/flant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
          Column(
            children: [
              Expanded(
                child: EasyRefresh.builder(
                  onRefresh: () async {
                    final data = await getSample(id);
                    sample.value = data;
                  },
                  scrollController: scrollController,
                  onLoad: () async {
                    final resp = await getSampleSimilars(
                      id: id,
                      queryParameters: {
                        "page": similarPage.value,
                      },
                    );

                    sampleSimilars.value = [
                      ...sampleSimilars.value,
                      ...resp.data
                    ];

                    if (similarPage.value >=
                        resp.meta!.pagination!.totalPages) {
                      return IndicatorResult.noMore;
                    }

                    similarPage.value = similarPage.value + 1;

                    return IndicatorResult.success;
                  },
                  childBuilder: (context, physics) {
                    return CustomScrollView(
                      physics: physics,
                      controller: scrollController,
                      slivers: [
                        // 图片轮播区域
                        SliverToBoxAdapter(
                          child: (sample.value?.image != null &&
                                  sample.value!.image!.isNotEmpty)
                              ? Stack(
                                  children: [
                                    CarouselSlider(
                                      items: sample.value!.image!.indexed
                                          .map((item) {
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
                                        scrollPhysics:
                                            const BouncingScrollPhysics(),
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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

                        MultiSliver(
                          children: [
                            // 产品编号和价格信息
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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

                            // 产品名称区域
                            Container(
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
                            const SizedBox(height: 12), // 添加间隔
                            // 其他信息区域
                            Container(
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
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 12)),
                            // 工厂报价
                            Container(
                              color: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 标题
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      '工厂报价',
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    itemCount:
                                        sample.value?.supplyQuotes?.length ?? 0,
                                    padding: const EdgeInsets.all(4),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final quote =
                                          sample.value?.supplyQuotes?[index];
                                      if (quote == null) {
                                        return const SizedBox.shrink();
                                      }

                                      return SupplyQuoteCard(quote: quote);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 相似产品
                            Container(
                              color: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      final availableWidth =
                                          constraints.maxWidth;

                                      var crossAxisCount = 2;

                                      if (availableWidth > 500) {
                                        crossAxisCount = 3;
                                      }

                                      if (availableWidth > 800) {
                                        crossAxisCount = 4;
                                      }

                                      return MasonryGridView.count(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                        itemCount: sampleSimilars.value.length,
                                        padding: const EdgeInsets.all(4),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final sample =
                                              sampleSimilars.value[index];
                                          return ProductCard(sample: sample);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              SampleSubmitBar(
                sample: sample.value,
              ),
            ],
          ),
          // Sample AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SampleAppBar(
              scrollController: scrollController,
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
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.mounted) {
                      final supplierId = quote.supplier?.id;
                      if (supplierId == null) return;
                      context.router
                          .push(SupplySupplierDetailRoute(id: supplierId));

                      return;
                    }
                  },
                  child: Text(
                    quote.supplier?.shortName ?? "未知工厂",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: slate800),
                  ),
                ),
                const SizedBox(height: 2),
                // 地址
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 12, color: slate400),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${quote.supplier?.province ?? ''} ${quote.supplier?.city ?? ''}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: slate400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
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
                    Icons.all_inbox_outlined,
                    '包装:',
                    quote.packing ?? '-',
                    slate400,
                    slate600,
                  ),
                  const SizedBox(height: 4),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 4),
                  _buildSpecItem(
                    Icons.inventory_2_outlined,
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
                    '出货日期:',
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
            const SizedBox(height: 6),
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
                        ),
                      ],
                    ),
                  ],
                ),
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
          style: TextStyle(fontSize: 10, color: labelColor),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 10, color: valueColor, fontWeight: FontWeight.w500),
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

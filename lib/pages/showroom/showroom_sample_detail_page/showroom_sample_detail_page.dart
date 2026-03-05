import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:cloud/pages/samples/widgets/product_card.dart';
import 'package:cloud/pages/showroom/showroom_sample_detail_page/type.dart';
import 'package:cloud/pages/showroom/showroom_sample_detail_page/widgets/sample_app_bar.dart';
import 'package:cloud/pages/showroom/showroom_sample_detail_page/widgets/sample_submit_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:collection/collection.dart';
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
    final elevatorFloors = useState(<ElevatorFloor>[]);

    final isLoading = useState<bool>(true);
    final hasMounted = useState(false);

    loadSample(int id) async {
      try {
        final data = await getSample(id);
        sample.value = data;
      } finally {
        isLoading.value = false;
      }

      elevatorFloors.value = [
        ElevatorFloor(id: 'detail', name: '详情', key: GlobalKey()),
        if (sample.value?.supplyQuotes?.isNotEmpty == true)
          ElevatorFloor(id: 'supplyQuote', name: '工厂报价', key: GlobalKey()),
        ElevatorFloor(id: 'similar', name: '推荐', key: GlobalKey()),
      ];
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
      return const Scaffold(
        body: SampleDetailSkeleton(),
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
                        MultiSliver(
                          children: [
                            // 图片轮播区域
                            LayoutBuilder(
                              key: elevatorFloors.value
                                  .firstWhereOrNull(
                                      (floor) => floor.id == "detail")
                                  ?.key,
                              builder: (context, constraints) {
                                var pageSize = 1;
                                final availableWidth = constraints.maxWidth;

                                if (availableWidth > 500) {
                                  pageSize = 2;
                                }
                                if (availableWidth > 800) {
                                  pageSize = 3;
                                }

                                return (sample.value?.image != null &&
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
                                                        .map(
                                                            (item) => item.url!)
                                                        .toList(),
                                                    startPosition: index,
                                                    loop: false,
                                                  );
                                                },
                                                child: LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    double containerWidth =
                                                        constraints.maxWidth;
                                                    return ClipRRect(
                                                      child: Image.network(
                                                        media.thumbOrUrl!,
                                                        fit: BoxFit.contain,
                                                        width: containerWidth,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            }).toList(),
                                            options: CarouselOptions(
                                              viewportFraction: 1 / pageSize,
                                              aspectRatio: pageSize / 1,
                                              enableInfiniteScroll: false,
                                              pageSnapping:
                                                  pageSize > 1 ? false : true,
                                              padEnds: false,
                                              onPageChanged: (index, reason) {
                                                logger.d([index, reason]);
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4.0),
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Text(
                                                '${currentIndex.value + 1}/${sample.value!.image!.length < pageSize ? 1 : sample.value!.image!.length - pageSize + 1}',
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
                                        'assets/icons/no_image.png',
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      );
                              },
                            ),
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
                                    '¥${(double.tryParse(sample.value?.purchaseCost?.toString() ?? '0.0') ?? 0.0).toStringAsFixed(2)}',
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
                                      '产品编号: ${sample.value?.productNo ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 产品名称 & 规格区域 (规格在市场模式下移到右边)
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 顶部对齐
                                children: [
                                  Expanded(
                                    child: Text(
                                      sample.value?.nameCn ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // 如果是 market_product 类型，显示规格在右边
                                  if (sample.value?.itemType ==
                                      'market_product') ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3),
                                      child: Text(
                                        sample.value!.spec ?? '未知',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (sample.value!.itemType != 'market_product')
                              const SizedBox(height: 12),

                            // 2. 其他信息区域 (非 market_product 类型才显示)
                            if (sample.value!.itemType != 'market_product')
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
                                      '规格: ${sample.value!.spec ?? "未知"}',
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
                            if (sample.value?.supplyQuotes?.isNotEmpty ?? false)
                              // 工厂报价
                              Container(
                                color: Colors.white,
                                key: elevatorFloors.value
                                    .firstWhereOrNull(
                                        (floor) => floor.id == "supplyQuote")
                                    ?.key,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 瀑布流
                                    MasonryGridView.count(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      itemCount:
                                          sample.value?.supplyQuotes?.length ??
                                              0,
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

                            // 相似产品
                            Container(
                              key: elevatorFloors.value
                                  .firstWhereOrNull(
                                      (floor) => floor.id == "similar")
                                  ?.key,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 标题
                                  Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: const Padding(
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
                                  ),

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
                                          return ProductCard(
                                            key: ValueKey(sample.id),
                                            sample: sample,
                                            onTap: () {
                                              context.router.push(
                                                ShowroomSampleDetailRoute(
                                                  id: sample.id!,
                                                ),
                                              );
                                            },
                                          );
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
              electorFloors: elevatorFloors.value,
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
    const slate800 = Color(0xFF1E293B);

    final province = quote.supplier?.province ?? '';
    final city = quote.supplier?.city ?? '';
    final hasLocation = province.isNotEmpty || city.isNotEmpty;

    final specItems = [
      if (quote.material != null)
        _buildRowItem(Icons.category_outlined, "材质", quote.material!),
      if (quote.packing != null)
        _buildRowItem(Icons.all_inbox_outlined, "包装", quote.packing!),
      if (quote.moq != null)
        _buildRowItem(Icons.shopping_cart_outlined, "MOQ", "${quote.moq}"),
      if (quote.outerCapacity != null)
        _buildRowItem(Icons.inventory_2_outlined, "装箱", quote.outerCapacity!),
      if (quote.outerVolume != null)
        _buildRowItem(Icons.straighten_outlined, "体积", quote.outerVolume!),
      if (quote.outerGrossWeight != null)
        _buildRowItem(Icons.scale_outlined, "毛重", quote.outerGrossWeight!),
      if (quote.shippingQty != null)
        _buildRowItem(
            Icons.local_shipping_outlined, "出货", "${quote.shippingQty}"),
      if (quote.sampleLocation != null)
        _buildRowItem(Icons.place_outlined, "样品位", quote.sampleLocation!),
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: slate200, width: 1),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final supplierId = quote.supplier?.id;
                      if (supplierId == null) return;
                      context.router
                          .push(SupplySupplierDetailRoute(id: supplierId));
                    },
                    child: Text(
                      (quote.supplier?.shortName ?? quote.supplier?.name) ??
                          "未知工厂",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: slate800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (quote.recordUser != null)
                  Text(quote.recordUser!,
                      style: const TextStyle(fontSize: 10, color: slate400)),
              ],
            ),
            if (hasLocation) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 10, color: slate400),
                  const SizedBox(width: 2),
                  Text("$province $city",
                      style: const TextStyle(fontSize: 11, color: slate400)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            if (quote.internalSku != null ||
                quote.supplierSku != null ||
                quote.customerSku != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (quote.internalSku != null)
                      _buildTag("内部:${quote.internalSku}", Colors.blue),
                    if (quote.supplierSku != null)
                      _buildTag("工厂:${quote.supplierSku}", Colors.teal),
                    if (quote.customerSku != null)
                      _buildTag("客户:${quote.customerSku}", Colors.purple),
                  ],
                ),
              ),
            if (specItems.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: slate50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: slate100),
                ),
                child: Column(
                  children: specItems
                      .expand((widget) => [widget, const SizedBox(height: 4)])
                      .toList()
                    ..removeLast(),
                ),
              ),
            const SizedBox(height: 10),
            if (quote.customerPrice != null || quote.supplierPrice != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    if (quote.customerPrice != null)
                      _buildSmallPrice("客户价:", quote.customerPrice!),
                    const SizedBox(width: 12),
                    if (quote.supplierPrice != null)
                      _buildSmallPrice("报价:", quote.supplierPrice!),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildMainPrice(quote, orange600),
                if (quote.chuhuoAt != null)
                  Text(
                    "交期:${quote.chuhuoAt!.month}/${quote.chuhuoAt!.day}",
                    style: const TextStyle(fontSize: 10, color: slate400),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 6),
        Text("$label:",
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSmallPrice(String label, String price) {
    return Text("$label ¥$price",
        style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)));
  }

  Widget _buildMainPrice(Quote quote, Color activeColor) {
    // 修复点 3: 极致安全的价格分割逻辑
    final rawPrice = quote.purchaseCost ?? '0.00';
    final parts = rawPrice.split('.');

    // 确保 parts 至少有一个元素，即使 rawPrice 为空字符串
    final String intPart =
        parts.isNotEmpty ? (parts[0].isEmpty ? '0' : parts[0]) : '0';
    final String decPart = parts.length > 1 ? parts[1] : '00';

    final currency = quote.currency == 'USD' ? '\$' : '¥';
    final isTax = quote.canBill ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(currency,
            style: TextStyle(
                fontSize: 14, color: activeColor, fontWeight: FontWeight.bold)),
        Text(intPart,
            style: TextStyle(
                fontSize: 22, color: activeColor, fontWeight: FontWeight.bold)),
        Text(".$decPart",
            style: TextStyle(
                fontSize: 14, color: activeColor, fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: isTax ? const Color(0xFFEEF2FF) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            isTax ? '含税${quote.taxRate ?? ''}' : '不含税',
            style: TextStyle(
                fontSize: 10,
                color: isTax ? Colors.indigo : const Color(0xFF64748B),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class SampleDetailSkeleton extends StatelessWidget {
  const SampleDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      isLoading: true,
      skeleton: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: double.infinity,
                    height: 280,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          width: 100,
                          height: 28,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SkeletonLine(
                        style: SkeletonLineStyle(
                          width: 120,
                          height: 28,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                  child: SkeletonParagraph(
                    style: const SkeletonParagraphStyle(
                      lines: 2,
                      spacing: 6,
                      lineStyle: SkeletonLineStyle(
                        height: 16,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 4,
                        spacing: 20,
                        padding: EdgeInsets.zero,
                        lineStyle: SkeletonLineStyle(
                          height: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SkeletonItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 120,
                            height: 20,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(2, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: 48,
                                height: 28,
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      child: Container(),
    );
  }
}

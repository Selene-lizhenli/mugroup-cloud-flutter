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

    loadSample(int id) async {
      final data = await getSample(id);
      sample.value = data;
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
      loadSample(id);
      return () {};
    }, [id]);

    if (sample.value == null) {
      return const Center(child: CircularProgressIndicator());
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
                if (sample.value?.image != null &&
                    sample.value!.image!.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Stack(
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
                                      .map((item) => media.url!)
                                      .toList(),
                                  startPosition: index,
                                  loop: false,
                                );
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double containerWidth = constraints.maxWidth;
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
                            viewportFraction: 1.0, // 图片占满屏幕
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
                          '产品编号: ${sample.value!.productNo}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          '¥${(double.tryParse(sample.value!.purchaseCost.toString()) ?? 0.0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ],
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

                // SampleSimilars
                SliverToBoxAdapter(
                  child: MasonryGridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    itemCount: sampleSimilars.value.length,
                    padding: const EdgeInsets.all(5),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final sample = sampleSimilars.value[index];

                      return ProductCard(
                        sample: sample,
                      );
                    },
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
  const SupplyQuoteCard({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 供应商名称
            if (quote.supplier?.name != null) ...[
              Text(
                '供应商: ${quote.supplier?.name}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                maxLines: 2, // 限制最多一行
                overflow: TextOverflow.ellipsis, // 超出一行时显示省略号
              ),
              const SizedBox(height: 8),
            ],

            // 包装
            if (quote.packing != null) ...[
              Text(
                '包装: ${quote.packing!}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 样品位置
            if (quote.sampleLocation != null) ...[
              Text(
                '样品位置: ${quote.sampleLocation!}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 税率
            if (quote.taxRate != null) ...[
              Text(
                '税率: ${quote.taxRate!}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // 采购成本
            if (quote.purchaseCost != null) ...[
              Text(
                '采购成本: ¥${quote.purchaseCost!}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleDetailPage extends HookConsumerWidget {
  final int id;
  const ShowroomSampleDetailPage({super.key, @pathParam required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sample = useState<Sample?>(null);
    final currentIndex = useState<int>(0);

    loadSample(int id) async {
      final data = await getSample(id);
      sample.value = data;
    }

    useEffect(() {
      loadSample(id);
      return () {};
    }, [id]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('样品详情'),
        backgroundColor: Colors.pink[300],
        elevation: 0,
      ),
      body: sample.value == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 图片轮播和产品信息（价格、编号）
                  if (sample.value?.image != null &&
                      sample.value!.image!.isNotEmpty)
                    Stack(
                      children: [
                        CarouselSlider(
                          items: sample.value!.image!.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    double containerWidth =
                                        constraints.maxWidth;
                                    double containerHeight =
                                        containerWidth * 9 / 16;

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        item.url!,
                                        fit: BoxFit
                                            .cover, // 使用 BoxFit.cover 保证图片不会失真
                                        width: containerWidth,
                                        height: containerHeight,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            viewportFraction: 1.0,
                            height: 300.0,
                            onPageChanged: (index, reason) {
                              currentIndex.value = index;
                            },
                          ),
                        ),
                        // 右下角的图片索引
                        Positioned(
                          bottom: 8.0,
                          right: 8.0,
                          child: Text(
                            '${currentIndex.value + 1} / ${sample.value!.image!.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              backgroundColor: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),

                  // 产品名称
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      sample.value!.nameCn ?? '', // 产品中文名称
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // 产品编号和价格信息
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
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
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red, // 使用红色突出价格
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 其他信息
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 规格
                        Text(
                          '规格: ${sample.value!.spec}',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        // 分类
                        Text(
                          '分类: ${sample.value!.category?.name ?? '未知'}',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        // 条形码
                        Text(
                          '条形码: ${sample.value!.barcode ?? '未知'}',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        // 税率
                        Text(
                          '税率: ${sample.value!.taxRate?.toString() ?? '未知'}',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // 增加底部间距
                ],
              ),
            ),
    );
  }
}

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 模拟数据模型
class _MockRowData {
  final List<String> columns;

  _MockRowData(this.columns);
}

@RoutePage()
class QuoteProductAiAddFloorPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductAiAddFloorPage({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // 图片状态
    final imageList = useState<List<TemporaryMedia>?>(null);

    // AI 分析状态
    final isAnalyzing = useState(false);
    final resultList = useState<List<_MockRowData>>([]);

    // 监听上传动作
    useEffect(() {
      if (imageList.value != null && imageList.value!.isNotEmpty) {
        isAnalyzing.value = true;
        resultList.value = [];

        // 模拟1秒后出结果
        final timer = Timer(const Duration(seconds: 1), () {
          isAnalyzing.value = false;

          resultList.value = List.generate(imageList.value!.length, (index) {
            return _MockRowData(
                ["A9321-AC26008", "￥1.6", "0.22", "1200 cards", "pvp 0.99"]);
          });
        });
        return timer.cancel;
      } else {
        resultList.value = [];
        isAnalyzing.value = false;
      }
      return null;
    }, [imageList.value]);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageUploader(
                                  value: imageList.value,
                                  onChanged: (value) {
                                    imageList.value = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    color: const Color(0xFFEef6FF),
                    child: Row(
                      children: [
                        Icon(Icons.volume_up_outlined,
                            color: colorScheme.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '您正在使用AI录入功能，信息将会由自动识别录入!!!',
                            style: TextStyle(
                                color: colorScheme.primary, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isAnalyzing.value)
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 10),
                          Text("正在识别中...",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12))
                        ],
                      ),
                    ),
                  if (!isAnalyzing.value && resultList.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: resultList.value.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = resultList.value[index];

                          return Container(
                            height: 70,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  )
                                ]),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: imageList.value != null &&
                                            imageList.value!.isNotEmpty
                                        ? Image.network(
                                            imageList.value![index].url,
                                            fit: BoxFit.cover)
                                        : const Icon(Icons.image,
                                            color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: item.columns
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int idx = entry.key;
                                        String text = entry.value;
                                        bool isLast =
                                            idx == item.columns.length - 1;

                                        return Row(
                                          children: [
                                            _buildDataText(text),
                                            if (!isLast)
                                              Container(
                                                width: 1,
                                                height: 24,
                                                color: Colors.grey[400],
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                              ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
    );
  }
}

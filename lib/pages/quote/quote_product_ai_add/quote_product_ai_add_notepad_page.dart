import 'dart:async';
import 'dart:math'; // 用于随机生成行数

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 1. 单行产品数据 (一行表格)
class _ProductItem {
  final List<String> columns;
  _ProductItem(this.columns);
}

// 2. 图片记录 (一图 -> 多行产品)
class _ImageRecord {
  final TemporaryMedia? media; // 图片源
  final List<_ProductItem> products; // 识别出的多行产品
  bool isExpanded; // 是否展开

  _ImageRecord({
    required this.media,
    required this.products,
    this.isExpanded = true, // 默认展开
  });
}

@RoutePage()
class QuoteProductAiAddNotepadPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductAiAddNotepadPage({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // 图片上传状态
    final imageList = useState<List<TemporaryMedia>?>(null);

    // AI 分析结果状态 (存放 _ImageRecord 列表)
    final isAnalyzing = useState(false);
    final recordList = useState<List<_ImageRecord>>([]);

    // 监听图片变化，生成模拟数据
    useEffect(() {
      if (imageList.value != null && imageList.value!.isNotEmpty) {
        // 简单防抖/避免重复触发逻辑：如果记录数量和图片数量不一致，或者为空，则触发识别
        if (recordList.value.isEmpty ||
            recordList.value.length != imageList.value!.length) {
          isAnalyzing.value = true;
          // 模拟延迟
          final timer = Timer(const Duration(milliseconds: 1000), () {
            isAnalyzing.value = false;
            // 为每一张上传的图片，生成一个 Record
            recordList.value =
                List.generate(imageList.value!.length, (imgIndex) {
              final media = imageList.value![imgIndex];
              // 模拟：随机生成 1 到 5 行产品数据
              final int productCount = Random().nextInt(5) + 1;
              final products = List.generate(productCount, (prodIndex) {
                return _ProductItem([
                  "${9.5 + prodIndex}", // 规格
                  "${20 + prodIndex * 2}", // 尺寸
                  "${10 * (prodIndex + 1)}pcs", // 数量
                  "第${imgIndex + 1}张图", // 来源
                  "备注-$prodIndex", // 备注
                ]);
              });
              return _ImageRecord(media: media, products: products);
            });
          });
          return timer.cancel;
        }
      } else {
        recordList.value = [];
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
                                  offset: const Offset(0, 2))
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
                                  onChanged: (value) => imageList.value = value,
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
                            'AI自动识别中，双击下方表格文字可进行修改。',
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
                          const MuProgressIndicator(),
                          const SizedBox(height: 10),
                          Text("AI正在分析多张单据...",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12))
                        ],
                      ),
                    ),
                  if (!isAnalyzing.value && recordList.value.isNotEmpty)
                    ListView.separated(
                      padding: const EdgeInsets.all(10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: recordList.value.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final record = recordList.value[index];
                        return _buildRecordCard(context, record, index, () {
                          record.isExpanded = !record.isExpanded;
                          recordList.value = [...recordList.value];
                        }, recordList);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(
      BuildContext context,
      _ImageRecord record,
      int index,
      VoidCallback onToggle,
      ValueNotifier<List<_ImageRecord>> recordListState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[50],
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showFlanImagePreview(
                        context,
                        images: [record.media!.url],
                        startPosition: index,
                        loop: false,
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                        image: record.media != null
                            ? DecorationImage(
                                image: NetworkImage(record.media!.url),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: record.media == null
                          ? const Icon(Icons.image,
                              size: 20, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "图片 ${index + 1}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          "识别出 ${record.products.length} 项产品",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    record.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (record.isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: record.products.asMap().entries.map((entry) {
                  final int pIndex = entry.key; // 行索引
                  final _ProductItem product = entry.value;
                  final bool isLastRow = pIndex == record.products.length - 1;

                  return Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children:
                              product.columns.asMap().entries.map((colEntry) {
                            final int cIndex = colEntry.key; // 列索引
                            final String text = colEntry.value;
                            final bool isLastCol =
                                cIndex == product.columns.length - 1;

                            return Row(
                              children: [
                                // 3. 核心：双击编辑逻辑
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque, // 增大点击判定范围
                                  onDoubleTap: () {
                                    // 调用公共弹窗组件
                                    EditDialog.show(
                                      context,
                                      initialText: text,
                                      onConfirm: (newText) {
                                        // 修改数据
                                        product.columns[cIndex] = newText;
                                        // 刷新 UI
                                        recordListState.value = [
                                          ...recordListState.value
                                        ];
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 4.0),
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black87),
                                    ),
                                  ),
                                ),

                                if (!isLastCol)
                                  Container(
                                    width: 1,
                                    height: 14,
                                    color: Colors.grey[300],
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      if (!isLastRow)
                        const Divider(
                            height: 1,
                            thickness: 0.5,
                            indent: 16,
                            endIndent: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart'; // 假设包含 logger
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/quote/quote_product_ai_add/widgets/edit_dialog.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/services/openai.dart';
import 'package:flant/components/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColumnConfig {
  final String key;
  final String label;
  final double width;

  const ColumnConfig(this.key, this.label, {this.width = 80.0});
}

const List<ColumnConfig> _kTableColumns = [
  ColumnConfig('price', '供应商报价', width: 80),
  ColumnConfig('out_carton', '外装箱量', width: 80),
  ColumnConfig('inner_pack', '内装箱量', width: 60),
  ColumnConfig('size', '尺寸', width: 80),
  ColumnConfig('weight', '重量(克)', width: 60),
  ColumnConfig('packaging_type', '包装方式', width: 70),
  ColumnConfig('unit', '单位', width: 50),
  ColumnConfig('volume', '体积', width: 60),
  ColumnConfig('moq', '起订量', width: 70),
  ColumnConfig('capacity', '容量', width: 60),
  ColumnConfig('description', '描述', width: 80),
];

class _MockRowData {
  final Map<String, String> data;

  _MockRowData(this.data);

  @override
  String toString() {
    return data.toString();
  }
}

@RoutePage()
class QuoteProductAiAddFloorPage extends HookConsumerWidget {
  final int? quoteId;

  const QuoteProductAiAddFloorPage({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(userProvider).user;

    final imageList = useState<List<TemporaryMedia>?>(null);
    final isAnalyzing = useState(false);
    final resultList = useState<List<_MockRowData>>([]);

    Future<_MockRowData?> recognizeOcr(String imageUrl) async {
      try {
        final result = await identifyOcr({
          "department": user?.department?.name,
          "employee_name": user?.name,
          "employee_number": user?.jobNumber,
          "image": imageUrl,
        });

        logger.d('OCR Result: $result');

        Map<String, String> rowMap = {};

        if (result != null && result['success'] == true) {
          final dataList = result['data'];
          if (dataList is List && dataList.isNotEmpty) {
            final item = dataList.first;

            for (var col in _kTableColumns) {
              String rawVal = (item[col.key] ?? '').toString().trim();

              rowMap[col.key] = rawVal.isEmpty ? '-' : rawVal;
            }
            return _MockRowData(rowMap);
          }
        }

        for (var col in _kTableColumns) {
          rowMap[col.key] = '-';
        }

        rowMap['price'] = '未识别';
        return _MockRowData(rowMap);
      } catch (e) {
        logger.e('OCR Error: $e');

        Map<String, String> errorMap = {};
        for (var col in _kTableColumns) errorMap[col.key] = '-';
        errorMap['price'] = '识别错误';
        return _MockRowData(errorMap);
      }
    }

    useEffect(() {
      final images = imageList.value;

      if (images == null || images.isEmpty) {
        resultList.value = [];
        isAnalyzing.value = false;
        return null;
      }

      if (resultList.value.length != images.length) {
        Future<void> processImages() async {
          if (images.length < resultList.value.length) {
            resultList.value = resultList.value.sublist(0, images.length);
            return;
          }

          isAnalyzing.value = true;
          List<_MockRowData> tempResults = List.from(resultList.value);

          for (int i = resultList.value.length; i < images.length; i++) {
            final data = await recognizeOcr(images[i].url);
            if (data != null) {
              tempResults.add(data);
            }
          }

          if (context.mounted) {
            resultList.value = tempResults;
            isAnalyzing.value = false;
          }
        }

        processImages();
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
                  // 图片上传区域
                  _buildUploadArea(imageList),

                  // 提示栏
                  _buildInfoBar(colorScheme),

                  // Loading 状态
                  if (isAnalyzing.value)
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: const Center(child: CircularProgressIndicator()),
                    ),

                  // --- 3. 列表区域 ---
                  if (!isAnalyzing.value && resultList.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          _buildTableHeader(),
                          const SizedBox(height: 8),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: resultList.value.length,
                            separatorBuilder: (c, i) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return _buildDataRow(
                                context,
                                index,
                                resultList.value[index],
                                imageList.value![index].url,
                                (newData) {
                                  // 更新状态
                                  final newList =
                                      List<_MockRowData>.from(resultList.value);
                                  newList[index] = newData;
                                  resultList.value = newList;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          _buildBottomAction(
            context,
            colorScheme,
            resultList.value,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadArea(ValueNotifier<List<TemporaryMedia>?> imageList) {
    return Row(
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
                    onChanged: (value) => imageList.value = value,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBar(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: const Color(0xFFEef6FF),
      child: Row(
        children: [
          Icon(Icons.volume_up_outlined, color: colorScheme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'AI自动识别中，双击表格文字可进行修改!!!',
              style: TextStyle(color: colorScheme.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          const SizedBox(
            width: 70 + 16,
            child: Text(
              ' 图片预览',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: _kTableColumns.map((col) {
                  return Container(
                    width: col.width,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      col.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, int index, _MockRowData item,
      String imageUrl, Function(_MockRowData) onUpdate) {
    return Container(
      height: 80,
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
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showFlanImagePreview(
                context,
                images: [imageUrl],
                loop: false,
              );
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: _kTableColumns.map((col) {
                  final text = item.data[col.key] ?? '-';

                  return Container(
                    width: col.width,
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onDoubleTap: () {
                          EditDialog.show(
                            context,
                            initialText: text == '-' ? '' : text,
                            onConfirm: (newText) {
                              final newData =
                                  Map<String, String>.from(item.data);
                              newData[col.key] =
                                  newText.isEmpty ? '-' : newText;
                              onUpdate(_MockRowData(newData));
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: text == '-'
                                      ? Colors.grey[400]
                                      : Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(
      BuildContext context, ColorScheme colorScheme, List<_MockRowData> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          .copyWith(bottom: MediaQuery.of(context).padding.bottom + 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
        ],
      ),
      child: SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            logger.d("准备保存的数据条数: $data");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('保存产品'),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kSkuSettingsKey = 'sku_settings_pref_v1';

class SkuSettingsDialog extends HookWidget {
  final List<dynamic>? currentImages;
  final Function(String sku, bool syncSupplier, bool syncCustomer) onConfirm;

  const SkuSettingsDialog({
    super.key,
    this.currentImages,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isAutoFill = useState(true);
    final generationType = useState(0);
    final customPrefixController = useTextEditingController(text: 'ABC');
    final syncSupplier = useState(true);
    final syncCustomer = useState(true);

    final previewText = useState('');
    final isLoading = useState(true);

    String generateRandomSku() {
      final now = DateTime.now();
      final dateStr = DateFormat('yyMMdd').format(now);
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      final rnd = Random();
      final randomStr = String.fromCharCodes(Iterable.generate(
          4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
      return "$dateStr$randomStr";
    }

    String generateImageSku() {
      if (currentImages == null || currentImages!.isEmpty) {
        return "MU${DateFormat('MMddHHmm').format(DateTime.now())}";
      }
      dynamic firstImg = currentImages!.first;
      String filename = "";
      try {
        if (firstImg is String) {
          filename = firstImg.split('/').last;
        } else if (firstImg is Map) {
          filename = firstImg['url'] ?? firstImg['path'] ?? '';
          filename = filename.split('/').last;
        } else {
          filename = firstImg.toString();
        }
        if (filename.contains('.')) {
          filename = filename.substring(0, filename.lastIndexOf('.'));
        }
        if (filename.length > 15) {
          filename = filename.substring(0, 15);
        }
        return filename.toUpperCase();
      } catch (e) {
        return "ERR${DateFormat('HHmmss').format(DateTime.now())}";
      }
    }

    String generateCustomSku() {
      final prefix = customPrefixController.text;
      final mockSerial = Random().nextInt(9999).toString().padLeft(4, '0');
      return "$prefix$mockSerial";
    }

    String calculateSku() {
      if (!isAutoFill.value) return "";
      switch (generationType.value) {
        case 0:
          return generateRandomSku();
        case 1:
          return generateImageSku();
        case 2:
          return generateCustomSku();
        default:
          return "";
      }
    }

    useEffect(() {
      SharedPreferences.getInstance().then((prefs) {
        final jsonStr = prefs.getString(kSkuSettingsKey);
        if (jsonStr != null) {
          try {
            final data = jsonDecode(jsonStr);
            isAutoFill.value = data['isAutoFill'] ?? true;
            generationType.value = data['generationType'] ?? 0;
            customPrefixController.text = data['customPrefix'] ?? 'ABC';
            syncSupplier.value = data['syncSupplier'] ?? true;
            syncCustomer.value = data['syncCustomer'] ?? true;
          } catch (e) {
            debugPrint("读取SKU配置失败: $e");
          }
        }
        isLoading.value = false;
      });
      return null;
    }, []);

    useEffect(() {
      if (!isLoading.value) {
        previewText.value = calculateSku();
      }
      return null;
    }, [generationType.value, isAutoFill.value, isLoading.value]);

    useEffect(() {
      void listener() {
        if (generationType.value == 2) {
          previewText.value = generateCustomSku();
        }
      }

      customPrefixController.addListener(listener);
      return () => customPrefixController.removeListener(listener);
    }, [customPrefixController]);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Container(
        width: 380,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SKU设置',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.grey),
                )
              ],
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('自动填充SKU',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            Text('启用后将自动生成SKU编码填充到表单',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        Switch(
                          value: isAutoFill.value,
                          onChanged: (v) => isAutoFill.value = v,
                          activeColor: Colors.white,
                          activeTrackColor: colorScheme.primary,
                        )
                      ],
                    ),
                    if (isAutoFill.value) ...[
                      const Divider(height: 30),
                      const Text('选择生成方式',
                          style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 10),
                      _buildOption(context, 0, '随机货号', '格式：YYMMDD+4位随机字母',
                          generationType),
                      const SizedBox(height: 8),
                      _buildOption(
                          context, 1, '首张图片名', '使用上传图片的文件名', generationType),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => generationType.value = 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(
                                color: generationType.value == 2
                                    ? colorScheme.primary
                                    : Colors.transparent,
                                width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Radio<int>(
                                    value: 2,
                                    groupValue: generationType.value,
                                    onChanged: (v) => generationType.value = v!,
                                    activeColor: colorScheme.primary,
                                  ),
                                  const Text('自定义前缀',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              if (generationType.value == 2)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 46, right: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '格式：自定义 + 4位随机数字',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: TextField(
                                          controller: customPrefixController,
                                          style: const TextStyle(fontSize: 14),
                                          decoration: InputDecoration(
                                            hintText: '例如: ABC',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 13),
                                            isDense: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 12),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]!),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                  color: colorScheme.primary,
                                                  width: 1.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                  isLoading.value
                                      ? '加载配置中...'
                                      : 'SKU预览: ${previewText.value}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                            ),
                            InkWell(
                              onTap: () => previewText.value = calculateSku(),
                              child: Icon(Icons.refresh,
                                  size: 18, color: colorScheme.primary),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text('同步应用到',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          _buildCheckbox('供应商货号', syncSupplier),
                          const SizedBox(width: 20),
                          _buildCheckbox('客户货号', syncCustomer),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final saveData = {
                  'isAutoFill': isAutoFill.value,
                  'generationType': generationType.value,
                  'customPrefix': customPrefixController.text,
                  'syncSupplier': syncSupplier.value,
                  'syncCustomer': syncCustomer.value,
                };
                await prefs.setString(kSkuSettingsKey, jsonEncode(saveData));

                onConfirm(
                    previewText.value, syncSupplier.value, syncCustomer.value);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('确定', style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index, String title, String sub,
      ValueNotifier<int> type) {
    final isSelected = type.value == index;
    return GestureDetector(
      onTap: () => type.value = index,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: RadioListTile<int>(
          value: index,
          groupValue: type.value,
          onChanged: (v) => type.value = v!,
          title: Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          subtitle: Text(sub,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, ValueNotifier<bool> val) {
    return Row(
      children: [
        Checkbox(
          value: val.value,
          onChanged: (v) => val.value = v!,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

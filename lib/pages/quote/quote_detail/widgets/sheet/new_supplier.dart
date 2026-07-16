import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/widgets/image_uploader.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/services/supply.dart';
import 'package:cloud/services/openai.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddSupplierSheet extends HookConsumerWidget {
  final int? quotationId;

  const AddSupplierSheet({
    super.key,
    this.quotationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // 状态定义
    final supplierName = useState('');
    final shopNumber = useState('');
    final contact = useState('');
    final contactPhone = useState('');
    final contactPhoneField = useState('phone');
    final contactEmail = useState('');
    final businessCard = useState<List<TemporaryMedia>>([]);
    final selectedSupplierId = useState<String?>(null);

    final recognizedSupplierData =
        useState<Map<String, dynamic>?>(null); // 保存识别接口返回的完整数据

    // 联想搜索状态
    final searchResults = useState<List<dynamic>>([]);
    final isSearching = useState(false);

    // 焦点与滚动控制
    final supplierNameFocus = useFocusNode();
    final shopNumberFocus = useFocusNode();
    final contactFocus = useFocusNode();
    final contactPhoneFocus = useFocusNode();
    final contactEmailFocus = useFocusNode();
    final mainScrollController = useScrollController();

    // 为每个输入框创建 GlobalKey
    final supplierNameKey = useMemoized(() => GlobalKey());
    final shopNumberKey = useMemoized(() => GlobalKey());
    final contactKey = useMemoized(() => GlobalKey());
    final contactPhoneKey = useMemoized(() => GlobalKey());
    final contactEmailKey = useMemoized(() => GlobalKey());

    // 环境信息
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    // 智能滚动到指定输入框
    void scrollToWidget(GlobalKey widgetKey) {
      if (!mainScrollController.hasClients) return;

      Future.delayed(const Duration(milliseconds: 50), () {
        try {
          final RenderBox? renderBox =
              widgetKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox == null) return;

          // 获取输入框在屏幕中的位置
          final position = renderBox.localToGlobal(Offset.zero);
          final boxHeight = renderBox.size.height;

          // 计算可见区域高度（屏幕高度 - 键盘高度 - 安全区域）
          final visibleHeight = screenHeight - keyboardHeight - 20;

          // 如果输入框底部超出可见区域，需要滚动
          if (position.dy + boxHeight > visibleHeight) {
            // 计算需要滚动的偏移量
            final offset = position.dy + boxHeight - visibleHeight + 80;

            // 获取当前滚动位置
            final currentOffset = mainScrollController.offset;
            final maxOffset = mainScrollController.position.maxScrollExtent;

            // 计算目标滚动位置
            var targetOffset = currentOffset + offset;
            // 确保不超出最大滚动范围
            if (targetOffset > maxOffset) {
              targetOffset = maxOffset;
            }

            mainScrollController.animateTo(
              targetOffset,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
            );
          }
        } catch (e) {
          // 如果获取位置失败，回退到滚动到底部
          mainScrollController.animateTo(
            mainScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          );
        }
      });
    }

    // 获取当前焦点的输入框 Key
    GlobalKey? getCurrentFocusKey() {
      if (supplierNameFocus.hasFocus) return supplierNameKey;
      if (shopNumberFocus.hasFocus) return shopNumberKey;
      if (contactFocus.hasFocus) return contactKey;
      if (contactPhoneFocus.hasFocus) return contactPhoneKey;
      if (contactEmailFocus.hasFocus) return contactEmailKey;
      return null;
    }

    // 监听焦点变化，智能滚动
    useEffect(() {
      void listener() {
        final focusKey = getCurrentFocusKey();
        if (focusKey != null) {
          scrollToWidget(focusKey);
        }
      }

      final focusNodes = [
        supplierNameFocus,
        shopNumberFocus,
        contactFocus,
        contactPhoneFocus,
        contactEmailFocus,
      ];

      for (final node in focusNodes) {
        node.addListener(listener);
      }

      return () {
        for (final node in focusNodes) {
          node.removeListener(listener);
        }
      };
    }, [
      supplierNameFocus,
      shopNumberFocus,
      contactFocus,
      contactPhoneFocus,
      contactEmailFocus,
    ]);

    // 监听键盘弹出，智能滚动到当前焦点输入框
    useEffect(() {
      if (isKeyboardOpen) {
        final focusKey = getCurrentFocusKey();
        if (focusKey != null) {
          scrollToWidget(focusKey);
        }
      }
      return null;
    }, [keyboardHeight]);

    // 处理选中逻辑（模型对象转 Map）
    void handleSelectFromModel(dynamic model) {
      selectedSupplierId.value = model.id?.toString();
      supplierName.value = model.name ?? '';
      shopNumber.value = model.stallAddress ?? '';

      final contacts = model.contacts;
      if (contacts is List && contacts.isNotEmpty) {
        final firstContact = contacts.first;
        if (firstContact is Map) {
          contact.value = firstContact['name']?.toString() ?? '';
          contactPhone.value = firstContact['phone']?.toString() ?? '';
          contactPhoneField.value = 'phone';
          contactEmail.value = firstContact['email']?.toString() ?? '';
        } else if (firstContact != null) {
          contact.value = firstContact.name?.toString() ?? '';
          contactPhone.value = firstContact.phone?.toString() ?? '';
          contactPhoneField.value = 'phone';
          contactEmail.value = firstContact.email?.toString() ?? '';
        }
      } else {
        contact.value = '';
        contactPhone.value = '';
        contactPhoneField.value = 'phone';
        contactEmail.value = '';
      }

      searchResults.value = [];
      FocusScope.of(context).unfocus();
    }

    // 防抖搜索逻辑
    useEffect(() {
      Timer? debounce;
      Future<void> fetchSuggestions() async {
        if (supplierName.value.trim().isEmpty ||
            selectedSupplierId.value != null) {
          searchResults.value = [];
          isSearching.value = false;
          return;
        }

        isSearching.value = true; // 开始搜索
        try {
          final resp = await getSupplySuppliers(queryParameters: {
            "search": supplierName.value.trim(),
            "per_page": 5,
          });
          searchResults.value = resp.data;
        } catch (e) {
          debugPrint('联想搜索失败: $e');
        } finally {
          isSearching.value = false; // 搜索结束
        }
      }

      debounce = Timer(const Duration(milliseconds: 500), fetchSuggestions);
      return () => debounce?.cancel();
    }, [supplierName.value]);

    void onSubmit() async {
      if (supplierName.value.trim().isEmpty) {
        supplierNameFocus.requestFocus();
        return;
      }
      try {
        if (selectedSupplierId.value != null) {
          Navigator.pop(context);
          await context.router.push(QuoteProductNewAddRoute(
            quoteId: quotationId,
            supplierId: selectedSupplierId.value!,
          ));
          return;
        }

        final data = <String, dynamic>{
          'name': supplierName.value.trim(),
          'collection_name': "bussiness_card",
          'stall_address': shopNumber.value.trim(),
          'item_type': "market",
        };

        // 将识别到的供应商其余字段（排除页面展示的名称和档口地址）传给服务器
        final recognized = recognizedSupplierData.value;
        final contactInfo = <String, dynamic>{
          'name': contact.value.trim().isNotEmpty
              ? contact.value.trim()
              : recognized?['contact_name']?.toString().trim() ?? '',
          'email': contactEmail.value.trim().isNotEmpty
              ? contactEmail.value.trim()
              : recognized?['email']?.toString().trim() ?? '',
          if (recognized != null) ...{
            'fax': recognized['fax']?.toString().trim() ?? '',
            'myt': recognized['myt']?.toString().trim() ?? '',
            'qq': recognized['qq']?.toString().trim() ?? '',
            'wechat': recognized['wechat']?.toString().trim() ?? '',
          },
        }..removeWhere((_, value) => value.toString().isEmpty);

        if (contactPhone.value.trim().isNotEmpty) {
          contactInfo[contactPhoneField.value] = contactPhone.value.trim();
        }
        if (contactPhoneField.value == 'phone') {
          final mobile = recognized?['mobile']?.toString().trim() ?? '';
          if (mobile.isNotEmpty) {
            contactInfo['mobile'] = mobile;
          }
        }

        if (contactInfo.isNotEmpty) {
          data['contacts'] = [contactInfo];
        }

        if (recognized != null) {
          if (recognized['address'] != null) {
            data['address'] = recognized['address'].toString().trim();
          }
          if (recognized['short_name'] != null) {
            data['short_name'] = recognized['short_name'].toString().trim();
          }
        }

        if (businessCard.value.isNotEmpty) {
          data['images'] = businessCard.value
              .map((e) => {...e.toJson(), 'collection_name': 'bussiness_card'})
              .toList();
        }

        final supplier = await storeSupplySupplier(data);

        if (supplier != null && context.mounted) {
          Navigator.of(context).pop(supplier.toJson());
          if (supplier.id != null || quotationId != null) {
            await context.router.push(QuoteProductNewAddRoute(
              quoteId: quotationId,
              supplierId: supplier.id.toString(),
            ));
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('操作失败: ${e.toString()}')),
          );
        }
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: isKeyboardOpen ? screenHeight * 0.9 : screenHeight * 0.85,
        minHeight: isKeyboardOpen ? screenHeight * 0.7 : 0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('添加供应商',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              controller: mainScrollController,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: keyboardHeight + 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ImageUploader(
                    extraContent: const Text(
                      '  可识别店面门头、名片',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    maxCount: 1,
                    customIcon: Icons.camera_alt,
                    recognizeAtBottom: true,
                    enableContinuous: true,
                    autoRecognize: true,
                    recognizeApi: identifySupplierShopCard,
                    onRecognizeResult: (data) {
                      if (data != null && data is Map<String, dynamic>) {
                        recognizedSupplierData.value =
                            Map<String, dynamic>.from(data);
                        selectedSupplierId.value = null;
                        if (data['supplier_name'] != null) {
                          supplierName.value = data['supplier_name'].toString();
                        }
                        if (data['stall_address'] != null) {
                          shopNumber.value = data['stall_address'].toString();
                        }
                        if (data['contact_name'] != null) {
                          contact.value = data['contact_name'].toString();
                        }
                        final phone = data['phone']?.toString().trim() ?? '';
                        final mobile = data['mobile']?.toString().trim() ?? '';
                        if (phone.isNotEmpty) {
                          contactPhone.value = phone;
                          contactPhoneField.value = 'phone';
                        } else if (mobile.isNotEmpty) {
                          contactPhone.value = mobile;
                          contactPhoneField.value = 'mobile';
                        } else {
                          contactPhone.value = '';
                          contactPhoneField.value = 'phone';
                        }
                        if (data['email'] != null) {
                          contactEmail.value = data['email'].toString();
                        }
                      }
                    },
                    value: businessCard.value,
                    onChanged: (value) => businessCard.value = value,
                  ),
                  const SizedBox(height: 20),

                  // 供应商名称输入区
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Input(
                              label: '供应商名称',
                              value: supplierName.value,
                              onChanged: (value) {
                                supplierName.value = value;
                                selectedSupplierId.value = null;
                              },
                              focusNode: supplierNameFocus,
                              hintText: '请输入供应商名称',
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),

                      // 优化后的联想搜索展示 (含加载效果)
                      if ((searchResults.value.isNotEmpty ||
                              isSearching.value) &&
                          selectedSupplierId.value == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: colorScheme.primary.withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(maxHeight: 240),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 面板顶部状态条
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  color: colorScheme.primary.withOpacity(0.05),
                                  child: Row(
                                    children: [
                                      isSearching.value
                                          ? const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : Icon(Icons.lightbulb_outline,
                                              size: 14,
                                              color: colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                          isSearching.value
                                              ? '正在匹配供应商...'
                                              : '系统发现匹配的现有供应商',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                // 加载进度条
                                if (isSearching.value)
                                  LinearProgressIndicator(
                                    minHeight: 2,
                                    backgroundColor: Colors.transparent,
                                    color: colorScheme.primary.withOpacity(0.3),
                                  ),
                                // 结果列表
                                if (searchResults.value.isNotEmpty)
                                  Flexible(
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: searchResults.value.length,
                                      separatorBuilder: (c, i) => Divider(
                                          height: 1,
                                          indent: 16,
                                          endIndent: 16,
                                          color: Colors.grey.shade100),
                                      itemBuilder: (context, index) {
                                        final item = searchResults.value[index];
                                        final String name = item.name ?? '';
                                        final String address =
                                            item.stallAddress ?? '';

                                        return InkWell(
                                          onTap: () =>
                                              handleSelectFromModel(item),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor:
                                                      Colors.grey.shade50,
                                                  child: Icon(
                                                      Icons.storefront_outlined,
                                                      size: 18,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(name,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFF222222))),
                                                      if (address.isNotEmpty)
                                                        Text(address,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500)),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: colorScheme.primary
                                                        .withOpacity(0.08),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text('选取',
                                                      style: TextStyle(
                                                          color: colorScheme
                                                              .primary,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ],
                                            ),
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

                  const SizedBox(height: 16),
                  Container(
                    key: shopNumberKey,
                    child: Input(
                      label: '店铺号',
                      value: shopNumber.value,
                      onChanged: (value) => shopNumber.value = value,
                      focusNode: shopNumberFocus,
                      hintText: '请输入店铺号',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    key: contactKey,
                    child: Input(
                      label: '联系人',
                      value: contact.value,
                      onChanged: (value) => contact.value = value,
                      focusNode: contactFocus,
                      hintText: '请输入联系人',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    key: contactPhoneKey,
                    child: Input(
                      label: '手机号',
                      value: contactPhone.value,
                      onChanged: (value) => contactPhone.value = value,
                      focusNode: contactPhoneFocus,
                      hintText: '请输入手机号',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    key: contactEmailKey,
                    child: Input(
                      label: 'Email',
                      value: contactEmail.value,
                      onChanged: (value) => contactEmail.value = value,
                      focusNode: contactEmailFocus,
                      hintText: '请输入邮箱',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: const Text('取消',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedSupplierId.value != null
                                ? Colors.orange.shade700
                                : colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                              selectedSupplierId.value != null
                                  ? '使用现有'
                                  : '保存供应商',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

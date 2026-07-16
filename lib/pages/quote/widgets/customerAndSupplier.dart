import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_detail/widgets/sheet/new_supplier.dart';
import 'package:cloud/pages/widgets/input.dart';
import 'package:cloud/pages/widgets/quote_select.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String _getSafeName(dynamic data, List<String> keys) {
  if (data == null) return '';
  if (data is Map) {
    for (final key in keys) {
      final value = data[key];
      if (value != null) return value.toString();
    }
  }

  try {
    if (keys.contains('name')) return data.name ?? '';
    if (keys.contains('short_name')) return data.shortName ?? data.name ?? '';
  } catch (_) {}

  return '';
}

// 录入信息 底部sheet

Future<void> showCustomerAndSupplierSheet({
  required BuildContext context,
  required Map<String, dynamic>? initialQuote,
  required Map<String, dynamic>? initialSupplier,
  required FutureOr<void> Function(
    Map<String, dynamic>? quote,
    Map<String, dynamic>? supplier,
  ) onConfirm,
  bool autoPushQuoteProductRoute = false,
  int? initialTabIndex,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => HookConsumer(
      builder: (context, ref, child) {
        final tempQuote = useState<Map<String, dynamic>?>(initialQuote);
        final tempSupplier = useState<Map<String, dynamic>?>(initialSupplier);
        final colorScheme = Theme.of(context).colorScheme;

        final companyName = _getSafeName(tempQuote.value?['company'], ['name']);
        final supplierName =
            _getSafeName(tempSupplier.value, ['short_name', 'name']);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 52,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Text(
                "录入信息",
                style: TextStyle(
                    fontSize: 16,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 15,
                left: 15,
                right: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [ 
                  GestureDetector(
                    onTap: () async {
                      final result =
                          await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        backgroundColor: Colors.transparent,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        builder: (ctx) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(ctx).viewInsets.bottom,
                            ),
                            child: const QuoteSelect(),
                          );
                        },
                      );

                      if (result != null && context.mounted) {
                        tempQuote.value = result;
                      }
                    },
                    child: AbsorbPointer(
                      child: Input(
                        label: '对应客户',
                        value: companyName,
                        hintText: '请选择客户',
                        showClearButton: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final result =
                          await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        builder: (context) => const AddSupplierSheet(),
                      );

                      if (result != null && context.mounted) {
                        tempSupplier.value = result;
                      }
                    },
                    child: AbsorbPointer(
                      child: Input(
                        label: '所属供应商', 
                        isRequired: true,
                        value: supplierName,
                        hintText: '请选择供应商',
                        showClearButton: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: colorScheme.surface,
                      side: BorderSide(
                          color: colorScheme.primary.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (tempSupplier.value == null) {
                        EasyLoading.showInfo("请先选择供应商");
                        return;
                      }

                      await onConfirm(tempQuote.value, tempSupplier.value);

                      if (autoPushQuoteProductRoute && context.mounted) {
                        final sId = tempSupplier.value?['id']?.toString();
                        final qId = tempQuote.value?['id'];
                        context.router.push(QuoteProductNewAddRoute(
                          quoteId: qId,
                          supplierId: sId,
                          initialTabIndex: initialTabIndex ?? 0,
                        ));
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text("确定",
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

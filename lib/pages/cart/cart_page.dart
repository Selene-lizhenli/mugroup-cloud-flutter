import 'package:auto_route/auto_route.dart';
import 'package:cloud/constants/cart.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/cart/cart_l10n_helper.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/cart/widgets/sample_card.dart';
import 'package:cloud/pages/cart/widgets/operate_bar.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/wms.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:cloud/widgets/approval_note_dialog.dart';
import 'package:cloud/widgets/quotation_info_dialog.dart';
import 'widgets/sample_item.dart';

@RoutePage()
class CartPage extends HookConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final barcodeTextController = useTextEditingController();

    final items = state.items;
    final carts = state.carts;
    final cartType = state.type;
    final warehouse = state.warehouse;
    final borrow = state.borrow;
    final transfer = state.transfer;
    final delivery = state.delivery;
    final quotationInfo = state.quotationInfo;

    final borrower = useState<User?>(null);
    const warningColor = Color(0xFFFFD75E);
    final user = useState<User?>(null);
    final quotationRemarkController = useTextEditingController();

    // quotationInfo 设置弹窗已抽成可复用组件，见 `QuotationInfoDialog`

    String getStockInOptionText(String? stockInOption) {
      if (stockInOption == null) {
        return l10n.cartSelectStockInType;
      }
      if (stockInOptionTypes.contains(stockInOption)) {
        return stockInTypeLocalizedTitle(context, stockInOption);
      }
      return l10n.cartStockInTypeNotSet;
    }

    final header = useMemoized(() {
      if (cartType == CartType.borrowOut || cartType == CartType.inout) {
        return GestureDetector(
          onTap: () async {
            final selectedWarehouse = await context.router
                .push<Warehouse>(const SelectWmsWarehouseRoute());

            cart.warehouse = selectedWarehouse;
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(warehouse == null
                    ? l10n.cartSelectWarehouse
                    : warehouse.name ?? l10n.cartWarehouseNameNotSet),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cartType == CartType.borrowIn) {
        return GestureDetector(
          onTap: () async {
            final selectedUser =
                await context.router.push<User>(const SelectUserRoute());

            borrower.value = selectedUser;
            logger.d(borrower.value?.name);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(borrower.value == null
                    ? l10n.cartSelectBorrower
                    : "${borrower.value!.name}(${borrower.value!.jobNumber})"),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cartType == CartType.transferOut || cartType == CartType.transferIn) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(transfer == null
                    ? l10n.cartScanTransferQr
                    : transfer.orderNo ?? l10n.cartTransferOrderNotSet),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cartType == CartType.deliveryOut) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(delivery == null
                    ? l10n.cartScanDeliveryQr
                    : delivery.orderNo ?? l10n.cartDeliveryOrderNotSet),
                const Icon(Icons.chevron_right)
              ],
            ),
          ),
        );
      }

      if (cartType == CartType.stockIn) {
        return Column(
          children: [
            GestureDetector(
              onTap: () async {
                final selectedWarehouse = await context.router
                    .push<Warehouse>(const SelectWmsWarehouseRoute());

                cart.warehouse = selectedWarehouse;
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(warehouse == null
                        ? l10n.cartSelectWarehouse
                        : warehouse.name ?? l10n.cartWarehouseNameNotSet),
                    const Icon(Icons.chevron_right)
                  ],
                ),
              ),
            ),
          ],
        );
      }
      return GestureDetector(
        child: const SizedBox(),
      );
    }, [
      cartType,
      warehouse,
      borrow,
      transfer,
      borrower.value,
    ]);

    void selectCart(List<CartSelect> selectCarts) {
      showFlanActionSheet(
        context,
        description: l10n.cartSelectSampleCart,
        cancelText: l10n.quotationThinkAgain,
        actions: selectCarts
            .map((select) => FlanActionSheetAction(
                name: cartTypeLocalizedTitle(context, select.type)))
            .toList(),
        closeOnClickAction: true,
        onSelect: (action, index) {
          cart.type = selectCarts[index].type;
        },
      );
    }

    Future<void> borrowDialog(BuildContext context) async {
      final reasonController = TextEditingController();

      await showDialog(
        context: context,
        builder: (context) {
          String? borrowReason;
          List<int>? selectedDate = [
            DateTime.now()
                    .add(const Duration(days: 7))
                    .microsecondsSinceEpoch ~/
                1000
          ];

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                title: Text(
                  l10n.cartConfirmBorrow,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  height: 270,
                  width: 300,
                  child: CustomScrollView(slivers: [
                    MultiSliver(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.cartBorrower,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final selectedUser = await context.router
                                    .push<User>(const SelectUserRoute());
                                user.value = selectedUser;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user.value == null
                                            ? l10n.cartSelectUser
                                            : "${user.value!.name} (${user.value!.department?.name ?? l10n.cartNoDepartment})",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: user.value == null
                                              ? Colors.grey.shade600
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_right,
                                        color: Colors.grey), // 添加右侧箭头
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.cartBorrowReason,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                showFlanActionSheet(
                                  context,
                                  description: l10n.cartSelectBorrowReason,
                                  cancelText: l10n.quotationThinkAgain,
                                  actions: borrowReasonIds
                                      .map((id) => FlanActionSheetAction(
                                          name:
                                              borrowReasonLocalizedTitle(
                                                  context, id)))
                                      .toList(),
                                  closeOnClickAction: true,
                                  onSelect: (action, index) {
                                    borrowReason = borrowReasonIds[index];
                                    setState(() {});
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                child: borrowReason == borrowReasonOther
                                    ? TextField(
                                        controller: reasonController,
                                        decoration: InputDecoration(
                                          hintText: l10n.cartBorrowReasonHint,
                                          border: InputBorder.none,
                                        ),
                                        maxLines: 2,
                                        minLines: 1,
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              borrowReason == null
                                                  ? l10n.cartSelectBorrowReason
                                                  : borrowReasonLocalizedTitle(
                                                      context, borrowReason!),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: borrowReason == null
                                                    ? Colors.grey.shade600
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              l10n.cartExpectedReturnTime,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => {
                                TDCalendarPopup(
                                  context,
                                  visible: true,
                                  onConfirm: (value) {
                                    setState(() {
                                      selectedDate = value;
                                    });
                                  },
                                  child: TDCalendar(
                                    title: l10n.cartSelectDate,
                                    value: selectedDate,
                                  ),
                                ),
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedDate == null
                                          ? l10n.cartSelectDate
                                          : '${DateTime.fromMillisecondsSinceEpoch(selectedDate![0]).year}-${DateTime.fromMillisecondsSinceEpoch(selectedDate![0]).month}-${DateTime.fromMillisecondsSinceEpoch(selectedDate![0]).day}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      l10n.cancel,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final reason = reasonController.text.isNotEmpty
                          ? reasonController.text
                          : (borrowReason != null
                              ? borrowReasonLocalizedTitle(
                                  context, borrowReason!)
                              : null);

                      if (user.value == null) {
                        EasyLoading.showInfo(l10n.cartSelectUserFirst);
                        return;
                      }
                      // 借样理由
                      if ((borrowReason == null ||
                              borrowReason == borrowReasonOther) &&
                          reasonController.text.isEmpty) {
                        EasyLoading.showInfo(
                          borrowReason == null
                              ? l10n.cartSelectBorrowReasonFirst
                              : l10n.cartInputBorrowReasonFirst,
                        );
                        return;
                      }
                      if (selectedDate == null) {
                        EasyLoading.showInfo(l10n.cartSelectReturnTimeFirst);
                        return;
                      }
                      final productData = items
                          .map((item) => {
                                "product_id": item.sample.id,
                                "inout_qty": item.count,
                                "product_no": item.sample.productNo,
                              })
                          .toList();
                      final data = {
                        "borrower_id": user.value?.id,
                        "warehouse_id": warehouse?.id,
                        "products": productData,
                        "borrow_reason": reason,
                        "expected_returned_at":
                            DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    selectedDate![0])),
                      };
                      EasyLoading.show(status: l10n.loading);
                      await storeBorrow(data);
                      EasyLoading.showSuccess(l10n.cartBorrowSuccess);
                      cart.clear();
                      user.value = null;
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.submit,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

      reasonController.dispose();
    }

    void showQuotationCreatedActionsDialog(
      BuildContext pageContext,
      int quotationId,
    ) {
      final router = pageContext.router;
      showDialog<void>(
        context: pageContext,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(l10n.cartQuotationCreatedTitle),
            content: Text(l10n.cartQuotationCreatedContent),
            actions: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        router.push(
                          SampleQuoteDetailRoute(id: quotationId),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: colorScheme.secondary,
                      ),
                      child: Text(
                        l10n.cartViewDetail,
                        style: TextStyle(color: colorScheme.onSecondary),
                      ),
                    ),
                    // 暂时隐藏导出功能 导出需要审批
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     foregroundColor: Colors.white,
                    //     elevation: 0,
                    //     padding: const EdgeInsets.symmetric(
                    //       vertical: 8,
                    //       horizontal: 14,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //     backgroundColor: colorScheme.primary,
                    //   ),
                    //   onPressed: () async {
                    //     Navigator.of(dialogContext).pop();
                    //     try {
                    //       EasyLoading.show(status: '正在加载数据，请稍后...');
                    //       final detail = await getQuotationListById(quotationId);
                    //       final templatesResp =
                    //           await getShowroomQuotationExportTemplate();
                    //       final dynamicTemplates = templatesResp.data;
                    //       if (!pageContext.mounted) return;
                    //       EasyLoading.dismiss();
                    //       showQuotationDownloadSheet(
                    //         context: pageContext,
                    //         item: detail,
                    //         dynamicTemplates: dynamicTemplates,
                    //         permissions: permissions,
                    //       );
                    //     } catch (e) {
                    //       EasyLoading.dismiss();
                    //       EasyLoading.showError('获取导出数据失败,$e');
                    //     }
                    //   },
                    //   child: Text(
                    //     '立即导出',
                    //     style: TextStyle(color: colorScheme.onPrimary),
                    //   ),
                    // ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: colorScheme.primary,
                      ),
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    Future<void> submitQuotationFromDialog(
      BuildContext pageContext,
      BuildContext showModalBottomSheetContext, {
      bool submitForApproval = false,
      String? approvalNote,
      BuildContext? approvalDialogContext,
    }) async {
      if (user.value == null) {
        EasyLoading.showInfo(l10n.cartSelectUserFirst);
        return;
      }
      try {
        EasyLoading.show(status: l10n.loading);
        final data = {
          "sample_items": items
              .map((item) => {
                    "sample_id": item.sample.id,
                    "price": item.price,
                    "qty": item.count
                  })
              .toList(),
          "user_id": user.value?.id,
          "curreny": quotationInfo?.curreny,
          "exchange": quotationInfo?.exchange,
          "commission_rate": quotationInfo?.commissionRate,
          "is_tax_inclusive": quotationInfo?.showTaxRatePrice,
          "remark": quotationRemarkController.text,
        };
        final res = await storeShowroomQuotation(data);
        final quotationId = res?.id;

        if (submitForApproval) {
          if (quotationId == null) {
            EasyLoading.dismiss();
            EasyLoading.showError(l10n.cartQuotationNoIdForApproval);
            return;
          }
          EasyLoading.show(status: l10n.cartSubmittingApproval);
          await submitShowroomQuotationApproval(
            quotationId,
            note: approvalNote,
          );
          EasyLoading.dismiss();
          if (pageContext.mounted) {
            EasyLoading.showSuccess(l10n.cartSubmitSuccess);
          }
        } else {
          EasyLoading.dismiss();
        }
        EasyLoading.dismiss();
        cart.clear();
        user.value = null;
        quotationRemarkController.clear();
        if (pageContext.mounted) {
          if (approvalDialogContext != null && approvalDialogContext.mounted) {
            Navigator.of(approvalDialogContext).pop();
          }
          if (showModalBottomSheetContext.mounted) {
            Navigator.of(showModalBottomSheetContext).pop();
          }
          if (quotationId != null) {
            showQuotationCreatedActionsDialog(
              pageContext,
              quotationId,
            );
          }
        }
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError(
          submitForApproval
              ? l10n.cartSaveOrSubmitFailed('$e')
              : l10n.cartCreateQuotationFailed('$e'),
        );
      }
    }

    void quotationDialog(BuildContext pageContext) {
      quotationRemarkController.clear();
      showModalBottomSheet(
        context: pageContext,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        builder: (showModalBottomSheetContext) {
          return StatefulBuilder(
            builder: (context, setSheetState) {
              final bottomInset = MediaQuery.of(context).viewInsets.bottom;
              return AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            color: colorScheme.primary,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.cartConfirmQuotation,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  quotationRemarkController.clear();
                                  Navigator.of(showModalBottomSheetContext)
                                      .pop();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.cartExporterLabel,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: () async {
                                  final selectedUser = await pageContext.router
                                      .push<User>(const SelectUserRoute());
                                  user.value = selectedUser;
                                  setSheetState(() {});
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color.fromARGB(
                                        255, 236, 236, 236),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          user.value == null
                                              ? l10n.cartSelectUser
                                              : "${user.value!.name} (${user.value!.department?.name ?? l10n.cartNoDepartment})",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: user.value == null
                                                ? const Color.fromARGB(
                                                    255, 191, 191, 191)
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.cartRemark,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 0,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      const Color.fromARGB(255, 236, 236, 236),
                                ),
                                child: TextField(
                                  controller: quotationRemarkController,
                                  minLines: 2,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 191, 191, 191)),
                                    hintText: l10n.cartQuotationRemarkHint,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (user.value == null) {
                                        EasyLoading.showInfo(
                                            l10n.cartSelectUserFirst);
                                        return;
                                      }
                                      await ApprovalNoteDialog.show(
                                        pageContext,
                                        onConfirm: (note, dialogContext) =>
                                            submitQuotationFromDialog(
                                          pageContext,
                                          showModalBottomSheetContext,
                                          submitForApproval: true,
                                          approvalNote: note,
                                          approvalDialogContext: dialogContext,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.surface,
                                      side: BorderSide(
                                        width: 1,
                                        color: colorScheme.secondary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.cartSaveAndApprove,
                                      style: TextStyle(
                                          color: colorScheme.secondary),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: () => submitQuotationFromDialog(
                                      pageContext,
                                      showModalBottomSheetContext,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.cartSaveOnly,
                                      style: TextStyle(
                                          color: colorScheme.onSecondary),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    Future<void> quotationInfoDialog(BuildContext context) async {
      final next = await QuotationInfoDialog.show(
        context,
        initialValue: quotationInfo,
        currencies: currencies,
      );
      if (next == null) return;
      cart.quotationInfo = next;
    }

    void setPriceDialog(BuildContext context, CartItem item) {
      showDialog(
        context: context,
        builder: (context) {
          final priceController = TextEditingController();
          priceController.text = item.price ?? "";
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text(
              l10n.cartAdjustPrice,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cartPrice,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (priceController.text == "") {
                    cart.setSamplePrice(item.sample, null);
                  } else {
                    cart.setSamplePrice(item.sample, priceController.text);
                  }

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.submit,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    void handBarcodeDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              l10n.cartFillProductBarcode,
              style: TextStyle(
                fontSize: 20,
                color: colorScheme.onSurface,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.cartProductBarcode,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: barcodeTextController,
                    autofocus: true,
                    cursorColor: colorScheme.secondary,
                    decoration: InputDecoration(
                      hintText: l10n.cartProductBarcodeHint,
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: colorScheme.secondary,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 0.5,
                          color: colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 1,
                          color: colorScheme.secondary,
                        ),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainer,
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  barcodeTextController.clear();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final input = barcodeTextController.text.trim();
                  if (input.isEmpty) {
                    EasyLoading.showInfo(l10n.cartProductBarcodeRequired);
                    return;
                  }

                  cart.addItemByBarcode(input);
                  barcodeTextController.clear();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.submit,
                  style: TextStyle(
                    color: colorScheme.onSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    void transferDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          final text = cartType == CartType.transferIn
              ? l10n.cartTransferIn
              : l10n.cartTransferOut;
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text(
              l10n.cartConfirmAction(text),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.cancel,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final productData = items
                      .map((item) => {
                            "product_id": item.sample.id,
                            "inout_qty": item.count,
                            "product_no": item.sample.productNo,
                            "barcode": item.sample.barcode
                          })
                      .toList();
                  final data = {"items": productData};

                  EasyLoading.show(status: l10n.loading);

                  if (cartType == CartType.transferOut) {
                    await addTransferItems(transfer!.id!, data);
                    EasyLoading.showSuccess(l10n.cartTransferOutSuccess);
                  }

                  if (cartType == CartType.transferIn) {
                    await transferIn(transfer!.id!, data);
                    EasyLoading.showSuccess(l10n.cartTransferInSuccess);
                  }

                  cart.clear();

                  if (context.mounted) {
                    //关闭弹窗
                    Navigator.of(context).pop();
                    //返回调拨详情页面(保证刷新)
                    context.router
                        .push(WmsTransferRoute(code: transfer!.orderNo!));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  l10n.cartConfirm,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    void deliveryDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            final text = cartType == CartType.deliveryOut
                ? l10n.cartDeliveryOut
                : l10n.cartUnknown;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                l10n.cartConfirmAction(text),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final productData = items
                        .map((item) => {
                              "product_id": item.sample.id,
                              "qty": item.count,
                              "product_no": item.sample.productNo,
                              "barcode": item.sample.barcode
                            })
                        .toList();
                    final data = {"items": productData};

                    EasyLoading.show(status: l10n.loading);

                    if (cartType == CartType.deliveryOut) {
                      await addDeliveryItems(delivery!.id!, data);
                      EasyLoading.showSuccess(l10n.cartDeliverySuccess);
                    }

                    cart.clear();

                    if (context.mounted) {
                      //关闭弹窗
                      Navigator.of(context).pop();
                      //返回出货详情页面(保证刷新)
                      context.router
                          .push(WmsDeliveryRoute(code: delivery!.orderNo!));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.cartConfirm,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
    }

    void stockInDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          final text = cartType == CartType.stockIn
              ? l10n.cartStockIn
              : l10n.cartUnknown;
          final remarkController = TextEditingController();
          String? stockInOption;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                title: Text(
                  l10n.cartConfirmAction(text),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 入库类型选择
                      Text(
                        l10n.cartStockInType,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          showFlanActionSheet(
                            context,
                            description: l10n.cartSelectStockInType,
                            cancelText: l10n.quotationThinkAgain,
                            actions: stockInOptionTypes
                                .map((type) => FlanActionSheetAction(
                                    name: stockInTypeLocalizedTitle(
                                        context, type)))
                                .toList(),
                            closeOnClickAction: true,
                            onSelect: (action, index) {
                              setState(() {
                                stockInOption = stockInOptionTypes[index];
                              });
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  getStockInOptionText(stockInOption),
                                  style: TextStyle(
                                    color: stockInOption == null
                                        ? Colors.grey.shade500
                                        : Colors.black,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey.shade500,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 备注输入
                      Text(
                        l10n.cartRemark,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: remarkController,
                          decoration: InputDecoration(
                            hintText: l10n.cartRemarkHint,
                            border: InputBorder.none, // 移除TextField自带边框
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          minLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.cancel,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // 验证入库类型是否选择
                      if (stockInOption == null) {
                        EasyLoading.showError(l10n.cartSelectStockInType);
                        return;
                      }

                      final productData = items
                          .map((item) => {
                                'model_type':
                                    "App\\Models\\Showroom\\ShowroomSample",
                                "model_id": item.sample.id,
                                "name": item.sample.name,
                                "product_no": item.sample.productNo,
                                "inout_qty": item.count
                              })
                          .toList();
                      final data = {
                        "products": productData,
                        "type": "in",
                        'operation_type': stockInOption,
                        'warehouse_id': warehouse?.id,
                        'remark': remarkController.text.trim(),
                      };

                      EasyLoading.show(status: l10n.loading);

                      if (cartType == CartType.stockIn) {
                        await storeWmsStockInOut(data);
                        EasyLoading.showSuccess(l10n.cartStockInSuccess);
                      }

                      cart.clear();

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.cartConfirm,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    void onPressed() async {
      // 借样
      if (cartType == CartType.borrowOut) {
        if (warehouse == null) {
          EasyLoading.showInfo(l10n.cartSelectWarehouseFirst);
          return;
        }
        borrowDialog(context);
      }

      //创建报价单
      if (cartType == CartType.quotation) {
        quotationDialog(context);
      }

      // 调拨出/入库
      if (cartType == CartType.transferOut || cartType == CartType.transferIn) {
        if (transfer == null) {
          EasyLoading.showInfo(l10n.cartScanTransferFirst);
          return;
        }
        transferDialog(context);
      }

      //出货
      if (cartType == CartType.deliveryOut) {
        if (delivery == null) {
          EasyLoading.showInfo(l10n.cartScanDeliveryFirst);
          return;
        }
        deliveryDialog(context);
      }

      final productData = items
          .map((item) => {
                "product_id": item.sample.id,
                "inout_qty": item.count,
                "product_no": item.sample.productNo,
                "barcode": item.sample.barcode
              })
          .toList();

      // 还样
      if (cartType == CartType.borrowIn) {
        if (borrower.value == null) {
          EasyLoading.showInfo(l10n.cartSelectBorrowerFirst);
          return;
        }

        EasyLoading.show(status: l10n.loading);

        if (borrower.value != null) {
          final data = {
            "borrower_user_id": borrower.value!.id!,
            "return_items": productData,
          };
          final resp = await borrowInByUser(data);

          //根据返回的数据更新购物车
          cart.setSapleByProductId(
              (resp.data["abnormal"] as List).cast<Map<String, dynamic>>());
        }

        EasyLoading.showSuccess(l10n.cartReturnSuccess);
      }

      //盘点
      if (cartType == CartType.inout) {
        if (warehouse == null) {
          EasyLoading.showInfo(l10n.cartSelectWarehouseFirst);
          return;
        }
        if (context.mounted) {
          context.router
              .push(ConfirmRoute(items: (items), warehouse: warehouse));
        }
      }

      //入库
      if (cartType == CartType.stockIn) {
        if (warehouse == null) {
          EasyLoading.showInfo(l10n.cartSelectWarehouseFirst);
          return;
        }
        if (context.mounted) {
          stockInDialog(context);
        }
      }
    }

    return Scaffold(
      
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => selectCart(carts),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(cartType != null
                    ? cartTypeLocalizedTitle(context, cartType!)
                    : l10n.cartSelectSampleCartTitle),
                const Icon(Icons.arrow_drop_down),
                if (cartType != null) const SizedBox(width: 5),
                if (items.isNotEmpty)
                  Text(
                    "(${items.length})",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          if (cartType == CartType.quotation)
            IconButton(
                onPressed: () {
                  quotationInfoDialog(context);
                },
                icon: const Icon(Icons.settings_outlined)),
          MenuAnchor(
            alignmentOffset: const Offset(-80, -5),
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.add_circle_outline),
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: () async {
                  final codes = await context.router
                      .push<List<String>>(const ScanRoute());
                  if (codes == null) {
                    return;
                  }
                  for (var item in codes) {
                    if (isUrl(item)) {
                      if (true) {
                        // 处理调拨单
                        RegExp transferExp = RegExp(r'wms/transfer/(.*)');
                        final matchTransfer = transferExp.firstMatch(item);
                        if (matchTransfer != null) {
                          final orderNo = matchTransfer.group(1)!;
                          if (context.mounted) {
                            context.router
                                .push(WmsTransferRoute(code: orderNo));
                            return;
                          }
                        }
                      }
                      if (true) {
                        // 处理出货单
                        RegExp deliveryExp = RegExp(r'wms/delivery/(.*)');
                        final matchDelivery = deliveryExp.firstMatch(item);
                        if (matchDelivery != null) {
                          final orderNo = matchDelivery.group(1)!;
                          if (context.mounted) {
                            context.router
                                .push(WmsDeliveryRoute(code: orderNo));
                            return;
                          }
                        }
                      }
                      if (true) {
                        // 处理报价单
                        RegExp quotationExp =
                            RegExp(r'showroom/quotations/(.*)');
                        final matchQuotation = quotationExp.firstMatch(item);
                        if (matchQuotation != null) {
                          final quoteNo = matchQuotation.group(1)!;
                          if (context.mounted) {
                            context.router.push(
                                ShowroomQuotationsRoute(quoteNo: quoteNo));
                            return;
                          }
                        }
                      }

                      EasyLoading.showError(l10n.cartUnsupportedBarcode);
                      return;
                    } else {
                      // 处理样品
                      cart.addItemByBarcode(item);
                    }
                  }
                },
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    const Icon(Icons.camera_alt),
                    const SizedBox(width: 8),
                    Text(l10n.cartScan),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              MenuItemButton(
                onPressed: () async {
                  handBarcodeDialog(context);
                },
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    const Icon(Icons.edit),
                    const SizedBox(width: 8),
                    Text(l10n.cartManualBarcode),
                    const SizedBox(width: 8),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                MultiSliver(
                  children: [
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                        right: 10,
                      ),
                      sliver: SliverStack(
                        insetOnOverlap: true,
                        children: [
                          const SliverPositioned.fill(
                            top: 0,
                            child: SampleCard(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          SliverClip(
                            child: MultiSliver(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                SliverPinnedHeader(child: header),
                                SliverClip(
                                  child: MultiSliver(
                                    children: [
                                      if (items.isEmpty)
                                        Center(
                                          child: Empty(
                                            showImage: true,
                                            text: l10n.cartEmptyHint,
                                          ),
                                        ),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final cartItem = items[index];
                                            return Slidable(
                                              key: ValueKey(
                                                  cartItem.sample.productNo),
                                              endActionPane: ActionPane(
                                                extentRatio: cartType ==
                                                        CartType.quotation
                                                    ? 0.5
                                                    : 0.25,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  if (cartType ==
                                                      CartType.quotation)
                                                    SlidableAction(
                                                      onPressed: (context) {
                                                        setPriceDialog(
                                                            context, cartItem);
                                                      },
                                                      backgroundColor:
                                                          Colors.blue,
                                                      foregroundColor:
                                                          Colors.white,
                                                      icon: Icons.attach_money,
                                                      label: l10n.cartAdjustPrice,
                                                    ),
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      cart.removeSample(
                                                          cartItem.sample);
                                                    },
                                                    backgroundColor: Colors.red,
                                                    foregroundColor:
                                                        Colors.white,
                                                    icon: Icons.delete,
                                                    label: l10n.cartRemove,
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 8,
                                                        horizontal: 10,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (!context
                                                              .mounted) {
                                                            return;
                                                          }

                                                          context.router.push(
                                                            ShowroomSampleDetailRoute(
                                                              id: cartItem
                                                                  .sample.id!,
                                                              xTenantId: cartItem
                                                                  .sample
                                                                  .xTenantId,
                                                            ),
                                                          );
                                                        },
                                                        child: SampleItem(
                                                          sample:
                                                              cartItem.sample,
                                                          price: cartItem.price,
                                                          xTenantId: cartItem
                                                              .sample
                                                              ?.xTenantId,
                                                          quotationInfo:
                                                              quotationInfo,
                                                          cartType: cartType,
                                                          count: cartItem.count,
                                                          onChange: (value) {
                                                            if (cartItem
                                                                    .count ==
                                                                value) {
                                                              return;
                                                            }
                                                            cart.setSample(
                                                                cartItem.sample,
                                                                value);
                                                          },
                                                        ),
                                                      )),
                                                  if (cartType ==
                                                          CartType.quotation &&
                                                      cartItem.price != null)
                                                    TDBadge(
                                                      TDBadgeType.subscript,
                                                      padding:
                                                          const EdgeInsets.all(4),
                                                      message:
                                                          l10n.cartPriceChangedBadge,
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                          childCount: items.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (cartType == null)
            InkWell(
              child: SampleCard(
                  color: warningColor,
                  child: Center(
                    child: Text(
                      l10n.cartSelectSampleCartFirst,
                      style: const TextStyle(fontSize: 12),
                    ),
                  )),
              onTap: () => selectCart(carts),
            )
          else if (items.isNotEmpty)
            OperateBar(
              onPressed: onPressed,
            ),
        ],
      ),
    );
  }
}

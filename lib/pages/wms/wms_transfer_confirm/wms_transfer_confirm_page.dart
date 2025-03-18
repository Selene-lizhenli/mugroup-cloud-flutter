import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/wms/wms_transfer_confirm/models/state.dart';
import 'package:cloud/pages/wms/wms_transfer_confirm/providers/transfer_confirm_provider.dart';
import 'package:cloud/pages/wms/wms_transfer_confirm/widgets/wms_transfer_confirm_card.dart';
import 'package:cloud/pages/wms/wms_transfer_confirm/widgets/wms_transfer_confirm_item.dart';
import 'package:cloud/pages/wms/wms_transfer_confirm/widgets/wms_transfrt_confirm_operate_bar.dart';
import 'package:cloud/services/wms.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

@RoutePage()
class WmsTransferConfirmPage extends HookConsumerWidget {
  final String code;
  const WmsTransferConfirmPage({super.key, @pathParam required this.code});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transferConfirmProviderProvider);
    final notifier = ref.read(transferConfirmProviderProvider.notifier);
    final items = state.items;
    final transfer = state.transfer;

    final transferFetch = useCallback(() async {
      final transfer = await fetchTransferByOrederNo(code);
      notifier.transfer = transfer;
      notifier.items = transfer!.items!
          .where((item) =>
              (item.inQty ?? 0) < (item.outQty ?? 0) && item.notes == null)
          .map((item) => TransferConfirmItem(
              id: item.id,
              product: item.product!,
              inQty: item.inQty,
              outQty: item.outQty,
              count: (item.outQty ?? 0) - (item.inQty ?? 0)))
          .toList();
    }, []);

    useEffect(() {
      transferFetch();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("确认入库"),
      ),
      body: Column(
        children: [
          // 让产品列表滚动
          Expanded(
            child: EasyRefresh(
              onRefresh: () async {
                await transferFetch();
              },
              child: CustomScrollView(
                slivers: [
                  MultiSliver(
                    children: [
                      ...items.map((item) {
                        final notesController = TextEditingController();
                        return Slidable(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 10,
                            ),
                            child: WmsTransferConfirmCard(
                              child: WmsTransferConfirmItem(
                                item: item,
                                onCountChange: (value) {
                                  if (item.count == value) {
                                    return;
                                  }

                                  if (value == item.outQty) {
                                    notifier.setNotes(item.product, null);
                                  }

                                  notifier.setProduct(item.product, value);
                                },
                                onCheckBoxChanged: (checked) {
                                  notifier.check(item.product, checked);
                                  notifier.setNotes(item.product, null);
                                },
                                onNotesChanged: (notes) {
                                  notesController.text = notes;
                                  notifier.setNotes(item.product, notes);
                                },
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  )
                ],
              ),
            ),
          ),
          WmsTransferConfirmOperateBar(
              checked: items.isNotEmpty &&
                  items.every((item) => item.checked == true),
              selectAll: (checked) {
                final allChecked = items.isNotEmpty &&
                    items.every((item) => item.checked == true);
                if (!allChecked) {
                  notifier.checkAll(true);
                } else {
                  notifier.checkAll(false);
                }
              },
              onConfirm: () async {
                logger.d(items);
                final data = {
                  "items": items
                      .where((item) => item.checked == true)
                      .map((item) => {
                            'product_id': item.product.id,
                            'in_qty': item.count,
                            'notes': item.notes,
                          })
                      .toList()
                };
                EasyLoading.show(status: '加载中...');
                await confirmTransferIn(transfer!.id!, data);
                EasyLoading.showSuccess("入库成功!");
                await transferFetch();
              }),
        ],
      ),
    );
  }
}

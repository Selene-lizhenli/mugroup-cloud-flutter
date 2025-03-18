import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/pages/wms/wms_transfer_confirm/models/state.dart';
import 'package:flant/components/stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class WmsTransferConfirmItem extends HookWidget {
  final TransferConfirmItem item;
  final TextEditingController? notesController;
  final ValueChanged<int>? onCountChange;
  final Function(bool)? onCheckBoxChanged;
  final Function(String)? onNotesChanged;
  final Function()? onNotesClearTap;
  const WmsTransferConfirmItem({
    super.key,
    required this.item,
    this.notesController,
    this.onCheckBoxChanged,
    this.onCountChange,
    this.onNotesChanged,
    this.onNotesClearTap,
  });

  @override
  Widget build(BuildContext context) {
    var cover = item.product.image?.elementAtOrNull(0)?.thumbUrl ??
        item.product.image?.elementAtOrNull(0)?.url;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: TDCheckbox(
                checked: item.checked ?? false,
                onCheckBoxChanged: onCheckBoxChanged,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                        child: Text(
                      '${item.product.nameCn}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${item.inQty}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '/',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${item.outQty}',
                      style: const TextStyle(
                        color: Color(0xFF84868B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cover != null
                          ? CachedNetworkImage(
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                              imageUrl: cover,
                            )
                          : Image.asset(
                              'assets/noImage.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "条形码：",
                                    style: TextStyle(),
                                  ),
                                  Expanded(
                                      child: Text(
                                    item.product.barcode ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  )),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "产品编码：",
                                  ),
                                  Expanded(
                                      child: Text(
                                    item.product.productNo ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      item.product.purchaseCost != null
                                          ? '¥${item.product.purchaseCost}'
                                          : "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style:
                                          const TextStyle(color: Colors.red)),
                                  FlanStepper(
                                    max: item.outQty ?? 0,
                                    min: item.inQty ?? 0,
                                    value: item.count,
                                    onChange: (v, _) {
                                      if (v is int) {
                                        onCountChange?.call(v);
                                      } else {
                                        onCountChange
                                            ?.call(int.parse(v.toString()));
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (item.count < (item.outQty ?? 0) && (item.checked ?? false))
          TDInput(
            leftLabel: '差异说明',
            backgroundColor: Colors.white,
            hintText: '请输入差异说明',
            controller: notesController,
            onChanged: onNotesChanged,
            onClearTap: onNotesClearTap,
          ),
      ],
    );
  }
}

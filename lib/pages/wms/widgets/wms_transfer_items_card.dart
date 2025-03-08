import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/wms/transfer_item.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WmsTransferItemsCard extends HookConsumerWidget {
  final TransferItem? transferItem;

  const WmsTransferItemsCard(this.transferItem, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cover = transferItem!.product?.image?.elementAtOrNull(0)?.thumbUrl;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                    child: Text(
                  '${transferItem?.product?.nameCn}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${transferItem?.inQty}',
                  style: const TextStyle(
                    color: Colors.blue, // 设置颜色
                    fontSize: 18, // 加大字体
                    fontWeight: FontWeight.bold, // 可选，设置加粗
                  ),
                ),
                const Text(
                  '/',
                  style: TextStyle(
                    fontSize: 18, // 同样加大字体
                  ),
                ),
                Text(
                  '${transferItem?.outQty}',
                  style: const TextStyle(
                    color: Color(0xFF84868B), // 设置不同的颜色
                    fontSize: 18, // 加大字体
                    fontWeight: FontWeight.bold, // 可选，设置加粗
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
                              Text(
                                "${transferItem?.product?.barcode}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "产品编码：",
                              ),
                              Text(
                                '${transferItem?.product?.productNo}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "采购单价：",
                              ),
                              Text(
                                '￥${transferItem?.product?.purchaseCost}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

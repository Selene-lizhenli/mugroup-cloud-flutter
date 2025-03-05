import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/wms/inventoryItem.dart';
import 'package:cloud/pages/cart/models/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConfirmItem extends HookWidget {
  final CartItem? item;

  final InventoryItem? inventoryItem;

  const ConfirmItem({
    super.key,
    this.item,
    this.inventoryItem,
  });

  @override
  Widget build(BuildContext context) {
    var cover = item?.sample.image?.elementAtOrNull(0)?.thumbUrl;

    final inventoryQty = inventoryItem?.previousQty ?? 0;
    final newQty = inventoryItem?.newQty ?? 0;

    final prompt = inventoryQty > newQty
        ? '出库'
        : inventoryQty < newQty
            ? '入库'
            : '不操作';

    Color promptColor = Colors.grey;
    String qtySymbol = '';
    if (prompt == '出库') {
      promptColor = Colors.green;
      qtySymbol = '-';
    } else if (prompt == '入库') {
      promptColor = Colors.blue;
      qtySymbol = '+';
    } else if (prompt == '不操作') {
      promptColor = Colors.grey;
      qtySymbol = '';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item?.sample.nameCn ?? "",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        prompt,
                        style: TextStyle(color: promptColor, fontSize: 18),
                      ),
                    ],
                  ),
                  Text(
                    item?.sample.productNo ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    children: [
                      const Text('库存数量:'),
                      Text('$inventoryQty'),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$qtySymbol${(inventoryQty - newQty).abs()}',
                            style: TextStyle(color: promptColor, fontSize: 18),
                          )
                        ],
                      )),
                      const Text('x'),
                      Text('${item?.count}'),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

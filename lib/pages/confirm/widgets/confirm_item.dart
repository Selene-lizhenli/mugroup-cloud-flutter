import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/pages/cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConfirmItem extends HookWidget {
  final CartItem? item;

  const ConfirmItem({super.key, this.item});
  @override
  Widget build(BuildContext context) {
    var cover = item?.sample.image?.elementAtOrNull(0)?.thumbUrl;

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
                      const Text(
                        "出库",
                        style: TextStyle(color: Colors.green, fontSize: 18),
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
                      const Text('20'),
                      const Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '-19',
                            style: TextStyle(color: Colors.green, fontSize: 18),
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

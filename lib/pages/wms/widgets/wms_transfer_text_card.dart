import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WmsTransferTextCard extends HookConsumerWidget {
  final String title;
  final Widget lable;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const WmsTransferTextCard(
      {super.key,
      required this.title,
      required this.lable,
      this.margin,
      this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      margin: margin ?? const EdgeInsets.all(1),
      padding: padding ?? const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        '$title:'),
                  ],
                ),
              )),
          lable,
        ],
      ),
    );
  }
}

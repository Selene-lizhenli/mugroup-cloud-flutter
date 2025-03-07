import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransferTextCard extends HookConsumerWidget {
  final String title;
  final String? lable;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const TransferTextCard(
      {super.key, required this.title, this.lable, this.margin, this.padding});

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
          Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
              lable ?? ""),
        ],
      ),
    );
  }
}

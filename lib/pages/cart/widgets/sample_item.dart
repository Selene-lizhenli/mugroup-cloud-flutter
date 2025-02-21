import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SampleItem extends HookWidget {
  final Sample sample;

  final int? count;

  final ValueChanged<int>? onChange;

  const SampleItem({
    super.key,
    required this.sample,
    this.count,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    var cover = sample.image?.elementAtOrNull(0)?.thumbUrl;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cover != null
            ? CachedNetworkImage(
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                imageUrl: cover,
              )
            : Container(
                width: 100,
                height: 100,
                color: Colors.amber,
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
                Text(
                  sample.nameCn ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("1"),
                    TDStepper(
                      theme: TDStepperTheme.filled,
                      size: TDStepperSize.small,
                      value: count,
                      min: 1,
                      onChange: onChange,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

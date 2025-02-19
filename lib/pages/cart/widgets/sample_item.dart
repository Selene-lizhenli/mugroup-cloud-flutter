import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:flutter/material.dart';

class SampleItem extends StatelessWidget {
  final Sample sample;

  const SampleItem({super.key, required this.sample});

  @override
  Widget build(BuildContext context) {
    var cover = sample.image?[0].thumbUrl;

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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("1"),
                    Text("2"),
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

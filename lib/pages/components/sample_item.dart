import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SampleItem extends StatelessWidget {
  const SampleItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TDImage(
          width: 100,
          height: 100,
          imgUrl:
              "https://s3.woyou.fun:12223/cloud/showroom/sample/2387662/P028525_01_original.jpg",
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
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "全网同 4G 全网同 4G 全网同 4G 全网同 4G 全网同 4G 全网同 4G 全网同 4G ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
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

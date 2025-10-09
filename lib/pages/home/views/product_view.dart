import 'package:cloud/pages/home/widgets/home_app_bar.dart';
import 'package:cloud/pages/home/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductView extends HookConsumerWidget {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeAppBarPlaceholder(),
          Container(
            height: 1,
          ),
          // 产品列表
          Padding(
            padding: const EdgeInsets.all(5),
            child: Wrap(
              spacing: 5, // 水平间距
              runSpacing: 5, // 换行间距
              children: List.generate(6, (index) {
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 15) / 2, // 一行两个
                  child: const ProductCard(),
                );
              }),
            ),
          ),
          Container(
            height: 10,
          )
        ],
      ),
    );
  }
}

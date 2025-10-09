import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/home/widgets/home_app_bar.dart';
import 'package:cloud/pages/home/widgets/product_card.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductView extends HookConsumerWidget {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();
    final samples = useState<List<Sample>>(<Sample>[]);

    init() async {
      final resp = await getSamples();
      samples.value = resp.data;
    }

    useEffect(() {
      init();

      return () {};
    }, []);

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

          MasonryGridView.count(
            crossAxisCount: 2, // 列数
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            itemCount: samples.value.length,
            padding: const EdgeInsets.all(5),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final sample = samples.value[index];
              return ProductCard(sample: sample);
            },
          ),
          Container(
            height: 10,
          )
        ],
      ),
    );
  }
}

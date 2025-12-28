import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/samples/widgets/product_card.dart';
import 'package:cloud/services/sample.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class SupplySupplierDetailSamplePage extends HookConsumerWidget {
  final int id;
  const SupplySupplierDetailSamplePage(
      {super.key, @PathParam.inherit('id') required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final samples = useState(<Sample>[]);
    final page = useRef(1);

    handleRefreshOrLoad({bool refresh = false}) async {
      if (refresh) {
        page.value = 1;
      }

      final resp = await getSamples(
        queryParameters: {
          "page": page.value,
          "supplier_id": id,
        },
      );

      if (refresh) {
        samples.value = resp.data;
      } else {
        samples.value = [...samples.value, ...resp.data];
      }

      if (page.value >= resp.meta!.pagination!.totalPages) {
        return IndicatorResult.noMore;
      }

      page.value = page.value + 1;

      return IndicatorResult.success;
    }

    return EasyRefresh(
      fit: StackFit.loose,
      refreshOnStart: true,
      onRefresh: () async {
        return handleRefreshOrLoad(refresh: true);
      },
      onLoad: () {
        return handleRefreshOrLoad();
      },
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          MultiSliver(
            children: [
              MasonryGridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                itemCount: samples.value.length,
                padding: const EdgeInsets.all(5),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final sample = samples.value[index];

                  return ProductCard(
                    sample: sample,
                  );
                },
              ),
              // TODO: 增加没有产品的提示
            ],
          ),
        ],
      ),
    );
  }
}

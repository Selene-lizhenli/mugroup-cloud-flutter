import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/samples/widgets/product_card.dart';
import 'package:cloud/router/router.gr.dart';
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
    // 增加加载状态，用于控制首次加载时不显示空数据
    final isLoading = useValueNotifier(true);

    var crossAxisCount = 1;
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.size.width > 200) {
      crossAxisCount = 2;
    }
    if (mediaQuery.size.width > 500) {
      crossAxisCount = 3;
    }
    if (mediaQuery.size.width > 800) {
      crossAxisCount = 4;
    }

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

      // 首次加载完成
      isLoading.value = false;

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
              // 核心：判断数据是否为空，显示空数据提示
              if (samples.value.isEmpty && !isLoading.value)
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 500,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "暂无样品数据",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                MasonryGridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  itemCount: samples.value.length,
                  padding: const EdgeInsets.all(5),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final sample = samples.value[index];

                    return ProductCard(
                      sample: sample,
                      onTap: () {
                        context.router.push(
                          ShowroomSampleDetailRoute(
                            id: sample.id!,
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

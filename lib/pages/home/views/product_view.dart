import 'package:cloud/helper/helper.dart';
import 'package:cloud/hooks/hooks.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/home/events/search_event.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/widgets/home_app_bar.dart';
import 'package:cloud/pages/home/widgets/product_card.dart';
import 'package:cloud/services/sample.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const pageSize = 20;

class ProductView extends HookConsumerWidget {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final refreshController = useEasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    final home = ref.watch(homeProvider);
    final search = useState(home.search);
    final page = useState(1);
    final samples = useState<List<Sample>>(<Sample>[]);

    fetchData(String? searchText, {bool? init = false}) async {
      search.value = searchText;
      if (init == true) {
        page.value = 1;
      }

      final resp = await getSamples(queryParameters: {
        "search": searchText,
        "page": page.value + 1,
        "pageSize": pageSize,
      });

      if (init == true) {
        samples.value = resp.data;
      } else {
        samples.value = [...samples.value, ...resp.data];

        if (resp.data.length >= 20) {
          page.value++;
        }
      }

      return resp;
    }

    useEffect(() {
      final searchEventSubscription =
          home.bus.on<SearchEvent>().listen((SearchEvent event) {
        fetchData(event.search, init: true);
      });

      return () {
        searchEventSubscription.cancel();
      };
    }, []);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeAppBarPlaceholder(),
        Expanded(
          child: EasyRefresh(
            controller: refreshController,
            refreshOnStart: true,
            onRefresh: () async {
              await fetchData(search.value, init: true);
              refreshController.finishRefresh();
              refreshController.resetFooter();
            },
            onLoad: () async {
              logger.d('onLoad');
              final resp = await fetchData(search.value);

              refreshController.finishLoad(resp.data.length >= pageSize
                  ? IndicatorResult.success
                  : IndicatorResult.noMore);
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
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
            ),
          ),
        )
      ],
    );
  }
}

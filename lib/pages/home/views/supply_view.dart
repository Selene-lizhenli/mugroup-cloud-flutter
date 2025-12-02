import 'package:cloud/helper/helper.dart';
import 'package:cloud/hooks/hooks.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/home/events/search_event.dart';
import 'package:cloud/pages/home/providers/home_provider.dart';
import 'package:cloud/pages/home/widgets/supplier_card.dart';
import 'package:cloud/services/supply.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const pageSize = 20;

class SupplyView extends HookConsumerWidget {
  const SupplyView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final home = ref.watch(homeProvider);
    final search = useState(home.search);
    final media = useState<TemporaryMedia?>(home.currentMedia);

    final refreshController = useEasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );

    final page = useRef(1);
    final suppliers = useState<List<Supplier>>(<Supplier>[]);

    fetchData(
      String? searchText, {
      bool? init = false,
      TemporaryMedia? searchMedia,
    }) async {
      search.value = searchText;
      media.value = searchMedia;
      if (init == true) {
        page.value = 1;
      }

      final queryParameters = {
        "search": searchText,
        if (searchMedia != null) "image": searchMedia.id,
        "page": page.value,
        "pageSize": pageSize,
      };
      logger.d(queryParameters);
      final resp = await getSupplySuppliers(queryParameters: queryParameters);

      if (init == true) {
        suppliers.value = resp.data;
      } else {
        suppliers.value = [...suppliers.value, ...resp.data];
      }

      if (resp.data.length >= 20) {
        page.value++;
      }

      return resp;
    }

    useEffect(() {
      if (home.currentPage != 1) {
        return null;
      }

      final searchEventSubscription = home.bus.on<SearchEvent>().listen(
        (SearchEvent event) {
          search.value = event.search;
          media.value = event.media;

          refreshController.callRefresh(force: true);
        },
      );

      return () {
        searchEventSubscription.cancel();
      };
    }, [home.currentPage]);

    useUpdateEffect(() {
      if (home.currentPage != 1) {
        return null;
      }

      if ((home.search == search.value) && (home.currentMedia == media.value)) {
        return null;
      }

      search.value = home.search;
      media.value = home.currentMedia;
      refreshController.callRefresh(force: true);

      return null;
    }, [
      home.currentPage,
      home.search,
      home.currentMedia,
      search.value,
      media.value
    ]);

    return EasyRefresh(
      controller: refreshController,
      refreshOnStart: true,
      onRefresh: () async {
        await fetchData(
          search.value,
          init: true,
          searchMedia: media.value,
        );
        refreshController.finishRefresh();
        refreshController.resetFooter();
      },
      onLoad: () async {
        final resp = await fetchData(search.value);

        refreshController.finishLoad(resp.data.length >= pageSize
            ? IndicatorResult.success
            : IndicatorResult.noMore);
      },
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        itemCount: suppliers.value.length,
        padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final supplier = suppliers.value[index];

          return SupplierCard(
            supplier: supplier,
            onClick: () {},
          );
        },
      ),
    );
  }
}

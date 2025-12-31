import 'package:auto_route/auto_route.dart';
import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
import 'package:cloud/models/inspection/inspection.dart';
import 'package:cloud/pages/inspection/widgets/inspection_card.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/inspection.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

const pageSize = 20;

class InspectionView extends HookConsumerWidget {
  const InspectionView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshController = useEasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    final search = useState<String?>(null);
    final page = useRef(1);
    final colorScheme = Theme.of(context).colorScheme;
    final inspections = useState<List<Inspection>>(<Inspection>[]);

    fetchData(
      String? searchText, {
      bool? init = false,
    }) async {
      search.value = searchText;

      if (init == true) {
        page.value = 1;
      }

      final queryParameters = {
        "search": searchText,
        "page": page.value,
        "pageSize": pageSize,
      };
      final resp = await getInspections(queryParameters: queryParameters);

      if (init == true) {
        inspections.value = resp.data;
      } else {
        inspections.value = [...inspections.value, ...resp.data];
      }

      if (resp.data.isNotEmpty) {
        page.value++;
      }

      return resp;
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceTint,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: EasyRefresh(
          controller: refreshController,
          refreshOnStart: true,
          onRefresh: () async {
            try {
              await fetchData(
                search.value,
                init: true,
              );
              refreshController.finishRefresh();
            } catch (e) {
              refreshController.finishRefresh(IndicatorResult.fail, false);
            } finally {
              refreshController.resetFooter();
            }
          },
          onLoad: () async {
            final resp = await fetchData(search.value);

            refreshController.finishLoad(resp.data.length >= pageSize
                ? IndicatorResult.success
                : IndicatorResult.noMore);
          },
          child: CustomScrollView(
            slivers: [
              MultiSliver(
                children: [
                  Container(
                    height: 0,
                  ),
                  if (inspections.value.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          '暂无数据',
                          style: TextStyle(
                            color: colorScheme.surfaceContainerHighest,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  else
                    MasonryGridView.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 0,
                      itemCount: inspections.value.length,
                      padding: const EdgeInsets.all(5),
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final inspection = inspections.value[index];

                        return InspectionCard(
                          inspection: inspection,
                          onTap: () {
                            context.router.push(
                                InspectionDetailRoute(id: inspection.id!));
                          },
                          onDelete: () async {
                            //todo
                          },
                        );
                      },
                    ),
                ],
              )
            ],
          ),
        ));
  }
}

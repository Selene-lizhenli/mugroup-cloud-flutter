import 'package:auto_route/auto_route.dart';
import 'package:cloud/hooks/useEasyRefreshController/hook.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/pages/crm/crm_company/widgets/crm_company_card.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/crm.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const pageSize = 20;

class CompanyView extends HookConsumerWidget {
  const CompanyView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshController = useEasyRefreshController(
        controlFinishLoad: true, controlFinishRefresh: true);
    final search = useState<String?>(null);
    final page = useRef(1);
    final companies = useState<List<Company>>(<Company>[]);

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
      final resp = await getCompanies(queryParameters: queryParameters);

      if (init == true) {
        companies.value = resp.data;
      } else {
        companies.value = [...companies.value, ...resp.data];
      }

      if (resp.data.length >= 20) {
        page.value++;
      }

      return resp;
    }

    return EasyRefresh(
      controller: refreshController,
      refreshOnStart: true,
      onRefresh: () async {
        await fetchData(
          search.value,
          init: true,
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
        itemCount: companies.value.length,
        padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final company = companies.value[index];

          return CrmCompanyCard(
            company: company,
            onTap: () {
              context.router.push(CrmCompanyDetailRoute(id: company.id!));
            },
            onEdit: () {
              context.router.push(CrmCompanyEditRoute(id: company.id!));
            },
          );
        },
      ),
    );
  }
}

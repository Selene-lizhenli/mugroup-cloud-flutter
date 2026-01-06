import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/guards/auth_guard.dart';
import 'package:cloud/pages/quote/batch_import/product_batch_import_page.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.cupertino();

  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        page: Layout.page,
        initial: true,
        guards: [AuthGuard()],
        children: [
          AutoRoute(
            page: DashboardRoute.page,
            initial: true,
            path: 'dashboard',
          ),
        ],
      ),
      AutoRoute(
        page: SamplesRoute.page,
        path: '/samples',
      ),
      AutoRoute(
        page: CartRoute.page,
        path: '/samples/cart',
      ),
      AutoRoute(
        page: SamplesListRoute.page,
        path: '/samples/list',
      ),
      AutoRoute(
        page: MyRoute.page,
        path: "/my",
      ),
      AutoRoute(
        page: SettingRoute.page,
        path: "/setting",
      ),
      AutoRoute(
          page: MarketProductListRoute.page,
          path: "/market_product/market_product_list"),
      AutoRoute(page: InspectionRoute.page, path: "/inspection"),
      AutoRoute(page: InspectionAddRoute.page, path: "/inspection/add"),
      AutoRoute(page: InspectionDetailRoute.page, path: "/inspection/detail"),
      AutoRoute(
          page: InspectionItemConfirmRoute.page,
          path: "/inspection/item/confirm"),
      AutoRoute(
        page: MarketProductRoute.page,
        guards: [AuthGuard()],
        path: '/market_product',
        children: [
          AutoRoute(
            page: MarketProductInfoRoute.page,
            path: "index",
          ),
          AutoRoute(
            page: QuoteRoute.page,
            path: "quotation",
            initial: true,
          ),
        ],
      ),

      AutoRoute(page: LoginRoute.page, path: "/login"),
      AutoRoute(page: ScanRoute.page, path: "/scan"),
      AutoRoute(page: WmsTransferRoute.page, path: "/wms/transfer/:id"),
      AutoRoute(page: WmsDeliveryRoute.page, path: "/wms/delivery/:id"),
      AutoRoute(
          page: ShowroomQuotationsRoute.page,
          path: "/showroom/quotations/:quoteNo"),
      AutoRoute(
          page: ShowroomSampleCreateRoute.page,
          path: "/showroom/sample/create"),
      AutoRoute(
          page: ShowroomSampleEditRoute.page,
          path: "/showroom/sample/edit/:id"),
      AutoRoute(
          page: ShowroomSampleDetailRoute.page,
          path: "/showroom/sample/detail/:id"),
      AutoRoute(page: CrmCompanyCreateRoute.page, path: "/crm/company/create"),
      AutoRoute(page: CrmCompanyRoute.page, path: "/crm/company"),
      AutoRoute(page: CrmCompanyEditRoute.page, path: "/crm/company/edit/:id"),
      AutoRoute(
          page: CrmCompanyDetailRoute.page, path: "/crm/company/detail/:id"),
      AutoRoute(page: CrmContactCreateRoute.page, path: "/crm/contact/create"),
      AutoRoute(page: CrmContactEditRoute.page, path: "/crm/contact/edit/:id"),
      AutoRoute(
          page: SupplySupplierCreateRoute.page,
          path: "/supply/supplier/create"),
      AutoRoute(page: QuoteCreateRoute.page, path: "/quote/create"),
      AutoRoute(page: QuoteDetailRoute.page, path: "/quote/detail/:id/:userId"),
      // AutoRoute(page: QuoteRoute.page, path: "/quote"), //报价单列表页面

      AutoRoute(page: QuoteProductAddRoute.page, path: "/quote/product/add"),
      AutoRoute(
        page: ProductBatchImportRoute.page,
        path: "/quote/product/batch_import",
      ),

      AutoRoute(page: SupplySupplierRoute.page, path: "/supply/supplier"),
      AutoRoute(
          page: SupplySupplierEditRoute.page,
          path: "/supply/supplier/edit/:id"),
      AutoRoute(
          page: SupplySupplierContactCreateRoute.page,
          path: "/supply/supplier/contact/create/:supplierId"),
      AutoRoute(
          page: SupplySupplierContactEditRoute.page,
          path: "/supply/supplier/contact/edit/:id"),
      AutoRoute(
          page: SupplySupplierCertCreateRoute.page,
          path: "/supply/supplier/cert/create/:supplierId"),
      AutoRoute(
          page: SupplySupplierActivityCreateRoute.page,
          path: "/supply/supplier/cert/create/:supplierId"),
      AutoRoute(
        page: SupplySupplierDetailRoute.page,
        guards: [AuthGuard()],
        path: '/supply/supplier/detail/:id',
        children: [
          AutoRoute(
            page: SupplySupplierDetailInfoRoute.page,
            path: "",
          ),
          AutoRoute(
            page: SupplySupplierDetailContactRoute.page,
            path: "contact",
          ),
          AutoRoute(
            page: SupplySupplierDetailSampleRoute.page,
            path: "sample",
          ),
        ],
      ),

      AutoRoute(
          page: WmsTransferConfirmRoute.page,
          path: "/wms/transfer/confirm/:code"),
      // selectors
      AutoRoute(
        page: SelectWmsWarehouseRoute.page,
        path: "/selectors/wms/warehouse",
        guards: [AuthGuard()],
      ),

      AutoRoute(
        page: SelectUserRoute.page,
        path: "/selectors/user",
        guards: [AuthGuard()],
      ),

      AutoRoute(
        page: SelectWmsBorrowRoute.page,
        path: "/selectors/wms/borrow",
        guards: [AuthGuard()],
      ),

      AutoRoute(
        page: ConfirmRoute.page,
        path: "/cart/confirm",
        guards: [AuthGuard()],
      ),

      AutoRoute(
        page: NewsRoute.page,
        path: "/news/detail",
        guards: [AuthGuard()],
      ),
    ];
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:cloud/router/guards/auth_guard.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.custom();

  @override
  List<AutoRoute> get routes {
    return [
      // RedirectRoute(
      //     path: '/', redirectTo: '/supply/supplier/detail/13611/sample'),
      AutoRoute(
        page: Layout.page,
        initial: true,
        guards: [AuthGuard()],
        children: [
          AutoRoute(
            initial: true,
            page: HomeRoute.page,
            path: 'home',
          ),
          AutoRoute(
            page: CartRoute.page,
            path: "cart",
          ),
          AutoRoute(
            page: MyRoute.page,
            path: "my",
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
      AutoRoute(page: CrmCompanyEditRoute.page, path: "/crm/company/edit/:id"),
      AutoRoute(
          page: CrmCompanyDetailRoute.page, path: "/crm/company/detail/:id"),
      AutoRoute(
          page: SupplySupplierCreateRoute.page,
          path: "/supply/supplier/create"),
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
    ];
  }
}

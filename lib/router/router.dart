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
      AutoRoute(
        page: Layout.page,
        initial: true,
        guards: [AuthGuard()],
        children: [
          AutoRoute(
            page: HomeRoute.page,
            path: 'home',
          ),
          AutoRoute(
            initial: true,
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
      AutoRoute(page: WmsTransferRoute.page, path: "/wms/transfer/:code"),
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

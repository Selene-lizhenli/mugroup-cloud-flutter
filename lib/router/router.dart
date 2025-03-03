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
        children: [
          AutoRoute(
            page: HomeRoute.page,
            path: 'home',
            guards: [AuthGuard()],
          ),
          AutoRoute(
            initial: true,
            page: CartRoute.page,
            path: "cart",
            guards: [AuthGuard()],
          ),
          AutoRoute(
            page: MyRoute.page,
            path: "my",
            guards: [AuthGuard()],
          ),
        ],
      ),

      AutoRoute(page: LoginRoute.page, path: "/login"),

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
    ];
  }
}

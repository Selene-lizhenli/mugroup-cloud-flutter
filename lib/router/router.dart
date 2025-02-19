import 'package:auto_route/auto_route.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: HomeRoute.page, path: '/', initial: true),
      AutoRoute(page: CartRoute.page, path: "/cart"),
    ];
  }
}

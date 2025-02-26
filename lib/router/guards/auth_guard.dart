import 'package:auto_route/auto_route.dart';
import 'package:cloud/app/app.dart';
import 'package:cloud/router/router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  bool? loginBack = true;

  AuthGuard({this.loginBack});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final user = await app.user;

    if (user != null) {
      resolver.next();
      return;
    }

    resolver.redirect(
        LoginRoute(onLogin: loginBack == true ? () => resolver.next() : null));
  }
}

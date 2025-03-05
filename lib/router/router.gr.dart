// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:cloud/models/wms/warehouse.dart' as _i11;
import 'package:cloud/pages/cart/cart_page.dart' as _i1;
import 'package:cloud/pages/confirm/confirm_page.dart' as _i2;
import 'package:cloud/pages/home/home_page.dart' as _i3;
import 'package:cloud/pages/layout.dart' as _i4;
import 'package:cloud/pages/login/login_page.dart' as _i5;
import 'package:cloud/pages/my/my_page.dart' as _i6;
import 'package:cloud/pages/selectors/select_user/select_user_page.dart' as _i7;
import 'package:cloud/pages/selectors/select_wms_borrow/select_wms_borrow_page.dart'
    as _i8;
import 'package:cloud/pages/selectors/select_wms_warehouse/select_wms_warehouse_page.dart'
    as _i9;
import 'package:flutter/material.dart' as _i12;

/// generated route for
/// [_i1.CartPage]
class CartRoute extends _i10.PageRouteInfo<void> {
  const CartRoute({List<_i10.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.CartPage();
    },
  );
}

/// generated route for
/// [_i2.ConfirmPage]
class ConfirmRoute extends _i10.PageRouteInfo<ConfirmRouteArgs> {
  ConfirmRoute({
    required List<_i1.CartItem>? items,
    required _i11.Warehouse? warehouse,
    _i12.Key? key,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          ConfirmRoute.name,
          args: ConfirmRouteArgs(
            items: items,
            warehouse: warehouse,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ConfirmRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ConfirmRouteArgs>();
      return _i2.ConfirmPage(
        args.items,
        args.warehouse,
        key: args.key,
      );
    },
  );
}

class ConfirmRouteArgs {
  const ConfirmRouteArgs({
    required this.items,
    required this.warehouse,
    this.key,
  });

  final List<_i1.CartItem>? items;

  final _i11.Warehouse? warehouse;

  final _i12.Key? key;

  @override
  String toString() {
    return 'ConfirmRouteArgs{items: $items, warehouse: $warehouse, key: $key}';
  }
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i10.PageRouteInfo<void> {
  const HomeRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.Layout]
class Layout extends _i10.PageRouteInfo<void> {
  const Layout({List<_i10.PageRouteInfo>? children})
      : super(
          Layout.name,
          initialChildren: children,
        );

  static const String name = 'Layout';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.Layout();
    },
  );
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i10.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i12.Key? key,
    void Function()? onLogin,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onLogin: onLogin,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LoginRouteArgs>(orElse: () => const LoginRouteArgs());
      return _i5.LoginPage(
        key: args.key,
        onLogin: args.onLogin,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.onLogin,
  });

  final _i12.Key? key;

  final void Function()? onLogin;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLogin: $onLogin}';
  }
}

/// generated route for
/// [_i6.MyPage]
class MyRoute extends _i10.PageRouteInfo<void> {
  const MyRoute({List<_i10.PageRouteInfo>? children})
      : super(
          MyRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.MyPage();
    },
  );
}

/// generated route for
/// [_i7.SelectUserPage]
class SelectUserRoute extends _i10.PageRouteInfo<void> {
  const SelectUserRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SelectUserRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectUserRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.SelectUserPage();
    },
  );
}

/// generated route for
/// [_i8.SelectWmsBorrowPage]
class SelectWmsBorrowRoute extends _i10.PageRouteInfo<void> {
  const SelectWmsBorrowRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SelectWmsBorrowRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsBorrowRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i8.SelectWmsBorrowPage();
    },
  );
}

/// generated route for
/// [_i9.SelectWmsWarehousePage]
class SelectWmsWarehouseRoute extends _i10.PageRouteInfo<void> {
  const SelectWmsWarehouseRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SelectWmsWarehouseRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsWarehouseRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.SelectWmsWarehousePage();
    },
  );
}

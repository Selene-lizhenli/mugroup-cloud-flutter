// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i27;
import 'package:cloud/models/wms/warehouse.dart' as _i29;
import 'package:cloud/pages/cart/cart_page.dart' as _i1;
import 'package:cloud/pages/cart/confirm/confirm_page.dart' as _i2;
import 'package:cloud/pages/cart/models/state.dart' as _i28;
import 'package:cloud/pages/crm/crm_company/crm_company_create_page.dart'
    as _i3;
import 'package:cloud/pages/crm/crm_company/crm_company_detail_page.dart'
    as _i4;
import 'package:cloud/pages/crm/crm_company/crm_company_edit_page.dart' as _i5;
import 'package:cloud/pages/crm/crm_company/crm_company_page.dart' as _i6;
import 'package:cloud/pages/home/home_page.dart' as _i7;
import 'package:cloud/pages/layout.dart' as _i8;
import 'package:cloud/pages/login/login_page.dart' as _i9;
import 'package:cloud/pages/my/my_page.dart' as _i10;
import 'package:cloud/pages/scan/scan_page.dart' as _i11;
import 'package:cloud/pages/selectors/select_user/select_user_page.dart'
    as _i12;
import 'package:cloud/pages/selectors/select_wms_borrow/select_wms_borrow_page.dart'
    as _i13;
import 'package:cloud/pages/selectors/select_wms_warehouse/select_wms_warehouse_page.dart'
    as _i14;
import 'package:cloud/pages/showroom/showroom_quotations_page.dart' as _i15;
import 'package:cloud/pages/showroom/showroom_sample_create_page.dart' as _i16;
import 'package:cloud/pages/showroom/showroom_sample_detail_page.dart' as _i17;
import 'package:cloud/pages/showroom/showroom_sample_edit_page.dart' as _i18;
import 'package:cloud/pages/supply/supply_supplier_create_page.dart' as _i19;
import 'package:cloud/pages/supply/supply_supplier_detail/supply_supplier_detail_page.dart'
    as _i22;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/contact.dart'
    as _i20;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/info.dart'
    as _i21;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/sample.dart'
    as _i23;
import 'package:cloud/pages/wms/wms_delivery_page.dart' as _i24;
import 'package:cloud/pages/wms/wms_transfer_confirm/wms_transfer_confirm_page.dart'
    as _i25;
import 'package:cloud/pages/wms/wms_transfer_page.dart' as _i26;
import 'package:flutter/material.dart' as _i30;

/// generated route for
/// [_i1.CartPage]
class CartRoute extends _i27.PageRouteInfo<void> {
  const CartRoute({List<_i27.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i1.CartPage();
    },
  );
}

/// generated route for
/// [_i2.ConfirmPage]
class ConfirmRoute extends _i27.PageRouteInfo<ConfirmRouteArgs> {
  ConfirmRoute({
    required List<_i28.CartItem>? items,
    required _i29.Warehouse? warehouse,
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
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

  static _i27.PageInfo page = _i27.PageInfo(
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

  final List<_i28.CartItem>? items;

  final _i29.Warehouse? warehouse;

  final _i30.Key? key;

  @override
  String toString() {
    return 'ConfirmRouteArgs{items: $items, warehouse: $warehouse, key: $key}';
  }
}

/// generated route for
/// [_i3.CrmCompanyCreatePage]
class CrmCompanyCreateRoute extends _i27.PageRouteInfo<void> {
  const CrmCompanyCreateRoute({List<_i27.PageRouteInfo>? children})
      : super(
          CrmCompanyCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'CrmCompanyCreateRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i3.CrmCompanyCreatePage();
    },
  );
}

/// generated route for
/// [_i4.CrmCompanyDetailPage]
class CrmCompanyDetailRoute
    extends _i27.PageRouteInfo<CrmCompanyDetailRouteArgs> {
  CrmCompanyDetailRoute({
    _i30.Key? key,
    required int id,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          CrmCompanyDetailRoute.name,
          args: CrmCompanyDetailRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmCompanyDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CrmCompanyDetailRouteArgs>();
      return _i4.CrmCompanyDetailPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class CrmCompanyDetailRouteArgs {
  const CrmCompanyDetailRouteArgs({
    this.key,
    required this.id,
  });

  final _i30.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmCompanyDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i5.CrmCompanyEditPage]
class CrmCompanyEditRoute extends _i27.PageRouteInfo<CrmCompanyEditRouteArgs> {
  CrmCompanyEditRoute({
    _i30.Key? key,
    required int id,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          CrmCompanyEditRoute.name,
          args: CrmCompanyEditRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmCompanyEditRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CrmCompanyEditRouteArgs>();
      return _i5.CrmCompanyEditPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class CrmCompanyEditRouteArgs {
  const CrmCompanyEditRouteArgs({
    this.key,
    required this.id,
  });

  final _i30.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmCompanyEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i6.CrmCompanyPage]
class CrmCompanyRoute extends _i27.PageRouteInfo<void> {
  const CrmCompanyRoute({List<_i27.PageRouteInfo>? children})
      : super(
          CrmCompanyRoute.name,
          initialChildren: children,
        );

  static const String name = 'CrmCompanyRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i6.CrmCompanyPage();
    },
  );
}

/// generated route for
/// [_i7.HomePage]
class HomeRoute extends _i27.PageRouteInfo<void> {
  const HomeRoute({List<_i27.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomePage();
    },
  );
}

/// generated route for
/// [_i8.Layout]
class Layout extends _i27.PageRouteInfo<void> {
  const Layout({List<_i27.PageRouteInfo>? children})
      : super(
          Layout.name,
          initialChildren: children,
        );

  static const String name = 'Layout';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i8.Layout();
    },
  );
}

/// generated route for
/// [_i9.LoginPage]
class LoginRoute extends _i27.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i30.Key? key,
    void Function()? onLogin,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onLogin: onLogin,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LoginRouteArgs>(orElse: () => const LoginRouteArgs());
      return _i9.LoginPage(
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

  final _i30.Key? key;

  final void Function()? onLogin;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLogin: $onLogin}';
  }
}

/// generated route for
/// [_i10.MyPage]
class MyRoute extends _i27.PageRouteInfo<void> {
  const MyRoute({List<_i27.PageRouteInfo>? children})
      : super(
          MyRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i10.MyPage();
    },
  );
}

/// generated route for
/// [_i11.ScanPage]
class ScanRoute extends _i27.PageRouteInfo<void> {
  const ScanRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ScanRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScanRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i11.ScanPage();
    },
  );
}

/// generated route for
/// [_i12.SelectUserPage]
class SelectUserRoute extends _i27.PageRouteInfo<void> {
  const SelectUserRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SelectUserRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectUserRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i12.SelectUserPage();
    },
  );
}

/// generated route for
/// [_i13.SelectWmsBorrowPage]
class SelectWmsBorrowRoute extends _i27.PageRouteInfo<void> {
  const SelectWmsBorrowRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SelectWmsBorrowRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsBorrowRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i13.SelectWmsBorrowPage();
    },
  );
}

/// generated route for
/// [_i14.SelectWmsWarehousePage]
class SelectWmsWarehouseRoute extends _i27.PageRouteInfo<void> {
  const SelectWmsWarehouseRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SelectWmsWarehouseRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsWarehouseRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i14.SelectWmsWarehousePage();
    },
  );
}

/// generated route for
/// [_i15.ShowroomQuotationsPage]
class ShowroomQuotationsRoute
    extends _i27.PageRouteInfo<ShowroomQuotationsRouteArgs> {
  ShowroomQuotationsRoute({
    _i30.Key? key,
    required String quoteNo,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          ShowroomQuotationsRoute.name,
          args: ShowroomQuotationsRouteArgs(
            key: key,
            quoteNo: quoteNo,
          ),
          rawPathParams: {'quoteNo': quoteNo},
          initialChildren: children,
        );

  static const String name = 'ShowroomQuotationsRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomQuotationsRouteArgs>(
          orElse: () => ShowroomQuotationsRouteArgs(
              quoteNo: pathParams.getString('quoteNo')));
      return _i15.ShowroomQuotationsPage(
        key: args.key,
        quoteNo: args.quoteNo,
      );
    },
  );
}

class ShowroomQuotationsRouteArgs {
  const ShowroomQuotationsRouteArgs({
    this.key,
    required this.quoteNo,
  });

  final _i30.Key? key;

  final String quoteNo;

  @override
  String toString() {
    return 'ShowroomQuotationsRouteArgs{key: $key, quoteNo: $quoteNo}';
  }
}

/// generated route for
/// [_i16.ShowroomSampleCreatePage]
class ShowroomSampleCreateRoute extends _i27.PageRouteInfo<void> {
  const ShowroomSampleCreateRoute({List<_i27.PageRouteInfo>? children})
      : super(
          ShowroomSampleCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShowroomSampleCreateRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i16.ShowroomSampleCreatePage();
    },
  );
}

/// generated route for
/// [_i17.ShowroomSampleDetailPage]
class ShowroomSampleDetailRoute
    extends _i27.PageRouteInfo<ShowroomSampleDetailRouteArgs> {
  ShowroomSampleDetailRoute({
    _i30.Key? key,
    required int id,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          ShowroomSampleDetailRoute.name,
          args: ShowroomSampleDetailRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ShowroomSampleDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomSampleDetailRouteArgs>(
          orElse: () =>
              ShowroomSampleDetailRouteArgs(id: pathParams.getInt('id')));
      return _i17.ShowroomSampleDetailPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class ShowroomSampleDetailRouteArgs {
  const ShowroomSampleDetailRouteArgs({
    this.key,
    required this.id,
  });

  final _i30.Key? key;

  final int id;

  @override
  String toString() {
    return 'ShowroomSampleDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i18.ShowroomSampleEditPage]
class ShowroomSampleEditRoute
    extends _i27.PageRouteInfo<ShowroomSampleEditRouteArgs> {
  ShowroomSampleEditRoute({
    _i30.Key? key,
    required int id,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          ShowroomSampleEditRoute.name,
          args: ShowroomSampleEditRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ShowroomSampleEditRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomSampleEditRouteArgs>(
          orElse: () =>
              ShowroomSampleEditRouteArgs(id: pathParams.getInt('id')));
      return _i18.ShowroomSampleEditPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class ShowroomSampleEditRouteArgs {
  const ShowroomSampleEditRouteArgs({
    this.key,
    required this.id,
  });

  final _i30.Key? key;

  final int id;

  @override
  String toString() {
    return 'ShowroomSampleEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i19.SupplySupplierCreatePage]
class SupplySupplierCreateRoute extends _i27.PageRouteInfo<void> {
  const SupplySupplierCreateRoute({List<_i27.PageRouteInfo>? children})
      : super(
          SupplySupplierCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupplySupplierCreateRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      return const _i19.SupplySupplierCreatePage();
    },
  );
}

/// generated route for
/// [_i20.SupplySupplierDetailContactPage]
class SupplySupplierDetailContactRoute
    extends _i27.PageRouteInfo<SupplySupplierDetailContactRouteArgs> {
  SupplySupplierDetailContactRoute({
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailContactRoute.name,
          args: SupplySupplierDetailContactRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailContactRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailContactRouteArgs>(
          orElse: () => SupplySupplierDetailContactRouteArgs());
      return _i20.SupplySupplierDetailContactPage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailContactRouteArgs {
  const SupplySupplierDetailContactRouteArgs({this.key});

  final _i30.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailContactRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i21.SupplySupplierDetailInfoPage]
class SupplySupplierDetailInfoRoute
    extends _i27.PageRouteInfo<SupplySupplierDetailInfoRouteArgs> {
  SupplySupplierDetailInfoRoute({
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailInfoRoute.name,
          args: SupplySupplierDetailInfoRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailInfoRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailInfoRouteArgs>(
          orElse: () => SupplySupplierDetailInfoRouteArgs());
      return _i21.SupplySupplierDetailInfoPage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailInfoRouteArgs {
  const SupplySupplierDetailInfoRouteArgs({this.key});

  final _i30.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailInfoRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i22.SupplySupplierDetailPage]
class SupplySupplierDetailRoute
    extends _i27.PageRouteInfo<SupplySupplierDetailRouteArgs> {
  SupplySupplierDetailRoute({
    _i30.Key? key,
    required int id,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailRoute.name,
          args: SupplySupplierDetailRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailRouteArgs>(
          orElse: () =>
              SupplySupplierDetailRouteArgs(id: pathParams.getInt('id')));
      return _i22.SupplySupplierDetailPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class SupplySupplierDetailRouteArgs {
  const SupplySupplierDetailRouteArgs({
    this.key,
    required this.id,
  });

  final _i30.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i23.SupplySupplierDetailSamplePage]
class SupplySupplierDetailSampleRoute
    extends _i27.PageRouteInfo<SupplySupplierDetailSampleRouteArgs> {
  SupplySupplierDetailSampleRoute({
    _i30.Key? key,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailSampleRoute.name,
          args: SupplySupplierDetailSampleRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailSampleRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailSampleRouteArgs>(
          orElse: () => SupplySupplierDetailSampleRouteArgs());
      return _i23.SupplySupplierDetailSamplePage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailSampleRouteArgs {
  const SupplySupplierDetailSampleRouteArgs({this.key});

  final _i30.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailSampleRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i24.WmsDeliveryPage]
class WmsDeliveryRoute extends _i27.PageRouteInfo<WmsDeliveryRouteArgs> {
  WmsDeliveryRoute({
    _i30.Key? key,
    required String code,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          WmsDeliveryRoute.name,
          args: WmsDeliveryRouteArgs(
            key: key,
            code: code,
          ),
          rawPathParams: {'code': code},
          initialChildren: children,
        );

  static const String name = 'WmsDeliveryRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsDeliveryRouteArgs>(
          orElse: () =>
              WmsDeliveryRouteArgs(code: pathParams.getString('code')));
      return _i24.WmsDeliveryPage(
        key: args.key,
        code: args.code,
      );
    },
  );
}

class WmsDeliveryRouteArgs {
  const WmsDeliveryRouteArgs({
    this.key,
    required this.code,
  });

  final _i30.Key? key;

  final String code;

  @override
  String toString() {
    return 'WmsDeliveryRouteArgs{key: $key, code: $code}';
  }
}

/// generated route for
/// [_i25.WmsTransferConfirmPage]
class WmsTransferConfirmRoute
    extends _i27.PageRouteInfo<WmsTransferConfirmRouteArgs> {
  WmsTransferConfirmRoute({
    _i30.Key? key,
    required int id,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          WmsTransferConfirmRoute.name,
          args: WmsTransferConfirmRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'WmsTransferConfirmRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsTransferConfirmRouteArgs>(
          orElse: () =>
              WmsTransferConfirmRouteArgs(id: pathParams.getInt('id')));
      return _i25.WmsTransferConfirmPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class WmsTransferConfirmRouteArgs {
  const WmsTransferConfirmRouteArgs({
    this.key,
    required this.id,
  });

  final _i30.Key? key;

  final int id;

  @override
  String toString() {
    return 'WmsTransferConfirmRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i26.WmsTransferPage]
class WmsTransferRoute extends _i27.PageRouteInfo<WmsTransferRouteArgs> {
  WmsTransferRoute({
    _i30.Key? key,
    required String code,
    List<_i27.PageRouteInfo>? children,
  }) : super(
          WmsTransferRoute.name,
          args: WmsTransferRouteArgs(
            key: key,
            code: code,
          ),
          rawPathParams: {'code': code},
          initialChildren: children,
        );

  static const String name = 'WmsTransferRoute';

  static _i27.PageInfo page = _i27.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsTransferRouteArgs>(
          orElse: () =>
              WmsTransferRouteArgs(code: pathParams.getString('code')));
      return _i26.WmsTransferPage(
        key: args.key,
        code: args.code,
      );
    },
  );
}

class WmsTransferRouteArgs {
  const WmsTransferRouteArgs({
    this.key,
    required this.code,
  });

  final _i30.Key? key;

  final String code;

  @override
  String toString() {
    return 'WmsTransferRouteArgs{key: $key, code: $code}';
  }
}

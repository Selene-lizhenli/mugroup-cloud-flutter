// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i35;
import 'package:cloud/models/wms/warehouse.dart' as _i37;
import 'package:cloud/pages/cart/cart_page.dart' as _i1;
import 'package:cloud/pages/cart/confirm/confirm_page.dart' as _i2;
import 'package:cloud/pages/cart/models/state.dart' as _i36;
import 'package:cloud/pages/crm/crm_company/crm_company_create_page.dart'
    as _i3;
import 'package:cloud/pages/crm/crm_company/crm_company_detail_page.dart'
    as _i4;
import 'package:cloud/pages/crm/crm_company/crm_company_edit_page.dart' as _i5;
import 'package:cloud/pages/crm/crm_company/crm_company_page.dart' as _i6;
import 'package:cloud/pages/layout.dart' as _i7;
import 'package:cloud/pages/login/login_page.dart' as _i8;
import 'package:cloud/pages/my/my_page.dart' as _i9;
import 'package:cloud/pages/quote/quote_create_page.dart' as _i10;
import 'package:cloud/pages/quote/quote_detail/quote_detail_page.dart' as _i11;
import 'package:cloud/pages/quote/quote_detail/tabs/info.dart' as _i27;
import 'package:cloud/pages/quote/quote_page.dart' as _i12;
import 'package:cloud/pages/scan/scan_page.dart' as _i13;
import 'package:cloud/pages/selectors/select_user/select_user_page.dart'
    as _i14;
import 'package:cloud/pages/selectors/select_wms_borrow/select_wms_borrow_page.dart'
    as _i15;
import 'package:cloud/pages/selectors/select_wms_warehouse/select_wms_warehouse_page.dart'
    as _i16;
import 'package:cloud/pages/showroom/showroom_quotations_page.dart' as _i17;
import 'package:cloud/pages/showroom/showroom_sample_create_page.dart' as _i18;
import 'package:cloud/pages/showroom/showroom_sample_detail_page/showroom_sample_detail_page.dart'
    as _i19;
import 'package:cloud/pages/showroom/showroom_sample_edit_page.dart' as _i20;
import 'package:cloud/pages/supply/supply_supplier_activity/supply_supplier_activity_create_page.dart'
    as _i21;
import 'package:cloud/pages/supply/supply_supplier_cert/supply_supplier_cert_create_page.dart'
    as _i22;
import 'package:cloud/pages/supply/supply_supplier_contact/supply_supplier_contact_create_page.dart'
    as _i23;
import 'package:cloud/pages/supply/supply_supplier_contact/supply_supplier_contact_edit_page.dart'
    as _i24;
import 'package:cloud/pages/supply/supply_supplier_create_page.dart' as _i25;
import 'package:cloud/pages/supply/supply_supplier_detail/supply_supplier_detail_page.dart'
    as _i28;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/contact.dart'
    as _i26;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/sample.dart'
    as _i29;
import 'package:cloud/pages/supply/supply_supplier_edit_page.dart' as _i30;
import 'package:cloud/pages/supply/supply_supplier_page.dart' as _i31;
import 'package:cloud/pages/wms/wms_delivery_page.dart' as _i32;
import 'package:cloud/pages/wms/wms_transfer_confirm/wms_transfer_confirm_page.dart'
    as _i33;
import 'package:cloud/pages/wms/wms_transfer_page.dart' as _i34;
import 'package:flutter/material.dart' as _i38;

/// generated route for
/// [_i1.CartPage]
class CartRoute extends _i35.PageRouteInfo<void> {
  const CartRoute({List<_i35.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i1.CartPage();
    },
  );
}

/// generated route for
/// [_i2.ConfirmPage]
class ConfirmRoute extends _i35.PageRouteInfo<ConfirmRouteArgs> {
  ConfirmRoute({
    required List<_i36.CartItem>? items,
    required _i37.Warehouse? warehouse,
    _i38.Key? key,
    List<_i35.PageRouteInfo>? children,
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

  static _i35.PageInfo page = _i35.PageInfo(
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

  final List<_i36.CartItem>? items;

  final _i37.Warehouse? warehouse;

  final _i38.Key? key;

  @override
  String toString() {
    return 'ConfirmRouteArgs{items: $items, warehouse: $warehouse, key: $key}';
  }
}

/// generated route for
/// [_i3.CrmCompanyCreatePage]
class CrmCompanyCreateRoute extends _i35.PageRouteInfo<void> {
  const CrmCompanyCreateRoute({List<_i35.PageRouteInfo>? children})
      : super(
          CrmCompanyCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'CrmCompanyCreateRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i3.CrmCompanyCreatePage();
    },
  );
}

/// generated route for
/// [_i4.CrmCompanyDetailPage]
class CrmCompanyDetailRoute
    extends _i35.PageRouteInfo<CrmCompanyDetailRouteArgs> {
  CrmCompanyDetailRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          CrmCompanyDetailRoute.name,
          args: CrmCompanyDetailRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmCompanyDetailRoute';

  static _i35.PageInfo page = _i35.PageInfo(
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

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmCompanyDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i5.CrmCompanyEditPage]
class CrmCompanyEditRoute extends _i35.PageRouteInfo<CrmCompanyEditRouteArgs> {
  CrmCompanyEditRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          CrmCompanyEditRoute.name,
          args: CrmCompanyEditRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmCompanyEditRoute';

  static _i35.PageInfo page = _i35.PageInfo(
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

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmCompanyEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i6.CrmCompanyPage]
class CrmCompanyRoute extends _i35.PageRouteInfo<void> {
  const CrmCompanyRoute({List<_i35.PageRouteInfo>? children})
      : super(
          CrmCompanyRoute.name,
          initialChildren: children,
        );

  static const String name = 'CrmCompanyRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i6.CrmCompanyPage();
    },
  );
}

/// generated route for
/// [_i7.Layout]
class Layout extends _i35.PageRouteInfo<void> {
  const Layout({List<_i35.PageRouteInfo>? children})
      : super(
          Layout.name,
          initialChildren: children,
        );

  static const String name = 'Layout';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i7.Layout();
    },
  );
}

/// generated route for
/// [_i8.LoginPage]
class LoginRoute extends _i35.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i38.Key? key,
    void Function()? onLogin,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onLogin: onLogin,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LoginRouteArgs>(orElse: () => const LoginRouteArgs());
      return _i8.LoginPage(
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

  final _i38.Key? key;

  final void Function()? onLogin;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLogin: $onLogin}';
  }
}

/// generated route for
/// [_i9.MyPage]
class MyRoute extends _i35.PageRouteInfo<void> {
  const MyRoute({List<_i35.PageRouteInfo>? children})
      : super(
          MyRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i9.MyPage();
    },
  );
}

/// generated route for
/// [_i10.QuoteCreatePage]
class QuoteCreateRoute extends _i35.PageRouteInfo<void> {
  const QuoteCreateRoute({List<_i35.PageRouteInfo>? children})
      : super(
          QuoteCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuoteCreateRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i10.QuoteCreatePage();
    },
  );
}

/// generated route for
/// [_i11.QuoteDetailPage]
class QuoteDetailRoute extends _i35.PageRouteInfo<QuoteDetailRouteArgs> {
  QuoteDetailRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          QuoteDetailRoute.name,
          args: QuoteDetailRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'QuoteDetailRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<QuoteDetailRouteArgs>(
          orElse: () => QuoteDetailRouteArgs(id: pathParams.getInt('id')));
      return _i11.QuoteDetailPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class QuoteDetailRouteArgs {
  const QuoteDetailRouteArgs({
    this.key,
    required this.id,
  });

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'QuoteDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i12.QuotePage]
class QuoteRoute extends _i35.PageRouteInfo<void> {
  const QuoteRoute({List<_i35.PageRouteInfo>? children})
      : super(
          QuoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuoteRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i12.QuotePage();
    },
  );
}

/// generated route for
/// [_i13.ScanPage]
class ScanRoute extends _i35.PageRouteInfo<void> {
  const ScanRoute({List<_i35.PageRouteInfo>? children})
      : super(
          ScanRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScanRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i13.ScanPage();
    },
  );
}

/// generated route for
/// [_i14.SelectUserPage]
class SelectUserRoute extends _i35.PageRouteInfo<void> {
  const SelectUserRoute({List<_i35.PageRouteInfo>? children})
      : super(
          SelectUserRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectUserRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i14.SelectUserPage();
    },
  );
}

/// generated route for
/// [_i15.SelectWmsBorrowPage]
class SelectWmsBorrowRoute extends _i35.PageRouteInfo<void> {
  const SelectWmsBorrowRoute({List<_i35.PageRouteInfo>? children})
      : super(
          SelectWmsBorrowRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsBorrowRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i15.SelectWmsBorrowPage();
    },
  );
}

/// generated route for
/// [_i16.SelectWmsWarehousePage]
class SelectWmsWarehouseRoute extends _i35.PageRouteInfo<void> {
  const SelectWmsWarehouseRoute({List<_i35.PageRouteInfo>? children})
      : super(
          SelectWmsWarehouseRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsWarehouseRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i16.SelectWmsWarehousePage();
    },
  );
}

/// generated route for
/// [_i17.ShowroomQuotationsPage]
class ShowroomQuotationsRoute
    extends _i35.PageRouteInfo<ShowroomQuotationsRouteArgs> {
  ShowroomQuotationsRoute({
    _i38.Key? key,
    required String quoteNo,
    List<_i35.PageRouteInfo>? children,
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

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomQuotationsRouteArgs>(
          orElse: () => ShowroomQuotationsRouteArgs(
              quoteNo: pathParams.getString('quoteNo')));
      return _i17.ShowroomQuotationsPage(
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

  final _i38.Key? key;

  final String quoteNo;

  @override
  String toString() {
    return 'ShowroomQuotationsRouteArgs{key: $key, quoteNo: $quoteNo}';
  }
}

/// generated route for
/// [_i18.ShowroomSampleCreatePage]
class ShowroomSampleCreateRoute extends _i35.PageRouteInfo<void> {
  const ShowroomSampleCreateRoute({List<_i35.PageRouteInfo>? children})
      : super(
          ShowroomSampleCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShowroomSampleCreateRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i18.ShowroomSampleCreatePage();
    },
  );
}

/// generated route for
/// [_i19.ShowroomSampleDetailPage]
class ShowroomSampleDetailRoute
    extends _i35.PageRouteInfo<ShowroomSampleDetailRouteArgs> {
  ShowroomSampleDetailRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
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

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomSampleDetailRouteArgs>(
          orElse: () =>
              ShowroomSampleDetailRouteArgs(id: pathParams.getInt('id')));
      return _i19.ShowroomSampleDetailPage(
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

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'ShowroomSampleDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i20.ShowroomSampleEditPage]
class ShowroomSampleEditRoute
    extends _i35.PageRouteInfo<ShowroomSampleEditRouteArgs> {
  ShowroomSampleEditRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
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

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomSampleEditRouteArgs>(
          orElse: () =>
              ShowroomSampleEditRouteArgs(id: pathParams.getInt('id')));
      return _i20.ShowroomSampleEditPage(
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

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'ShowroomSampleEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i21.SupplySupplierActivityCreatePage]
class SupplySupplierActivityCreateRoute
    extends _i35.PageRouteInfo<SupplySupplierActivityCreateRouteArgs> {
  SupplySupplierActivityCreateRoute({
    _i38.Key? key,
    required int supplierId,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          SupplySupplierActivityCreateRoute.name,
          args: SupplySupplierActivityCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierActivityCreateRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierActivityCreateRouteArgs>();
      return _i21.SupplySupplierActivityCreatePage(
        key: args.key,
        supplierId: args.supplierId,
      );
    },
  );
}

class SupplySupplierActivityCreateRouteArgs {
  const SupplySupplierActivityCreateRouteArgs({
    this.key,
    required this.supplierId,
  });

  final _i38.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierActivityCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i22.SupplySupplierCertCreatePage]
class SupplySupplierCertCreateRoute
    extends _i35.PageRouteInfo<SupplySupplierCertCreateRouteArgs> {
  SupplySupplierCertCreateRoute({
    _i38.Key? key,
    required int supplierId,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          SupplySupplierCertCreateRoute.name,
          args: SupplySupplierCertCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierCertCreateRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierCertCreateRouteArgs>();
      return _i22.SupplySupplierCertCreatePage(
        key: args.key,
        supplierId: args.supplierId,
      );
    },
  );
}

class SupplySupplierCertCreateRouteArgs {
  const SupplySupplierCertCreateRouteArgs({
    this.key,
    required this.supplierId,
  });

  final _i38.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierCertCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i23.SupplySupplierContactCreatePage]
class SupplySupplierContactCreateRoute
    extends _i35.PageRouteInfo<SupplySupplierContactCreateRouteArgs> {
  SupplySupplierContactCreateRoute({
    _i38.Key? key,
    required int supplierId,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          SupplySupplierContactCreateRoute.name,
          args: SupplySupplierContactCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierContactCreateRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierContactCreateRouteArgs>();
      return _i23.SupplySupplierContactCreatePage(
        key: args.key,
        supplierId: args.supplierId,
      );
    },
  );
}

class SupplySupplierContactCreateRouteArgs {
  const SupplySupplierContactCreateRouteArgs({
    this.key,
    required this.supplierId,
  });

  final _i38.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierContactCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i24.SupplySupplierContactEditPage]
class SupplySupplierContactEditRoute
    extends _i35.PageRouteInfo<SupplySupplierContactEditRouteArgs> {
  SupplySupplierContactEditRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          SupplySupplierContactEditRoute.name,
          args: SupplySupplierContactEditRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'SupplySupplierContactEditRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierContactEditRouteArgs>(
          orElse: () =>
              SupplySupplierContactEditRouteArgs(id: pathParams.getInt('id')));
      return _i24.SupplySupplierContactEditPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class SupplySupplierContactEditRouteArgs {
  const SupplySupplierContactEditRouteArgs({
    this.key,
    required this.id,
  });

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierContactEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i25.SupplySupplierCreatePage]
class SupplySupplierCreateRoute extends _i35.PageRouteInfo<void> {
  const SupplySupplierCreateRoute({List<_i35.PageRouteInfo>? children})
      : super(
          SupplySupplierCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupplySupplierCreateRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i25.SupplySupplierCreatePage();
    },
  );
}

/// generated route for
/// [_i26.SupplySupplierDetailContactPage]
class SupplySupplierDetailContactRoute
    extends _i35.PageRouteInfo<SupplySupplierDetailContactRouteArgs> {
  SupplySupplierDetailContactRoute({
    _i38.Key? key,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailContactRoute.name,
          args: SupplySupplierDetailContactRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailContactRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailContactRouteArgs>(
          orElse: () => SupplySupplierDetailContactRouteArgs());
      return _i26.SupplySupplierDetailContactPage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailContactRouteArgs {
  const SupplySupplierDetailContactRouteArgs({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailContactRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i27.SupplySupplierDetailInfoPage]
class SupplySupplierDetailInfoRoute
    extends _i35.PageRouteInfo<SupplySupplierDetailInfoRouteArgs> {
  SupplySupplierDetailInfoRoute({
    _i38.Key? key,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailInfoRoute.name,
          args: SupplySupplierDetailInfoRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailInfoRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailInfoRouteArgs>(
          orElse: () => SupplySupplierDetailInfoRouteArgs());
      return _i27.SupplySupplierDetailInfoPage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailInfoRouteArgs {
  const SupplySupplierDetailInfoRouteArgs({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailInfoRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i28.SupplySupplierDetailPage]
class SupplySupplierDetailRoute
    extends _i35.PageRouteInfo<SupplySupplierDetailRouteArgs> {
  SupplySupplierDetailRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
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

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailRouteArgs>(
          orElse: () =>
              SupplySupplierDetailRouteArgs(id: pathParams.getInt('id')));
      return _i28.SupplySupplierDetailPage(
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

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i29.SupplySupplierDetailSamplePage]
class SupplySupplierDetailSampleRoute
    extends _i35.PageRouteInfo<SupplySupplierDetailSampleRouteArgs> {
  SupplySupplierDetailSampleRoute({
    _i38.Key? key,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailSampleRoute.name,
          args: SupplySupplierDetailSampleRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailSampleRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailSampleRouteArgs>(
          orElse: () => SupplySupplierDetailSampleRouteArgs());
      return _i29.SupplySupplierDetailSamplePage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailSampleRouteArgs {
  const SupplySupplierDetailSampleRouteArgs({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailSampleRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i30.SupplySupplierEditPage]
class SupplySupplierEditRoute
    extends _i35.PageRouteInfo<SupplySupplierEditRouteArgs> {
  SupplySupplierEditRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
  }) : super(
          SupplySupplierEditRoute.name,
          args: SupplySupplierEditRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'SupplySupplierEditRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierEditRouteArgs>(
          orElse: () =>
              SupplySupplierEditRouteArgs(id: pathParams.getInt('id')));
      return _i30.SupplySupplierEditPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class SupplySupplierEditRouteArgs {
  const SupplySupplierEditRouteArgs({
    this.key,
    required this.id,
  });

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i31.SupplySupplierPage]
class SupplySupplierRoute extends _i35.PageRouteInfo<void> {
  const SupplySupplierRoute({List<_i35.PageRouteInfo>? children})
      : super(
          SupplySupplierRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupplySupplierRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i31.SupplySupplierPage();
    },
  );
}

/// generated route for
/// [_i32.WmsDeliveryPage]
class WmsDeliveryRoute extends _i35.PageRouteInfo<WmsDeliveryRouteArgs> {
  WmsDeliveryRoute({
    _i38.Key? key,
    required String code,
    List<_i35.PageRouteInfo>? children,
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

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsDeliveryRouteArgs>(
          orElse: () =>
              WmsDeliveryRouteArgs(code: pathParams.getString('code')));
      return _i32.WmsDeliveryPage(
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

  final _i38.Key? key;

  final String code;

  @override
  String toString() {
    return 'WmsDeliveryRouteArgs{key: $key, code: $code}';
  }
}

/// generated route for
/// [_i33.WmsTransferConfirmPage]
class WmsTransferConfirmRoute
    extends _i35.PageRouteInfo<WmsTransferConfirmRouteArgs> {
  WmsTransferConfirmRoute({
    _i38.Key? key,
    required int id,
    List<_i35.PageRouteInfo>? children,
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

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsTransferConfirmRouteArgs>(
          orElse: () =>
              WmsTransferConfirmRouteArgs(id: pathParams.getInt('id')));
      return _i33.WmsTransferConfirmPage(
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

  final _i38.Key? key;

  final int id;

  @override
  String toString() {
    return 'WmsTransferConfirmRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i34.WmsTransferPage]
class WmsTransferRoute extends _i35.PageRouteInfo<WmsTransferRouteArgs> {
  WmsTransferRoute({
    _i38.Key? key,
    required String code,
    List<_i35.PageRouteInfo>? children,
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

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsTransferRouteArgs>(
          orElse: () =>
              WmsTransferRouteArgs(code: pathParams.getString('code')));
      return _i34.WmsTransferPage(
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

  final _i38.Key? key;

  final String code;

  @override
  String toString() {
    return 'WmsTransferRouteArgs{key: $key, code: $code}';
  }
}

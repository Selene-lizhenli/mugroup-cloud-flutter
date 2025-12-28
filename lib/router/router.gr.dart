// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i47;
import 'package:cloud/models/wms/warehouse.dart' as _i49;
import 'package:cloud/pages/cart/cart_page.dart' as _i1;
import 'package:cloud/pages/cart/confirm/confirm_page.dart' as _i2;
import 'package:cloud/pages/cart/models/state.dart' as _i48;
import 'package:cloud/pages/crm/crm_company/crm_company_create_page.dart'
    as _i3;
import 'package:cloud/pages/crm/crm_company/crm_company_detail_page.dart'
    as _i4;
import 'package:cloud/pages/crm/crm_company/crm_company_edit_page.dart' as _i5;
import 'package:cloud/pages/crm/crm_company/crm_company_page.dart' as _i6;
import 'package:cloud/pages/crm/crm_contact/crm_contact_create_page.dart'
    as _i7;
import 'package:cloud/pages/crm/crm_contact/crm_contact_edit_page.dart' as _i8;
import 'package:cloud/pages/dashboard/dashboard.dart' as _i9;
import 'package:cloud/pages/layout.dart' as _i10;
import 'package:cloud/pages/login/login_page.dart' as _i11;
import 'package:cloud/pages/market_product/list/market_product_list.dart'
    as _i14;
import 'package:cloud/pages/market_product/market_product_page.dart' as _i15;
import 'package:cloud/pages/market_product/tabs/info.dart' as _i12;
import 'package:cloud/pages/market_product/tabs/inspection.dart' as _i13;
import 'package:cloud/pages/market_product/tabs/quotation.dart' as _i16;
import 'package:cloud/pages/my/my_page.dart' as _i17;
import 'package:cloud/pages/quote/quote_create/quote_create_page.dart' as _i18;
import 'package:cloud/pages/quote/quote_detail/quote_detail_page.dart' as _i19;
import 'package:cloud/pages/quote/quote_page.dart' as _i20;
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_page.dart'
    as _i21;
import 'package:cloud/pages/samples/samples_list_page.dart' as _i22;
import 'package:cloud/pages/samples/samples_page.dart' as _i23;
import 'package:cloud/pages/scan/scan_page.dart' as _i24;
import 'package:cloud/pages/selectors/select_user/select_user_page.dart'
    as _i25;
import 'package:cloud/pages/selectors/select_wms_borrow/select_wms_borrow_page.dart'
    as _i26;
import 'package:cloud/pages/selectors/select_wms_warehouse/select_wms_warehouse_page.dart'
    as _i27;
import 'package:cloud/pages/setting/setting_page.dart' as _i28;
import 'package:cloud/pages/showroom/showroom_quotations_page.dart' as _i29;
import 'package:cloud/pages/showroom/showroom_sample_create_page.dart' as _i30;
import 'package:cloud/pages/showroom/showroom_sample_detail_page/showroom_sample_detail_page.dart'
    as _i31;
import 'package:cloud/pages/showroom/showroom_sample_edit_page.dart' as _i32;
import 'package:cloud/pages/supply/supply_supplier_activity/supply_supplier_activity_create_page.dart'
    as _i33;
import 'package:cloud/pages/supply/supply_supplier_cert/supply_supplier_cert_create_page.dart'
    as _i34;
import 'package:cloud/pages/supply/supply_supplier_contact/supply_supplier_contact_create_page.dart'
    as _i35;
import 'package:cloud/pages/supply/supply_supplier_contact/supply_supplier_contact_edit_page.dart'
    as _i36;
import 'package:cloud/pages/supply/supply_supplier_create_page.dart' as _i37;
import 'package:cloud/pages/supply/supply_supplier_detail/supply_supplier_detail_page.dart'
    as _i40;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/contact.dart'
    as _i38;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/info.dart'
    as _i39;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/sample.dart'
    as _i41;
import 'package:cloud/pages/supply/supply_supplier_edit_page.dart' as _i42;
import 'package:cloud/pages/supply/supply_supplier_page.dart' as _i43;
import 'package:cloud/pages/wms/wms_delivery_page.dart' as _i44;
import 'package:cloud/pages/wms/wms_transfer_confirm/wms_transfer_confirm_page.dart'
    as _i45;
import 'package:cloud/pages/wms/wms_transfer_page.dart' as _i46;
import 'package:flutter/material.dart' as _i50;

/// generated route for
/// [_i1.CartPage]
class CartRoute extends _i47.PageRouteInfo<void> {
  const CartRoute({List<_i47.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i1.CartPage();
    },
  );
}

/// generated route for
/// [_i2.ConfirmPage]
class ConfirmRoute extends _i47.PageRouteInfo<ConfirmRouteArgs> {
  ConfirmRoute({
    required List<_i48.CartItem>? items,
    required _i49.Warehouse? warehouse,
    _i50.Key? key,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
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

  final List<_i48.CartItem>? items;

  final _i49.Warehouse? warehouse;

  final _i50.Key? key;

  @override
  String toString() {
    return 'ConfirmRouteArgs{items: $items, warehouse: $warehouse, key: $key}';
  }
}

/// generated route for
/// [_i3.CrmCompanyCreatePage]
class CrmCompanyCreateRoute extends _i47.PageRouteInfo<void> {
  const CrmCompanyCreateRoute({List<_i47.PageRouteInfo>? children})
      : super(
          CrmCompanyCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'CrmCompanyCreateRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i3.CrmCompanyCreatePage();
    },
  );
}

/// generated route for
/// [_i4.CrmCompanyDetailPage]
class CrmCompanyDetailRoute
    extends _i47.PageRouteInfo<CrmCompanyDetailRouteArgs> {
  CrmCompanyDetailRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          CrmCompanyDetailRoute.name,
          args: CrmCompanyDetailRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmCompanyDetailRoute';

  static _i47.PageInfo page = _i47.PageInfo(
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

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmCompanyDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i5.CrmCompanyEditPage]
class CrmCompanyEditRoute extends _i47.PageRouteInfo<CrmCompanyEditRouteArgs> {
  CrmCompanyEditRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          CrmCompanyEditRoute.name,
          args: CrmCompanyEditRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'CrmCompanyEditRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CrmCompanyEditRouteArgs>(
          orElse: () => CrmCompanyEditRouteArgs(id: pathParams.getInt('id')));
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

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmCompanyEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i6.CrmCompanyPage]
class CrmCompanyRoute extends _i47.PageRouteInfo<void> {
  const CrmCompanyRoute({List<_i47.PageRouteInfo>? children})
      : super(
          CrmCompanyRoute.name,
          initialChildren: children,
        );

  static const String name = 'CrmCompanyRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i6.CrmCompanyPage();
    },
  );
}

/// generated route for
/// [_i7.CrmContactCreatePage]
class CrmContactCreateRoute
    extends _i47.PageRouteInfo<CrmContactCreateRouteArgs> {
  CrmContactCreateRoute({
    _i50.Key? key,
    int? companyId,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          CrmContactCreateRoute.name,
          args: CrmContactCreateRouteArgs(
            key: key,
            companyId: companyId,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmContactCreateRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CrmContactCreateRouteArgs>(
          orElse: () => const CrmContactCreateRouteArgs());
      return _i7.CrmContactCreatePage(
        key: args.key,
        companyId: args.companyId,
      );
    },
  );
}

class CrmContactCreateRouteArgs {
  const CrmContactCreateRouteArgs({
    this.key,
    this.companyId,
  });

  final _i50.Key? key;

  final int? companyId;

  @override
  String toString() {
    return 'CrmContactCreateRouteArgs{key: $key, companyId: $companyId}';
  }
}

/// generated route for
/// [_i8.CrmContactEditPage]
class CrmContactEditRoute extends _i47.PageRouteInfo<CrmContactEditRouteArgs> {
  CrmContactEditRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          CrmContactEditRoute.name,
          args: CrmContactEditRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmContactEditRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CrmContactEditRouteArgs>();
      return _i8.CrmContactEditPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class CrmContactEditRouteArgs {
  const CrmContactEditRouteArgs({
    this.key,
    required this.id,
  });

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmContactEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i9.DashboardPage]
class DashboardRoute extends _i47.PageRouteInfo<void> {
  const DashboardRoute({List<_i47.PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i9.DashboardPage();
    },
  );
}

/// generated route for
/// [_i10.Layout]
class Layout extends _i47.PageRouteInfo<void> {
  const Layout({List<_i47.PageRouteInfo>? children})
      : super(
          Layout.name,
          initialChildren: children,
        );

  static const String name = 'Layout';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i10.Layout();
    },
  );
}

/// generated route for
/// [_i11.LoginPage]
class LoginRoute extends _i47.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i50.Key? key,
    void Function()? onLogin,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onLogin: onLogin,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LoginRouteArgs>(orElse: () => const LoginRouteArgs());
      return _i11.LoginPage(
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

  final _i50.Key? key;

  final void Function()? onLogin;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLogin: $onLogin}';
  }
}

/// generated route for
/// [_i12.MarketProductInfoPage]
class MarketProductInfoRoute extends _i47.PageRouteInfo<void> {
  const MarketProductInfoRoute({List<_i47.PageRouteInfo>? children})
      : super(
          MarketProductInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductInfoRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i12.MarketProductInfoPage();
    },
  );
}

/// generated route for
/// [_i13.MarketProductInspectionPage]
class MarketProductInspectionRoute extends _i47.PageRouteInfo<void> {
  const MarketProductInspectionRoute({List<_i47.PageRouteInfo>? children})
      : super(
          MarketProductInspectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductInspectionRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i13.MarketProductInspectionPage();
    },
  );
}

/// generated route for
/// [_i14.MarketProductListPage]
class MarketProductListRoute extends _i47.PageRouteInfo<void> {
  const MarketProductListRoute({List<_i47.PageRouteInfo>? children})
      : super(
          MarketProductListRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductListRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i14.MarketProductListPage();
    },
  );
}

/// generated route for
/// [_i15.MarketProductPage]
class MarketProductRoute extends _i47.PageRouteInfo<void> {
  const MarketProductRoute({List<_i47.PageRouteInfo>? children})
      : super(
          MarketProductRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i15.MarketProductPage();
    },
  );
}

/// generated route for
/// [_i16.MarketProductQuotationPage]
class MarketProductQuotationRoute extends _i47.PageRouteInfo<void> {
  const MarketProductQuotationRoute({List<_i47.PageRouteInfo>? children})
      : super(
          MarketProductQuotationRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductQuotationRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i16.MarketProductQuotationPage();
    },
  );
}

/// generated route for
/// [_i17.MyPage]
class MyRoute extends _i47.PageRouteInfo<void> {
  const MyRoute({List<_i47.PageRouteInfo>? children})
      : super(
          MyRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i17.MyPage();
    },
  );
}

/// generated route for
/// [_i18.QuoteCreatePage]
class QuoteCreateRoute extends _i47.PageRouteInfo<void> {
  const QuoteCreateRoute({List<_i47.PageRouteInfo>? children})
      : super(
          QuoteCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuoteCreateRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i18.QuoteCreatePage();
    },
  );
}

/// generated route for
/// [_i19.QuoteDetailPage]
class QuoteDetailRoute extends _i47.PageRouteInfo<QuoteDetailRouteArgs> {
  QuoteDetailRoute({
    _i50.Key? key,
    required int userId,
    required int id,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          QuoteDetailRoute.name,
          args: QuoteDetailRouteArgs(
            key: key,
            userId: userId,
            id: id,
          ),
          rawPathParams: {
            'userId': userId,
            'id': id,
          },
          initialChildren: children,
        );

  static const String name = 'QuoteDetailRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<QuoteDetailRouteArgs>(
          orElse: () => QuoteDetailRouteArgs(
                userId: pathParams.getInt('userId'),
                id: pathParams.getInt('id'),
              ));
      return _i19.QuoteDetailPage(
        key: args.key,
        userId: args.userId,
        id: args.id,
      );
    },
  );
}

class QuoteDetailRouteArgs {
  const QuoteDetailRouteArgs({
    this.key,
    required this.userId,
    required this.id,
  });

  final _i50.Key? key;

  final int userId;

  final int id;

  @override
  String toString() {
    return 'QuoteDetailRouteArgs{key: $key, userId: $userId, id: $id}';
  }
}

/// generated route for
/// [_i20.QuotePage]
class QuoteRoute extends _i47.PageRouteInfo<void> {
  const QuoteRoute({List<_i47.PageRouteInfo>? children})
      : super(
          QuoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuoteRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i20.QuotePage();
    },
  );
}

/// generated route for
/// [_i21.QuoteProductAddPage]
class QuoteProductAddRoute
    extends _i47.PageRouteInfo<QuoteProductAddRouteArgs> {
  QuoteProductAddRoute({
    _i50.Key? key,
    int? quoteId,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          QuoteProductAddRoute.name,
          args: QuoteProductAddRouteArgs(
            key: key,
            quoteId: quoteId,
          ),
          initialChildren: children,
        );

  static const String name = 'QuoteProductAddRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuoteProductAddRouteArgs>(
          orElse: () => const QuoteProductAddRouteArgs());
      return _i21.QuoteProductAddPage(
        key: args.key,
        quoteId: args.quoteId,
      );
    },
  );
}

class QuoteProductAddRouteArgs {
  const QuoteProductAddRouteArgs({
    this.key,
    this.quoteId,
  });

  final _i50.Key? key;

  final int? quoteId;

  @override
  String toString() {
    return 'QuoteProductAddRouteArgs{key: $key, quoteId: $quoteId}';
  }
}

/// generated route for
/// [_i22.SamplesListPage]
class SamplesListRoute extends _i47.PageRouteInfo<void> {
  const SamplesListRoute({List<_i47.PageRouteInfo>? children})
      : super(
          SamplesListRoute.name,
          initialChildren: children,
        );

  static const String name = 'SamplesListRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i22.SamplesListPage();
    },
  );
}

/// generated route for
/// [_i23.SamplesPage]
class SamplesRoute extends _i47.PageRouteInfo<void> {
  const SamplesRoute({List<_i47.PageRouteInfo>? children})
      : super(
          SamplesRoute.name,
          initialChildren: children,
        );

  static const String name = 'SamplesRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i23.SamplesPage();
    },
  );
}

/// generated route for
/// [_i24.ScanPage]
class ScanRoute extends _i47.PageRouteInfo<void> {
  const ScanRoute({List<_i47.PageRouteInfo>? children})
      : super(
          ScanRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScanRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i24.ScanPage();
    },
  );
}

/// generated route for
/// [_i25.SelectUserPage]
class SelectUserRoute extends _i47.PageRouteInfo<void> {
  const SelectUserRoute({List<_i47.PageRouteInfo>? children})
      : super(
          SelectUserRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectUserRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i25.SelectUserPage();
    },
  );
}

/// generated route for
/// [_i26.SelectWmsBorrowPage]
class SelectWmsBorrowRoute extends _i47.PageRouteInfo<void> {
  const SelectWmsBorrowRoute({List<_i47.PageRouteInfo>? children})
      : super(
          SelectWmsBorrowRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsBorrowRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i26.SelectWmsBorrowPage();
    },
  );
}

/// generated route for
/// [_i27.SelectWmsWarehousePage]
class SelectWmsWarehouseRoute extends _i47.PageRouteInfo<void> {
  const SelectWmsWarehouseRoute({List<_i47.PageRouteInfo>? children})
      : super(
          SelectWmsWarehouseRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsWarehouseRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i27.SelectWmsWarehousePage();
    },
  );
}

/// generated route for
/// [_i28.SettingPage]
class SettingRoute extends _i47.PageRouteInfo<void> {
  const SettingRoute({List<_i47.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i28.SettingPage();
    },
  );
}

/// generated route for
/// [_i29.ShowroomQuotationsPage]
class ShowroomQuotationsRoute
    extends _i47.PageRouteInfo<ShowroomQuotationsRouteArgs> {
  ShowroomQuotationsRoute({
    _i50.Key? key,
    required String quoteNo,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomQuotationsRouteArgs>(
          orElse: () => ShowroomQuotationsRouteArgs(
              quoteNo: pathParams.getString('quoteNo')));
      return _i29.ShowroomQuotationsPage(
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

  final _i50.Key? key;

  final String quoteNo;

  @override
  String toString() {
    return 'ShowroomQuotationsRouteArgs{key: $key, quoteNo: $quoteNo}';
  }
}

/// generated route for
/// [_i30.ShowroomSampleCreatePage]
class ShowroomSampleCreateRoute
    extends _i47.PageRouteInfo<ShowroomSampleCreateRouteArgs> {
  ShowroomSampleCreateRoute({
    _i50.Key? key,
    String? itemType,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          ShowroomSampleCreateRoute.name,
          args: ShowroomSampleCreateRouteArgs(
            key: key,
            itemType: itemType,
          ),
          initialChildren: children,
        );

  static const String name = 'ShowroomSampleCreateRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ShowroomSampleCreateRouteArgs>(
          orElse: () => const ShowroomSampleCreateRouteArgs());
      return _i30.ShowroomSampleCreatePage(
        key: args.key,
        itemType: args.itemType,
      );
    },
  );
}

class ShowroomSampleCreateRouteArgs {
  const ShowroomSampleCreateRouteArgs({
    this.key,
    this.itemType,
  });

  final _i50.Key? key;

  final String? itemType;

  @override
  String toString() {
    return 'ShowroomSampleCreateRouteArgs{key: $key, itemType: $itemType}';
  }
}

/// generated route for
/// [_i31.ShowroomSampleDetailPage]
class ShowroomSampleDetailRoute
    extends _i47.PageRouteInfo<ShowroomSampleDetailRouteArgs> {
  ShowroomSampleDetailRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomSampleDetailRouteArgs>(
          orElse: () =>
              ShowroomSampleDetailRouteArgs(id: pathParams.getInt('id')));
      return _i31.ShowroomSampleDetailPage(
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

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'ShowroomSampleDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i32.ShowroomSampleEditPage]
class ShowroomSampleEditRoute
    extends _i47.PageRouteInfo<ShowroomSampleEditRouteArgs> {
  ShowroomSampleEditRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomSampleEditRouteArgs>(
          orElse: () =>
              ShowroomSampleEditRouteArgs(id: pathParams.getInt('id')));
      return _i32.ShowroomSampleEditPage(
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

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'ShowroomSampleEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i33.SupplySupplierActivityCreatePage]
class SupplySupplierActivityCreateRoute
    extends _i47.PageRouteInfo<SupplySupplierActivityCreateRouteArgs> {
  SupplySupplierActivityCreateRoute({
    _i50.Key? key,
    required int supplierId,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          SupplySupplierActivityCreateRoute.name,
          args: SupplySupplierActivityCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierActivityCreateRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierActivityCreateRouteArgs>();
      return _i33.SupplySupplierActivityCreatePage(
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

  final _i50.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierActivityCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i34.SupplySupplierCertCreatePage]
class SupplySupplierCertCreateRoute
    extends _i47.PageRouteInfo<SupplySupplierCertCreateRouteArgs> {
  SupplySupplierCertCreateRoute({
    _i50.Key? key,
    required int supplierId,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          SupplySupplierCertCreateRoute.name,
          args: SupplySupplierCertCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierCertCreateRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierCertCreateRouteArgs>();
      return _i34.SupplySupplierCertCreatePage(
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

  final _i50.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierCertCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i35.SupplySupplierContactCreatePage]
class SupplySupplierContactCreateRoute
    extends _i47.PageRouteInfo<SupplySupplierContactCreateRouteArgs> {
  SupplySupplierContactCreateRoute({
    _i50.Key? key,
    required int supplierId,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          SupplySupplierContactCreateRoute.name,
          args: SupplySupplierContactCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierContactCreateRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierContactCreateRouteArgs>();
      return _i35.SupplySupplierContactCreatePage(
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

  final _i50.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierContactCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i36.SupplySupplierContactEditPage]
class SupplySupplierContactEditRoute
    extends _i47.PageRouteInfo<SupplySupplierContactEditRouteArgs> {
  SupplySupplierContactEditRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierContactEditRouteArgs>(
          orElse: () =>
              SupplySupplierContactEditRouteArgs(id: pathParams.getInt('id')));
      return _i36.SupplySupplierContactEditPage(
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

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierContactEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i37.SupplySupplierCreatePage]
class SupplySupplierCreateRoute extends _i47.PageRouteInfo<void> {
  const SupplySupplierCreateRoute({List<_i47.PageRouteInfo>? children})
      : super(
          SupplySupplierCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupplySupplierCreateRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i37.SupplySupplierCreatePage();
    },
  );
}

/// generated route for
/// [_i38.SupplySupplierDetailContactPage]
class SupplySupplierDetailContactRoute
    extends _i47.PageRouteInfo<SupplySupplierDetailContactRouteArgs> {
  SupplySupplierDetailContactRoute({
    _i50.Key? key,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailContactRoute.name,
          args: SupplySupplierDetailContactRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailContactRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailContactRouteArgs>(
          orElse: () => SupplySupplierDetailContactRouteArgs());
      return _i38.SupplySupplierDetailContactPage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailContactRouteArgs {
  const SupplySupplierDetailContactRouteArgs({this.key});

  final _i50.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailContactRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i39.SupplySupplierDetailInfoPage]
class SupplySupplierDetailInfoRoute
    extends _i47.PageRouteInfo<SupplySupplierDetailInfoRouteArgs> {
  SupplySupplierDetailInfoRoute({
    _i50.Key? key,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailInfoRoute.name,
          args: SupplySupplierDetailInfoRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailInfoRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailInfoRouteArgs>(
          orElse: () => SupplySupplierDetailInfoRouteArgs());
      return _i39.SupplySupplierDetailInfoPage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailInfoRouteArgs {
  const SupplySupplierDetailInfoRouteArgs({this.key});

  final _i50.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailInfoRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i40.SupplySupplierDetailPage]
class SupplySupplierDetailRoute
    extends _i47.PageRouteInfo<SupplySupplierDetailRouteArgs> {
  SupplySupplierDetailRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailRouteArgs>(
          orElse: () =>
              SupplySupplierDetailRouteArgs(id: pathParams.getInt('id')));
      return _i40.SupplySupplierDetailPage(
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

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i41.SupplySupplierDetailSamplePage]
class SupplySupplierDetailSampleRoute
    extends _i47.PageRouteInfo<SupplySupplierDetailSampleRouteArgs> {
  SupplySupplierDetailSampleRoute({
    _i50.Key? key,
    List<_i47.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailSampleRoute.name,
          args: SupplySupplierDetailSampleRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailSampleRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailSampleRouteArgs>(
          orElse: () => SupplySupplierDetailSampleRouteArgs());
      return _i41.SupplySupplierDetailSamplePage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailSampleRouteArgs {
  const SupplySupplierDetailSampleRouteArgs({this.key});

  final _i50.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailSampleRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i42.SupplySupplierEditPage]
class SupplySupplierEditRoute
    extends _i47.PageRouteInfo<SupplySupplierEditRouteArgs> {
  SupplySupplierEditRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierEditRouteArgs>(
          orElse: () =>
              SupplySupplierEditRouteArgs(id: pathParams.getInt('id')));
      return _i42.SupplySupplierEditPage(
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

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i43.SupplySupplierPage]
class SupplySupplierRoute extends _i47.PageRouteInfo<void> {
  const SupplySupplierRoute({List<_i47.PageRouteInfo>? children})
      : super(
          SupplySupplierRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupplySupplierRoute';

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      return const _i43.SupplySupplierPage();
    },
  );
}

/// generated route for
/// [_i44.WmsDeliveryPage]
class WmsDeliveryRoute extends _i47.PageRouteInfo<WmsDeliveryRouteArgs> {
  WmsDeliveryRoute({
    _i50.Key? key,
    required String code,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsDeliveryRouteArgs>(
          orElse: () =>
              WmsDeliveryRouteArgs(code: pathParams.getString('code')));
      return _i44.WmsDeliveryPage(
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

  final _i50.Key? key;

  final String code;

  @override
  String toString() {
    return 'WmsDeliveryRouteArgs{key: $key, code: $code}';
  }
}

/// generated route for
/// [_i45.WmsTransferConfirmPage]
class WmsTransferConfirmRoute
    extends _i47.PageRouteInfo<WmsTransferConfirmRouteArgs> {
  WmsTransferConfirmRoute({
    _i50.Key? key,
    required int id,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsTransferConfirmRouteArgs>(
          orElse: () =>
              WmsTransferConfirmRouteArgs(id: pathParams.getInt('id')));
      return _i45.WmsTransferConfirmPage(
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

  final _i50.Key? key;

  final int id;

  @override
  String toString() {
    return 'WmsTransferConfirmRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i46.WmsTransferPage]
class WmsTransferRoute extends _i47.PageRouteInfo<WmsTransferRouteArgs> {
  WmsTransferRoute({
    _i50.Key? key,
    required String code,
    List<_i47.PageRouteInfo>? children,
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

  static _i47.PageInfo page = _i47.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsTransferRouteArgs>(
          orElse: () =>
              WmsTransferRouteArgs(code: pathParams.getString('code')));
      return _i46.WmsTransferPage(
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

  final _i50.Key? key;

  final String code;

  @override
  String toString() {
    return 'WmsTransferRouteArgs{key: $key, code: $code}';
  }
}

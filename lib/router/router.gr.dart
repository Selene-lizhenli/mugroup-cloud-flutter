// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i63;
import 'package:cloud/models/dashboard/public_news_article.dart' as _i68;
import 'package:cloud/models/single_station/single_station_item.dart' as _i69;
import 'package:cloud/models/wms/warehouse.dart' as _i65;
import 'package:cloud/pages/cart/cart_page.dart' as _i1;
import 'package:cloud/pages/cart/confirm/confirm_page.dart' as _i2;
import 'package:cloud/pages/cart/models/state.dart' as _i64;
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
import 'package:cloud/pages/dashboard/pages/news_pages.dart' as _i25;
import 'package:cloud/pages/dashboard/widgets/selected_modules_widget.dart'
    as _i67;
import 'package:cloud/pages/inspection/inspection_add_page.dart' as _i11;
import 'package:cloud/pages/inspection/inspection_detail_page.dart' as _i12;
import 'package:cloud/pages/inspection/inspection_item_confirm_page.dart'
    as _i13;
import 'package:cloud/pages/inspection/inspection_page.dart' as _i14;
import 'package:cloud/pages/layout.dart' as _i15;
import 'package:cloud/pages/login/login_page.dart' as _i16;
import 'package:cloud/pages/market_product/list/market_product_list.dart'
    as _i20;
import 'package:cloud/pages/market_product/market_product_company_create_page.dart'
    as _i17;
import 'package:cloud/pages/market_product/market_product_page.dart' as _i21;
import 'package:cloud/pages/market_product/market_product_supplier_create_page.dart'
    as _i23;
import 'package:cloud/pages/market_product/tabs/info.dart' as _i18;
import 'package:cloud/pages/market_product/tabs/inspection.dart' as _i19;
import 'package:cloud/pages/market_product/tabs/quotation.dart' as _i22;
import 'package:cloud/pages/my/my_page.dart' as _i24;
import 'package:cloud/pages/purchase_assist/purchase_assist_page.dart' as _i27;
import 'package:cloud/pages/quote/batch_import/product_batch_import_page.dart'
    as _i26;
import 'package:cloud/pages/quote/quote_create/quote_create_page.dart' as _i28;
import 'package:cloud/pages/quote/quote_detail/quote_detail_page.dart' as _i29;
import 'package:cloud/pages/quote/quote_page.dart' as _i30;
import 'package:cloud/pages/quote/quote_product_add/quote_product_add_adaptive_page.dart'
    as _i31;
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_ai_add_floor_page.dart'
    as _i32;
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_ai_add_notepad_page.dart'
    as _i33;
import 'package:cloud/pages/quote/quote_product_ai_add/quote_product_new_add_page.dart'
    as _i34;
import 'package:cloud/pages/quote/supplier_products_related/supplier_products_page.dart'
    as _i48;
import 'package:cloud/pages/samples/samples_list_page.dart' as _i35;
import 'package:cloud/pages/scan/scan_page.dart' as _i36;
import 'package:cloud/pages/selectors/select_product/select_product_page.dart'
    as _i37;
import 'package:cloud/pages/selectors/select_user/select_user_page.dart'
    as _i38;
import 'package:cloud/pages/selectors/select_wms_borrow/select_wms_borrow_page.dart'
    as _i39;
import 'package:cloud/pages/selectors/select_wms_warehouse/select_wms_warehouse_page.dart'
    as _i40;
import 'package:cloud/pages/setting/setting_page.dart' as _i41;
import 'package:cloud/pages/showroom/showroom_quotations_page.dart' as _i42;
import 'package:cloud/pages/showroom/showroom_sample_create_page.dart' as _i43;
import 'package:cloud/pages/showroom/showroom_sample_detail_page/showroom_sample_detail_page.dart'
    as _i44;
import 'package:cloud/pages/showroom/showroom_sample_edit_page.dart' as _i45;
import 'package:cloud/pages/single_station/detail/single_station_detail_page.dart'
    as _i46;
import 'package:cloud/pages/single_station/inquiry/inquiry_message_page.dart'
    as _i10;
import 'package:cloud/pages/single_station/single_station_page.dart' as _i47;
import 'package:cloud/pages/supply/supply_supplier_activity/supply_supplier_activity_create_page.dart'
    as _i49;
import 'package:cloud/pages/supply/supply_supplier_cert/supply_supplier_cert_create_page.dart'
    as _i50;
import 'package:cloud/pages/supply/supply_supplier_contact/supply_supplier_contact_create_page.dart'
    as _i51;
import 'package:cloud/pages/supply/supply_supplier_contact/supply_supplier_contact_edit_page.dart'
    as _i52;
import 'package:cloud/pages/supply/supply_supplier_create_page.dart' as _i53;
import 'package:cloud/pages/supply/supply_supplier_detail/supply_supplier_detail_page.dart'
    as _i56;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/contact.dart'
    as _i54;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/info.dart'
    as _i55;
import 'package:cloud/pages/supply/supply_supplier_detail/tabs/sample.dart'
    as _i57;
import 'package:cloud/pages/supply/supply_supplier_edit_page.dart' as _i58;
import 'package:cloud/pages/supply/supply_supplier_page.dart' as _i59;
import 'package:cloud/pages/wms/wms_delivery_page.dart' as _i60;
import 'package:cloud/pages/wms/wms_transfer_confirm/wms_transfer_confirm_page.dart'
    as _i61;
import 'package:cloud/pages/wms/wms_transfer_page.dart' as _i62;
import 'package:flutter/material.dart' as _i66;

/// generated route for
/// [_i1.CartPage]
class CartRoute extends _i63.PageRouteInfo<void> {
  const CartRoute({List<_i63.PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i1.CartPage();
    },
  );
}

/// generated route for
/// [_i2.ConfirmPage]
class ConfirmRoute extends _i63.PageRouteInfo<ConfirmRouteArgs> {
  ConfirmRoute({
    required List<_i64.CartItem>? items,
    required _i65.Warehouse? warehouse,
    _i66.Key? key,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
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

  final List<_i64.CartItem>? items;

  final _i65.Warehouse? warehouse;

  final _i66.Key? key;

  @override
  String toString() {
    return 'ConfirmRouteArgs{items: $items, warehouse: $warehouse, key: $key}';
  }
}

/// generated route for
/// [_i3.CrmCompanyCreatePage]
class CrmCompanyCreateRoute extends _i63.PageRouteInfo<void> {
  const CrmCompanyCreateRoute({List<_i63.PageRouteInfo>? children})
      : super(
          CrmCompanyCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'CrmCompanyCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i3.CrmCompanyCreatePage();
    },
  );
}

/// generated route for
/// [_i4.CrmCompanyDetailPage]
class CrmCompanyDetailRoute
    extends _i63.PageRouteInfo<CrmCompanyDetailRouteArgs> {
  CrmCompanyDetailRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          CrmCompanyDetailRoute.name,
          args: CrmCompanyDetailRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmCompanyDetailRoute';

  static _i63.PageInfo page = _i63.PageInfo(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmCompanyDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i5.CrmCompanyEditPage]
class CrmCompanyEditRoute extends _i63.PageRouteInfo<CrmCompanyEditRouteArgs> {
  CrmCompanyEditRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmCompanyEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i6.CrmCompanyPage]
class CrmCompanyRoute extends _i63.PageRouteInfo<void> {
  const CrmCompanyRoute({List<_i63.PageRouteInfo>? children})
      : super(
          CrmCompanyRoute.name,
          initialChildren: children,
        );

  static const String name = 'CrmCompanyRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i6.CrmCompanyPage();
    },
  );
}

/// generated route for
/// [_i7.CrmContactCreatePage]
class CrmContactCreateRoute
    extends _i63.PageRouteInfo<CrmContactCreateRouteArgs> {
  CrmContactCreateRoute({
    _i66.Key? key,
    int? companyId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          CrmContactCreateRoute.name,
          args: CrmContactCreateRouteArgs(
            key: key,
            companyId: companyId,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmContactCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
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

  final _i66.Key? key;

  final int? companyId;

  @override
  String toString() {
    return 'CrmContactCreateRouteArgs{key: $key, companyId: $companyId}';
  }
}

/// generated route for
/// [_i8.CrmContactEditPage]
class CrmContactEditRoute extends _i63.PageRouteInfo<CrmContactEditRouteArgs> {
  CrmContactEditRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          CrmContactEditRoute.name,
          args: CrmContactEditRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'CrmContactEditRoute';

  static _i63.PageInfo page = _i63.PageInfo(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'CrmContactEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i9.DashboardPage]
class DashboardRoute extends _i63.PageRouteInfo<DashboardRouteArgs> {
  DashboardRoute({
    _i66.Key? key,
    _i66.GlobalKey<_i66.State<_i67.SelectedModulesWidget>>? selectedModulesKey,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          DashboardRoute.name,
          args: DashboardRouteArgs(
            key: key,
            selectedModulesKey: selectedModulesKey,
          ),
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DashboardRouteArgs>(
          orElse: () => const DashboardRouteArgs());
      return _i9.DashboardPage(
        key: args.key,
        selectedModulesKey: args.selectedModulesKey,
      );
    },
  );
}

class DashboardRouteArgs {
  const DashboardRouteArgs({
    this.key,
    this.selectedModulesKey,
  });

  final _i66.Key? key;

  final _i66.GlobalKey<_i66.State<_i67.SelectedModulesWidget>>?
      selectedModulesKey;

  @override
  String toString() {
    return 'DashboardRouteArgs{key: $key, selectedModulesKey: $selectedModulesKey}';
  }
}

/// generated route for
/// [_i10.InquiryMessagePage]
class InquiryMessageRoute extends _i63.PageRouteInfo<void> {
  const InquiryMessageRoute({List<_i63.PageRouteInfo>? children})
      : super(
          InquiryMessageRoute.name,
          initialChildren: children,
        );

  static const String name = 'InquiryMessageRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i10.InquiryMessagePage();
    },
  );
}

/// generated route for
/// [_i11.InspectionAddPage]
class InspectionAddRoute extends _i63.PageRouteInfo<void> {
  const InspectionAddRoute({List<_i63.PageRouteInfo>? children})
      : super(
          InspectionAddRoute.name,
          initialChildren: children,
        );

  static const String name = 'InspectionAddRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i11.InspectionAddPage();
    },
  );
}

/// generated route for
/// [_i12.InspectionDetailPage]
class InspectionDetailRoute
    extends _i63.PageRouteInfo<InspectionDetailRouteArgs> {
  InspectionDetailRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          InspectionDetailRoute.name,
          args: InspectionDetailRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'InspectionDetailRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InspectionDetailRouteArgs>();
      return _i12.InspectionDetailPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class InspectionDetailRouteArgs {
  const InspectionDetailRouteArgs({
    this.key,
    required this.id,
  });

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'InspectionDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i13.InspectionItemConfirmPage]
class InspectionItemConfirmRoute
    extends _i63.PageRouteInfo<InspectionItemConfirmRouteArgs> {
  InspectionItemConfirmRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          InspectionItemConfirmRoute.name,
          args: InspectionItemConfirmRouteArgs(
            key: key,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'InspectionItemConfirmRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InspectionItemConfirmRouteArgs>();
      return _i13.InspectionItemConfirmPage(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class InspectionItemConfirmRouteArgs {
  const InspectionItemConfirmRouteArgs({
    this.key,
    required this.id,
  });

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'InspectionItemConfirmRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i14.InspectionPage]
class InspectionRoute extends _i63.PageRouteInfo<void> {
  const InspectionRoute({List<_i63.PageRouteInfo>? children})
      : super(
          InspectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'InspectionRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i14.InspectionPage();
    },
  );
}

/// generated route for
/// [_i15.Layout]
class Layout extends _i63.PageRouteInfo<void> {
  const Layout({List<_i63.PageRouteInfo>? children})
      : super(
          Layout.name,
          initialChildren: children,
        );

  static const String name = 'Layout';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i15.Layout();
    },
  );
}

/// generated route for
/// [_i16.LoginPage]
class LoginRoute extends _i63.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    _i66.Key? key,
    void Function()? onLogin,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onLogin: onLogin,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LoginRouteArgs>(orElse: () => const LoginRouteArgs());
      return _i16.LoginPage(
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

  final _i66.Key? key;

  final void Function()? onLogin;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLogin: $onLogin}';
  }
}

/// generated route for
/// [_i17.MarketProductCompanyCreatePage]
class MarketProductCompanyCreateRoute extends _i63.PageRouteInfo<void> {
  const MarketProductCompanyCreateRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MarketProductCompanyCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductCompanyCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i17.MarketProductCompanyCreatePage();
    },
  );
}

/// generated route for
/// [_i18.MarketProductInfoPage]
class MarketProductInfoRoute extends _i63.PageRouteInfo<void> {
  const MarketProductInfoRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MarketProductInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductInfoRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i18.MarketProductInfoPage();
    },
  );
}

/// generated route for
/// [_i19.MarketProductInspectionPage]
class MarketProductInspectionRoute extends _i63.PageRouteInfo<void> {
  const MarketProductInspectionRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MarketProductInspectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductInspectionRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i19.MarketProductInspectionPage();
    },
  );
}

/// generated route for
/// [_i20.MarketProductListPage]
class MarketProductListRoute extends _i63.PageRouteInfo<void> {
  const MarketProductListRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MarketProductListRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductListRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i20.MarketProductListPage();
    },
  );
}

/// generated route for
/// [_i21.MarketProductPage]
class MarketProductRoute extends _i63.PageRouteInfo<void> {
  const MarketProductRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MarketProductRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i21.MarketProductPage();
    },
  );
}

/// generated route for
/// [_i22.MarketProductQuotationPage]
class MarketProductQuotationRoute extends _i63.PageRouteInfo<void> {
  const MarketProductQuotationRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MarketProductQuotationRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductQuotationRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i22.MarketProductQuotationPage();
    },
  );
}

/// generated route for
/// [_i23.MarketProductSupplierCreatePage]
class MarketProductSupplierCreateRoute extends _i63.PageRouteInfo<void> {
  const MarketProductSupplierCreateRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MarketProductSupplierCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'MarketProductSupplierCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i23.MarketProductSupplierCreatePage();
    },
  );
}

/// generated route for
/// [_i24.MyPage]
class MyRoute extends _i63.PageRouteInfo<void> {
  const MyRoute({List<_i63.PageRouteInfo>? children})
      : super(
          MyRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i24.MyPage();
    },
  );
}

/// generated route for
/// [_i25.NewsPage]
class NewsRoute extends _i63.PageRouteInfo<NewsRouteArgs> {
  NewsRoute({
    _i66.Key? key,
    required int currentIndex,
    required int totalLength,
    List<_i68.PublicNewsArticle>? articleList,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          NewsRoute.name,
          args: NewsRouteArgs(
            key: key,
            currentIndex: currentIndex,
            totalLength: totalLength,
            articleList: articleList,
          ),
          initialChildren: children,
        );

  static const String name = 'NewsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewsRouteArgs>();
      return _i25.NewsPage(
        key: args.key,
        currentIndex: args.currentIndex,
        totalLength: args.totalLength,
        articleList: args.articleList,
      );
    },
  );
}

class NewsRouteArgs {
  const NewsRouteArgs({
    this.key,
    required this.currentIndex,
    required this.totalLength,
    this.articleList,
  });

  final _i66.Key? key;

  final int currentIndex;

  final int totalLength;

  final List<_i68.PublicNewsArticle>? articleList;

  @override
  String toString() {
    return 'NewsRouteArgs{key: $key, currentIndex: $currentIndex, totalLength: $totalLength, articleList: $articleList}';
  }
}

/// generated route for
/// [_i26.ProductBatchImportPage]
class ProductBatchImportRoute
    extends _i63.PageRouteInfo<ProductBatchImportRouteArgs> {
  ProductBatchImportRoute({
    _i66.Key? key,
    int? quotationId,
    String? supplierNo,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          ProductBatchImportRoute.name,
          args: ProductBatchImportRouteArgs(
            key: key,
            quotationId: quotationId,
            supplierNo: supplierNo,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductBatchImportRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductBatchImportRouteArgs>(
          orElse: () => const ProductBatchImportRouteArgs());
      return _i26.ProductBatchImportPage(
        key: args.key,
        quotationId: args.quotationId,
        supplierNo: args.supplierNo,
      );
    },
  );
}

class ProductBatchImportRouteArgs {
  const ProductBatchImportRouteArgs({
    this.key,
    this.quotationId,
    this.supplierNo,
  });

  final _i66.Key? key;

  final int? quotationId;

  final String? supplierNo;

  @override
  String toString() {
    return 'ProductBatchImportRouteArgs{key: $key, quotationId: $quotationId, supplierNo: $supplierNo}';
  }
}

/// generated route for
/// [_i27.PurchaseAssistPage]
class PurchaseAssistRoute extends _i63.PageRouteInfo<void> {
  const PurchaseAssistRoute({List<_i63.PageRouteInfo>? children})
      : super(
          PurchaseAssistRoute.name,
          initialChildren: children,
        );

  static const String name = 'PurchaseAssistRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i27.PurchaseAssistPage();
    },
  );
}

/// generated route for
/// [_i28.QuoteCreatePage]
class QuoteCreateRoute extends _i63.PageRouteInfo<QuoteCreateRouteArgs> {
  QuoteCreateRoute({
    _i66.Key? key,
    int? quoteId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          QuoteCreateRoute.name,
          args: QuoteCreateRouteArgs(
            key: key,
            quoteId: quoteId,
          ),
          initialChildren: children,
        );

  static const String name = 'QuoteCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuoteCreateRouteArgs>(
          orElse: () => const QuoteCreateRouteArgs());
      return _i28.QuoteCreatePage(
        key: args.key,
        quoteId: args.quoteId,
      );
    },
  );
}

class QuoteCreateRouteArgs {
  const QuoteCreateRouteArgs({
    this.key,
    this.quoteId,
  });

  final _i66.Key? key;

  final int? quoteId;

  @override
  String toString() {
    return 'QuoteCreateRouteArgs{key: $key, quoteId: $quoteId}';
  }
}

/// generated route for
/// [_i29.QuoteDetailPage]
class QuoteDetailRoute extends _i63.PageRouteInfo<QuoteDetailRouteArgs> {
  QuoteDetailRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<QuoteDetailRouteArgs>(
          orElse: () => QuoteDetailRouteArgs(id: pathParams.getInt('id')));
      return _i29.QuoteDetailPage(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'QuoteDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i30.QuotePage]
class QuoteRoute extends _i63.PageRouteInfo<void> {
  const QuoteRoute({List<_i63.PageRouteInfo>? children})
      : super(
          QuoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'QuoteRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i30.QuotePage();
    },
  );
}

/// generated route for
/// [_i31.QuoteProductAddAdaptivePage]
class QuoteProductAddAdaptiveRoute
    extends _i63.PageRouteInfo<QuoteProductAddAdaptiveRouteArgs> {
  QuoteProductAddAdaptiveRoute({
    _i66.Key? key,
    int? initialMode,
    int? quoteId,
    String? supplierId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          QuoteProductAddAdaptiveRoute.name,
          args: QuoteProductAddAdaptiveRouteArgs(
            key: key,
            initialMode: initialMode,
            quoteId: quoteId,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'QuoteProductAddAdaptiveRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuoteProductAddAdaptiveRouteArgs>(
          orElse: () => const QuoteProductAddAdaptiveRouteArgs());
      return _i31.QuoteProductAddAdaptivePage(
        key: args.key,
        initialMode: args.initialMode,
        quoteId: args.quoteId,
        supplierId: args.supplierId,
      );
    },
  );
}

class QuoteProductAddAdaptiveRouteArgs {
  const QuoteProductAddAdaptiveRouteArgs({
    this.key,
    this.initialMode,
    this.quoteId,
    this.supplierId,
  });

  final _i66.Key? key;

  final int? initialMode;

  final int? quoteId;

  final String? supplierId;

  @override
  String toString() {
    return 'QuoteProductAddAdaptiveRouteArgs{key: $key, initialMode: $initialMode, quoteId: $quoteId, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i32.QuoteProductAiAddFloorPage]
class QuoteProductAiAddFloorRoute
    extends _i63.PageRouteInfo<QuoteProductAiAddFloorRouteArgs> {
  QuoteProductAiAddFloorRoute({
    _i66.Key? key,
    int? quoteId,
    String? supplierId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          QuoteProductAiAddFloorRoute.name,
          args: QuoteProductAiAddFloorRouteArgs(
            key: key,
            quoteId: quoteId,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'QuoteProductAiAddFloorRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuoteProductAiAddFloorRouteArgs>(
          orElse: () => const QuoteProductAiAddFloorRouteArgs());
      return _i32.QuoteProductAiAddFloorPage(
        key: args.key,
        quoteId: args.quoteId,
        supplierId: args.supplierId,
      );
    },
  );
}

class QuoteProductAiAddFloorRouteArgs {
  const QuoteProductAiAddFloorRouteArgs({
    this.key,
    this.quoteId,
    this.supplierId,
  });

  final _i66.Key? key;

  final int? quoteId;

  final String? supplierId;

  @override
  String toString() {
    return 'QuoteProductAiAddFloorRouteArgs{key: $key, quoteId: $quoteId, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i33.QuoteProductAiAddNotepadPage]
class QuoteProductAiAddNotepadRoute
    extends _i63.PageRouteInfo<QuoteProductAiAddNotepadRouteArgs> {
  QuoteProductAiAddNotepadRoute({
    _i66.Key? key,
    int? quoteId,
    String? supplierId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          QuoteProductAiAddNotepadRoute.name,
          args: QuoteProductAiAddNotepadRouteArgs(
            key: key,
            quoteId: quoteId,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'QuoteProductAiAddNotepadRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuoteProductAiAddNotepadRouteArgs>(
          orElse: () => const QuoteProductAiAddNotepadRouteArgs());
      return _i33.QuoteProductAiAddNotepadPage(
        key: args.key,
        quoteId: args.quoteId,
        supplierId: args.supplierId,
      );
    },
  );
}

class QuoteProductAiAddNotepadRouteArgs {
  const QuoteProductAiAddNotepadRouteArgs({
    this.key,
    this.quoteId,
    this.supplierId,
  });

  final _i66.Key? key;

  final int? quoteId;

  final String? supplierId;

  @override
  String toString() {
    return 'QuoteProductAiAddNotepadRouteArgs{key: $key, quoteId: $quoteId, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i34.QuoteProductNewAddPage]
class QuoteProductNewAddRoute
    extends _i63.PageRouteInfo<QuoteProductNewAddRouteArgs> {
  QuoteProductNewAddRoute({
    _i66.Key? key,
    int? quoteId,
    String? supplierId,
    bool isEmbedded = false,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          QuoteProductNewAddRoute.name,
          args: QuoteProductNewAddRouteArgs(
            key: key,
            quoteId: quoteId,
            supplierId: supplierId,
            isEmbedded: isEmbedded,
          ),
          initialChildren: children,
        );

  static const String name = 'QuoteProductNewAddRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QuoteProductNewAddRouteArgs>(
          orElse: () => const QuoteProductNewAddRouteArgs());
      return _i34.QuoteProductNewAddPage(
        key: args.key,
        quoteId: args.quoteId,
        supplierId: args.supplierId,
        isEmbedded: args.isEmbedded,
      );
    },
  );
}

class QuoteProductNewAddRouteArgs {
  const QuoteProductNewAddRouteArgs({
    this.key,
    this.quoteId,
    this.supplierId,
    this.isEmbedded = false,
  });

  final _i66.Key? key;

  final int? quoteId;

  final String? supplierId;

  final bool isEmbedded;

  @override
  String toString() {
    return 'QuoteProductNewAddRouteArgs{key: $key, quoteId: $quoteId, supplierId: $supplierId, isEmbedded: $isEmbedded}';
  }
}

/// generated route for
/// [_i35.SamplesListPage]
class SamplesListRoute extends _i63.PageRouteInfo<void> {
  const SamplesListRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SamplesListRoute.name,
          initialChildren: children,
        );

  static const String name = 'SamplesListRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i35.SamplesListPage();
    },
  );
}

/// generated route for
/// [_i36.ScanPage]
class ScanRoute extends _i63.PageRouteInfo<void> {
  const ScanRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ScanRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScanRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i36.ScanPage();
    },
  );
}

/// generated route for
/// [_i37.SelectProductPage]
class SelectProductRoute extends _i63.PageRouteInfo<SelectProductRouteArgs> {
  SelectProductRoute({
    _i66.Key? key,
    int? supplierId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SelectProductRoute.name,
          args: SelectProductRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          rawQueryParams: {'supplierId': supplierId},
          initialChildren: children,
        );

  static const String name = 'SelectProductRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<SelectProductRouteArgs>(
          orElse: () => SelectProductRouteArgs(
              supplierId: queryParams.optInt('supplierId')));
      return _i37.SelectProductPage(
        key: args.key,
        supplierId: args.supplierId,
      );
    },
  );
}

class SelectProductRouteArgs {
  const SelectProductRouteArgs({
    this.key,
    this.supplierId,
  });

  final _i66.Key? key;

  final int? supplierId;

  @override
  String toString() {
    return 'SelectProductRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i38.SelectUserPage]
class SelectUserRoute extends _i63.PageRouteInfo<void> {
  const SelectUserRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SelectUserRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectUserRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i38.SelectUserPage();
    },
  );
}

/// generated route for
/// [_i39.SelectWmsBorrowPage]
class SelectWmsBorrowRoute extends _i63.PageRouteInfo<void> {
  const SelectWmsBorrowRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SelectWmsBorrowRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsBorrowRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i39.SelectWmsBorrowPage();
    },
  );
}

/// generated route for
/// [_i40.SelectWmsWarehousePage]
class SelectWmsWarehouseRoute extends _i63.PageRouteInfo<void> {
  const SelectWmsWarehouseRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SelectWmsWarehouseRoute.name,
          initialChildren: children,
        );

  static const String name = 'SelectWmsWarehouseRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i40.SelectWmsWarehousePage();
    },
  );
}

/// generated route for
/// [_i41.SettingPage]
class SettingRoute extends _i63.PageRouteInfo<void> {
  const SettingRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i41.SettingPage();
    },
  );
}

/// generated route for
/// [_i42.ShowroomQuotationsPage]
class ShowroomQuotationsRoute
    extends _i63.PageRouteInfo<ShowroomQuotationsRouteArgs> {
  ShowroomQuotationsRoute({
    _i66.Key? key,
    required String quoteNo,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomQuotationsRouteArgs>(
          orElse: () => ShowroomQuotationsRouteArgs(
              quoteNo: pathParams.getString('quoteNo')));
      return _i42.ShowroomQuotationsPage(
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

  final _i66.Key? key;

  final String quoteNo;

  @override
  String toString() {
    return 'ShowroomQuotationsRouteArgs{key: $key, quoteNo: $quoteNo}';
  }
}

/// generated route for
/// [_i43.ShowroomSampleCreatePage]
class ShowroomSampleCreateRoute extends _i63.PageRouteInfo<void> {
  const ShowroomSampleCreateRoute({List<_i63.PageRouteInfo>? children})
      : super(
          ShowroomSampleCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShowroomSampleCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i43.ShowroomSampleCreatePage();
    },
  );
}

/// generated route for
/// [_i44.ShowroomSampleDetailPage]
class ShowroomSampleDetailRoute
    extends _i63.PageRouteInfo<ShowroomSampleDetailRouteArgs> {
  ShowroomSampleDetailRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomSampleDetailRouteArgs>(
          orElse: () =>
              ShowroomSampleDetailRouteArgs(id: pathParams.getInt('id')));
      return _i44.ShowroomSampleDetailPage(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'ShowroomSampleDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i45.ShowroomSampleEditPage]
class ShowroomSampleEditRoute
    extends _i63.PageRouteInfo<ShowroomSampleEditRouteArgs> {
  ShowroomSampleEditRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ShowroomSampleEditRouteArgs>(
          orElse: () =>
              ShowroomSampleEditRouteArgs(id: pathParams.getInt('id')));
      return _i45.ShowroomSampleEditPage(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'ShowroomSampleEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i46.SingleStationDetailPage]
class SingleStationDetailRoute
    extends _i63.PageRouteInfo<SingleStationDetailRouteArgs> {
  SingleStationDetailRoute({
    _i66.Key? key,
    required _i69.SingleStationItem? item,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SingleStationDetailRoute.name,
          args: SingleStationDetailRouteArgs(
            key: key,
            item: item,
          ),
          initialChildren: children,
        );

  static const String name = 'SingleStationDetailRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SingleStationDetailRouteArgs>();
      return _i46.SingleStationDetailPage(
        key: args.key,
        item: args.item,
      );
    },
  );
}

class SingleStationDetailRouteArgs {
  const SingleStationDetailRouteArgs({
    this.key,
    required this.item,
  });

  final _i66.Key? key;

  final _i69.SingleStationItem? item;

  @override
  String toString() {
    return 'SingleStationDetailRouteArgs{key: $key, item: $item}';
  }
}

/// generated route for
/// [_i47.SingleStationPage]
class SingleStationRoute extends _i63.PageRouteInfo<void> {
  const SingleStationRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SingleStationRoute.name,
          initialChildren: children,
        );

  static const String name = 'SingleStationRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i47.SingleStationPage();
    },
  );
}

/// generated route for
/// [_i48.SupplierProductsPage]
class SupplierProductsRoute
    extends _i63.PageRouteInfo<SupplierProductsRouteArgs> {
  SupplierProductsRoute({
    _i66.Key? key,
    required int quotationId,
    required int supplierId,
    required String supplierNo,
    required String supplierName,
    String? companyName,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SupplierProductsRoute.name,
          args: SupplierProductsRouteArgs(
            key: key,
            quotationId: quotationId,
            supplierId: supplierId,
            supplierNo: supplierNo,
            supplierName: supplierName,
            companyName: companyName,
          ),
          rawPathParams: {
            'quotationId': quotationId,
            'supplierId': supplierId,
            'supplierNo': supplierNo,
            'supplierName': supplierName,
            'companyName': companyName,
          },
          initialChildren: children,
        );

  static const String name = 'SupplierProductsRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplierProductsRouteArgs>(
          orElse: () => SupplierProductsRouteArgs(
                quotationId: pathParams.getInt('quotationId'),
                supplierId: pathParams.getInt('supplierId'),
                supplierNo: pathParams.getString('supplierNo'),
                supplierName: pathParams.getString('supplierName'),
                companyName: pathParams.optString('companyName'),
              ));
      return _i48.SupplierProductsPage(
        key: args.key,
        quotationId: args.quotationId,
        supplierId: args.supplierId,
        supplierNo: args.supplierNo,
        supplierName: args.supplierName,
        companyName: args.companyName,
      );
    },
  );
}

class SupplierProductsRouteArgs {
  const SupplierProductsRouteArgs({
    this.key,
    required this.quotationId,
    required this.supplierId,
    required this.supplierNo,
    required this.supplierName,
    this.companyName,
  });

  final _i66.Key? key;

  final int quotationId;

  final int supplierId;

  final String supplierNo;

  final String supplierName;

  final String? companyName;

  @override
  String toString() {
    return 'SupplierProductsRouteArgs{key: $key, quotationId: $quotationId, supplierId: $supplierId, supplierNo: $supplierNo, supplierName: $supplierName, companyName: $companyName}';
  }
}

/// generated route for
/// [_i49.SupplySupplierActivityCreatePage]
class SupplySupplierActivityCreateRoute
    extends _i63.PageRouteInfo<SupplySupplierActivityCreateRouteArgs> {
  SupplySupplierActivityCreateRoute({
    _i66.Key? key,
    required int supplierId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SupplySupplierActivityCreateRoute.name,
          args: SupplySupplierActivityCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierActivityCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierActivityCreateRouteArgs>();
      return _i49.SupplySupplierActivityCreatePage(
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

  final _i66.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierActivityCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i50.SupplySupplierCertCreatePage]
class SupplySupplierCertCreateRoute
    extends _i63.PageRouteInfo<SupplySupplierCertCreateRouteArgs> {
  SupplySupplierCertCreateRoute({
    _i66.Key? key,
    required int supplierId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SupplySupplierCertCreateRoute.name,
          args: SupplySupplierCertCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierCertCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierCertCreateRouteArgs>();
      return _i50.SupplySupplierCertCreatePage(
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

  final _i66.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierCertCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i51.SupplySupplierContactCreatePage]
class SupplySupplierContactCreateRoute
    extends _i63.PageRouteInfo<SupplySupplierContactCreateRouteArgs> {
  SupplySupplierContactCreateRoute({
    _i66.Key? key,
    required int supplierId,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SupplySupplierContactCreateRoute.name,
          args: SupplySupplierContactCreateRouteArgs(
            key: key,
            supplierId: supplierId,
          ),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierContactCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SupplySupplierContactCreateRouteArgs>();
      return _i51.SupplySupplierContactCreatePage(
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

  final _i66.Key? key;

  final int supplierId;

  @override
  String toString() {
    return 'SupplySupplierContactCreateRouteArgs{key: $key, supplierId: $supplierId}';
  }
}

/// generated route for
/// [_i52.SupplySupplierContactEditPage]
class SupplySupplierContactEditRoute
    extends _i63.PageRouteInfo<SupplySupplierContactEditRouteArgs> {
  SupplySupplierContactEditRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierContactEditRouteArgs>(
          orElse: () =>
              SupplySupplierContactEditRouteArgs(id: pathParams.getInt('id')));
      return _i52.SupplySupplierContactEditPage(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierContactEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i53.SupplySupplierCreatePage]
class SupplySupplierCreateRoute extends _i63.PageRouteInfo<void> {
  const SupplySupplierCreateRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SupplySupplierCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupplySupplierCreateRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i53.SupplySupplierCreatePage();
    },
  );
}

/// generated route for
/// [_i54.SupplySupplierDetailContactPage]
class SupplySupplierDetailContactRoute
    extends _i63.PageRouteInfo<SupplySupplierDetailContactRouteArgs> {
  SupplySupplierDetailContactRoute({
    _i66.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailContactRoute.name,
          args: SupplySupplierDetailContactRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailContactRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailContactRouteArgs>(
          orElse: () => SupplySupplierDetailContactRouteArgs());
      return _i54.SupplySupplierDetailContactPage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailContactRouteArgs {
  const SupplySupplierDetailContactRouteArgs({this.key});

  final _i66.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailContactRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i55.SupplySupplierDetailInfoPage]
class SupplySupplierDetailInfoRoute
    extends _i63.PageRouteInfo<SupplySupplierDetailInfoRouteArgs> {
  SupplySupplierDetailInfoRoute({
    _i66.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailInfoRoute.name,
          args: SupplySupplierDetailInfoRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailInfoRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailInfoRouteArgs>(
          orElse: () => SupplySupplierDetailInfoRouteArgs());
      return _i55.SupplySupplierDetailInfoPage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailInfoRouteArgs {
  const SupplySupplierDetailInfoRouteArgs({this.key});

  final _i66.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailInfoRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i56.SupplySupplierDetailPage]
class SupplySupplierDetailRoute
    extends _i63.PageRouteInfo<SupplySupplierDetailRouteArgs> {
  SupplySupplierDetailRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailRouteArgs>(
          orElse: () =>
              SupplySupplierDetailRouteArgs(id: pathParams.getInt('id')));
      return _i56.SupplySupplierDetailPage(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierDetailRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i57.SupplySupplierDetailSamplePage]
class SupplySupplierDetailSampleRoute
    extends _i63.PageRouteInfo<SupplySupplierDetailSampleRouteArgs> {
  SupplySupplierDetailSampleRoute({
    _i66.Key? key,
    List<_i63.PageRouteInfo>? children,
  }) : super(
          SupplySupplierDetailSampleRoute.name,
          args: SupplySupplierDetailSampleRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SupplySupplierDetailSampleRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierDetailSampleRouteArgs>(
          orElse: () => SupplySupplierDetailSampleRouteArgs());
      return _i57.SupplySupplierDetailSamplePage(
        key: args.key,
        id: pathParams.getInt('id'),
      );
    },
  );
}

class SupplySupplierDetailSampleRouteArgs {
  const SupplySupplierDetailSampleRouteArgs({this.key});

  final _i66.Key? key;

  @override
  String toString() {
    return 'SupplySupplierDetailSampleRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i58.SupplySupplierEditPage]
class SupplySupplierEditRoute
    extends _i63.PageRouteInfo<SupplySupplierEditRouteArgs> {
  SupplySupplierEditRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<SupplySupplierEditRouteArgs>(
          orElse: () =>
              SupplySupplierEditRouteArgs(id: pathParams.getInt('id')));
      return _i58.SupplySupplierEditPage(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'SupplySupplierEditRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i59.SupplySupplierPage]
class SupplySupplierRoute extends _i63.PageRouteInfo<void> {
  const SupplySupplierRoute({List<_i63.PageRouteInfo>? children})
      : super(
          SupplySupplierRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupplySupplierRoute';

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      return const _i59.SupplySupplierPage();
    },
  );
}

/// generated route for
/// [_i60.WmsDeliveryPage]
class WmsDeliveryRoute extends _i63.PageRouteInfo<WmsDeliveryRouteArgs> {
  WmsDeliveryRoute({
    _i66.Key? key,
    required String code,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsDeliveryRouteArgs>(
          orElse: () =>
              WmsDeliveryRouteArgs(code: pathParams.getString('code')));
      return _i60.WmsDeliveryPage(
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

  final _i66.Key? key;

  final String code;

  @override
  String toString() {
    return 'WmsDeliveryRouteArgs{key: $key, code: $code}';
  }
}

/// generated route for
/// [_i61.WmsTransferConfirmPage]
class WmsTransferConfirmRoute
    extends _i63.PageRouteInfo<WmsTransferConfirmRouteArgs> {
  WmsTransferConfirmRoute({
    _i66.Key? key,
    required int id,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsTransferConfirmRouteArgs>(
          orElse: () =>
              WmsTransferConfirmRouteArgs(id: pathParams.getInt('id')));
      return _i61.WmsTransferConfirmPage(
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

  final _i66.Key? key;

  final int id;

  @override
  String toString() {
    return 'WmsTransferConfirmRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i62.WmsTransferPage]
class WmsTransferRoute extends _i63.PageRouteInfo<WmsTransferRouteArgs> {
  WmsTransferRoute({
    _i66.Key? key,
    required String code,
    List<_i63.PageRouteInfo>? children,
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

  static _i63.PageInfo page = _i63.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<WmsTransferRouteArgs>(
          orElse: () =>
              WmsTransferRouteArgs(code: pathParams.getString('code')));
      return _i62.WmsTransferPage(
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

  final _i66.Key? key;

  final String code;

  @override
  String toString() {
    return 'WmsTransferRouteArgs{key: $key, code: $code}';
  }
}

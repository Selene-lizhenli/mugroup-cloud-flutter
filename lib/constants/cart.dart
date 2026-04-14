import 'package:flant/components/action_sheet.dart';

const borrowReasons = [
  FlanActionSheetAction(name: '客户会议用'),
  FlanActionSheetAction(name: '客户选中，核价报价用'),
  FlanActionSheetAction(name: '展会使用'),
  FlanActionSheetAction(name: '本组出货样'),
  FlanActionSheetAction(name: '其他'),
];

const currencies = [
  FlanActionSheetAction(name: 'CNY'),
  FlanActionSheetAction(name: 'USD'),
  FlanActionSheetAction(name: 'EUR'),
  FlanActionSheetAction(name: 'GBP'),
];

const stockInOptions = <Map<String, String>>[
  {'stockInName': '交样入库', 'type': 'submission_in'},
  {'stockInName': '采购入库', 'type': 'purchase'},
  {'stockInName': '移除入库', 'type': 'remove'},
  {'stockInName': '退货入库', 'type': 'return'},
  {'stockInName': '其他入库', 'type': 'other'},
  {'stockInName': '客户取消订单', 'type': 'cancel'},
  {'stockInName': '调拨入库', 'type': 'transfer_in'},
  {'stockInName': '还样入库', 'type': 'borrow_in'},
  {'stockInName': '盘点入库', 'type': 'inventory_in'},
];

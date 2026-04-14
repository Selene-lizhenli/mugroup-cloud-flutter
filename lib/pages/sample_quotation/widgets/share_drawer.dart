import 'package:cloud/config/config.dart';
import 'package:cloud/models/quote/export_template.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/utils/local_download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart'; 

class NavigatorKey {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

/// Shows download options for a quotation and performs the chosen download.
Future<void> showQuotationDownloadSheet({
  required BuildContext context,
  required QuotationList item,
  required List<String> permissions,
  required List<ExportTemplate> dynamicTemplates,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: false,
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;

      Widget tile({
        required String title,
        IconData icon = Icons.download_outlined,
        required String path,
        required Map<String, String> queryParameters,
        required String filename,
      }) {
        return ListTile(
          leading: Icon(icon),
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          onTap: () => _downloadExportFromPath(
            item: item,
            path: path,
            queryParameters: queryParameters,
            filename: filename,
            context: context,
          ),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '请选择下载模版',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 253, 250, 243),
                          fontSize: 16,
                        ),
                  ),
                  if (item.quoteNo != null)
                    Text(
                      '(${item.quoteNo!})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontSize: 14,
                          ),
                    ),
                ],
              )),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                // 报价单二维码：这里默认展示（如需权限可再加判断）
                ListTile(
                  leading: const Icon(Icons.qr_code_2),
                  title: Text('报价单二维码',
                      style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () =>
                      _showQuotationQrDialog(context: context, item: item),
                ),
                // 产品图片(以SKU为文件) / (无文件夹)
                if (permissions.contains('showroom.sample.exportImage')) ...[
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/exportImages',
                    queryParameters: const {},
                    filename: '产品图片_${item.quoteNo ?? item.id}.zip',
                    title: '产品图片(以SKU为文件)',
                    icon: Icons.folder_copy_outlined,
                  ),
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/exportImages',
                    queryParameters: const {'type': 'flat'},
                    filename: '产品图片_${item.quoteNo ?? item.id}.zip',
                    title: '产品图片(无文件夹)',
                    icon: Icons.photo_library_outlined,
                  ),
                ],
                // 报价单(pdf)
                // if (permissions.contains('showroom.quotation.export.baojiaPdf'))
                //   tile(
                //     action: _QuotationDownloadAction.quotationPdf,
                //     title: '报价单(pdf)',
                //     icon: Icons.picture_as_pdf_outlined,
                //   ),
                // 极越报价单(xlsx)
                if (permissions
                    .contains('showroom.quotation.export.jybaojiaExcel'))
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/export',
                    queryParameters: const {'template': 'jybjd'},
                    filename: '极越报价单_${item.quoteNo ?? item.id}_jybjd.xlsx',
                    title: '极越报价单(xlsx)',
                    icon: Icons.table_chart_outlined,
                  ),
                // 义荣报价单(xlsx)
                if (permissions
                    .contains('showroom.quotation.export.yrbaojiaExcel'))
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/export',
                    queryParameters: const {'template': 'yrbjd'},
                    filename: '义荣报价单_${item.quoteNo ?? item.id}_yirong.xlsx',
                    title: '义荣报价单(xlsx)',
                    icon: Icons.table_chart_outlined,
                  ),
                // 通西报价单(xlsx)
                if (permissions
                    .contains('showroom.quotation.export.txbaojiaExcel'))
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/export',
                    queryParameters: const {'template': 'txbjd'},
                    filename: '通西报价单_${item.quoteNo ?? item.id}_txbjd.xlsx',
                    title: '通西报价单(xlsx)',
                    icon: Icons.table_chart_outlined,
                  ),
                // 采购清单(pdf)
                // if (permissions.contains('showroom.quotation.export.caigouPdf'))
                //   tile(
                //     action: _QuotationDownloadAction.purchaseListPdf,
                //     title: '采购清单(pdf)',
                //     icon: Icons.picture_as_pdf_outlined,
                //   ),
                // 报价单(xlsx)
                if (permissions
                    .contains('showroom.quotation.export.baojiaExcel'))
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/export',
                    queryParameters: const {'template': 'bjd'},
                    filename: '报价单_${item.quoteNo ?? item.id}_quotation.xlsx',
                    title: '报价单(xlsx)',
                    icon: Icons.table_chart_outlined,
                  ),
                // 出货清单(xlsx)
                if (permissions
                    .contains('showroom.quotation.export.chuhuoExcel'))
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/export',
                    queryParameters: const {'template': 'chqd'},
                    filename:
                        '出货清单_${item.quoteNo ?? item.id}_shipment_list.xlsx',
                    title: '出货清单(xlsx)',
                    icon: Icons.table_chart_outlined,
                  ),

                // MM 报价相关
                if (permissions.contains('showroom.quotation.export.mm')) ...[
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/mm_export',
                    filename: 'MM报价单_${item.quoteNo ?? item.id}_mm.xlsx',
                    title: 'MM报价单',
                    queryParameters: const {},
                    icon: Icons.table_chart_outlined,
                  ),
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/mm_export',
                    queryParameters: const {'template': 'mm-order-list'},
                    filename:
                        'MM报价单_${item.quoteNo ?? item.id}_mm_order_list.xlsx',
                    title: 'MM Order List',
                    icon: Icons.table_chart_outlined,
                  ),
                ],
                // 产品明细(xlsx)
                if (permissions.contains('showroom.quotation.export.cpmx'))
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/export',
                    queryParameters: const {'template': 'cpmx'},
                    filename:
                        '产品明细_${item.quoteNo ?? item.id}_product_detail.xlsx',
                    title: '产品明细(xlsx)',
                    icon: Icons.table_chart_outlined,
                  ),
                // 出货清单-含保密信息(xlsx)
                if (permissions
                    .contains('showroom.quotation.export.admin.chuhuoExcel'))
                  tile(
                    path: 'api/tenant/showroom/quotations/{id}/admin_export',
                    filename:
                        '出货清单-含保密信息_${item.quoteNo ?? item.id}_shipment_list_admin.xlsx',
                    title: '出货清单-含保密信息(xlsx)',
                    queryParameters: const {},
                    icon: Icons.table_chart_outlined,
                  ),
                //奕派模板
                if (permissions
                    .contains('showroom.quotation.export.yipai')) ...[
                  tile(
                    title: '报价单(xlsx)',
                    icon: Icons.table_chart_outlined,
                    path: 'api/tenant/showroom/quotations/{id}/yipai_export',
                    filename: '报价单_${item.quoteNo ?? item.id}_yipai.xlsx',
                    queryParameters: const {},
                  ),
                  tile(
                    title: '市场记录报价单(xlsx)',
                    icon: Icons.table_chart_outlined,
                    path: 'api/tenant/showroom/quotations/{id}/yipai_export',
                    queryParameters: const {'template': 'shichangjilu'},
                    filename: '市场记录报价单_${item.quoteNo ?? item.id}_yipai.xlsx',
                  ),
                ],
                // 动态导出模板（接口返回的 export templates）
                for (final t in dynamicTemplates)
                  if ((t.key ?? '').trim().isNotEmpty)
                    tile(
                      title: t.label?.trim().isNotEmpty == true
                          ? t.label!.trim()
                          : t.key!.trim(),
                      icon: Icons.table_chart_outlined,
                      path: 'api/tenant/showroom/quotations/{id}/export',
                      queryParameters: {'template': t.key!.trim()},
                      filename:
                          '${_safeFileNamePart(t.label ?? t.key ?? "template")}_${item.quoteNo ?? item.id}.xlsx',
                    ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

String _quoteDirName(QuotationList item) =>
    'quotation_${item.quoteNo ?? item.id ?? "unknown"}';

String _safeFileNamePart(String input) {
  // Replace characters that are invalid in file names on most platforms.
  return input
      .trim()
      .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
      .replaceAll(RegExp(r'\s+'), '_');
}

String _quotationQrValue(QuotationList item) {
  final quoteNo = item.quoteNo;
  if (quoteNo == null || quoteNo.isEmpty) return '';

  final base = Config.coreApiUrl.trim();
  final normalizedBase =
      base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  return '$normalizedBase/showroom/quotations/$quoteNo';
}

Future<void> _showQuotationQrDialog({
  required BuildContext context,
  required QuotationList item,
}) async {
  final value = _quotationQrValue(item);
  if (value.isEmpty) {
    EasyLoading.showInfo('缺少报价单号，无法生成二维码');
    return;
  }

  await showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '报价单二维码',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: QrImageView(
                    data: value,
                    size: 180,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('请使用PDA扫码'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('关闭'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _downloadExportFromPath({
  required QuotationList item,
  required String path,
  Map<String, String>? queryParameters,
  required String filename,
  required BuildContext context,
}) async {
  final quoteId = item.id;
  if (quoteId == null) {
    EasyLoading.showInfo('缺少报价单ID，无法下载文件');
    return;
  }
  BuildContext? dialogContext;

  // 直接用传入的 context，不依赖全局key
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      dialogContext = ctx;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('正在下载中,请稍后....'),
            ],
          ),
        ),
      );
    },
  );

  try {
    final apiPath = path.replaceAll('{id}', '$quoteId');
    final base = Config.coreApiUrl.trim();
    final normalizedBase =
        base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final resolvedPath = '$normalizedBase/$apiPath';

    final bytes = await downloadApiBytes(
      resolvedPath,
      queryParameters: queryParameters,
    );
    final result = await saveBytesToDownloads(
      bytes,
      filename: filename,
      subDir: _quoteDirName(item),
    );
    // 关闭弹窗
    if (dialogContext != null && Navigator.canPop(dialogContext!)) {
      Navigator.pop(dialogContext!);
    }
    EasyLoading.showSuccess('已下载到本地：${result.path}');

    // 分享
    await Share.shareXFiles(
      [XFile(result.path)],
      text: '这是报价单 ${item.quoteNo ?? item.id} 的文件',
      subject: filename,
      sharePositionOrigin: _sharePositionOrigin(context),
    );
  } catch (e) { 
    if (dialogContext != null && Navigator.canPop(dialogContext!)) {
      Navigator.pop(dialogContext!);
    }
    EasyLoading.showError('下载失败：$e');
  }
}

Rect _sharePositionOrigin(BuildContext context) {
  // iPad 上系统 ShareSheet 需要一个非零的锚点 Rect，否则会抛 PlatformException。
  // 优先使用当前 context 的 RenderBox；如果拿不到/为 0，则用 Overlay 中心点兜底。
  final overlayBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
  final overlaySize = overlayBox?.size;

  Rect fallback() {
    final size = overlaySize ?? MediaQuery.sizeOf(context);
    final center = Offset(size.width / 2, size.height / 2);
    return Rect.fromCenter(center: center, width: 1, height: 1);
  }

  final object = context.findRenderObject();
  if (object is! RenderBox) return fallback();

  final size = object.size;
  if (size.isEmpty) return fallback();

  final topLeft = (overlayBox != null)
      ? object.localToGlobal(Offset.zero, ancestor: overlayBox)
      : object.localToGlobal(Offset.zero);
  final rect = topLeft & size;

  if (rect.width <= 0 || rect.height <= 0) return fallback();
  return rect;
}

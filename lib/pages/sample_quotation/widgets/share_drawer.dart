import 'package:cloud/config/config.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/sample_quotation/sample_quotation_l10n_helper.dart';
import 'package:cloud/models/quote/export_template.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/services/supply.dart';
import 'package:cloud/utils/local_download.dart';
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

enum _ExportType {
  supplier,
  time,
}

String _truncateForToast(String input, {int max = 200}) {
  final s = input.trim();
  if (s.length <= max) return s;
  return '${s.substring(0, max)}...';
}

String? _tryExtractMessageFromJsonString(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return null;
  if (!(s.startsWith('{') && s.endsWith('}'))) return null;
  try {
    final obj = jsonDecode(s);
    if (obj is Map) {
      final m = obj['message'];
      if (m is String && m.trim().isNotEmpty) return m.trim();
    }
  } catch (_) {}
  return null;
}

class NavigatorKey {
  static final navigatorKey = GlobalKey<NavigatorState>();
}

/// Shows download options for a quotation and performs the chosen download.
Future<void> showQuotationDownloadSheet({
  required BuildContext context,
  required QuotationList item,
  required List<String> permissions,
  required List<ExportTemplate> dynamicTemplates,
  String from = '', //抽屉在哪个模块打开的,用于判断是否显示供应商和时间选择
}) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: false,
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      final sheetL10n = context.l10n;
      _ExportType? exportType;
      DateTime? startDateTime;
      DateTime? endDateTime;
      List<Supplier> selectedSuppliers = [];

      Widget tile({
        required String title,
        IconData icon = Icons.download_outlined,
        required String path,
        required Map<String, dynamic> queryParameters,
        required String filename,
      }) {
        Map<String, dynamic> buildExtraFilters() {
          final extra = <String, dynamic>{};

          if (exportType == _ExportType.time) {
            final now = _dateFloor(DateTime.now());
            DateTime? resolvedStart = startDateTime;
            DateTime? resolvedEnd = endDateTime;

            if (resolvedStart != null && resolvedEnd == null) {
              resolvedEnd = now;
            } else if (resolvedStart == null && resolvedEnd != null) {
              resolvedStart = _dateFloor(
                now.subtract(const Duration(days: 365)),
              );
            }

            if (resolvedStart != null && resolvedEnd != null) {
              extra['created_at[0]'] = _formatDateOnly(resolvedStart);
              extra['created_at[1]'] = _formatDateOnly(resolvedEnd);
            }
          } else if (exportType == _ExportType.supplier) {
            for (int i = 0; i < selectedSuppliers.length; i++) {
              final id = selectedSuppliers[i].id;
              if (id == null) continue;
              extra['supplier_ids[$i]'] = id;
            }
          }

          return extra;
        }

        return ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: Icon(icon),
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {
            final merged = <String, dynamic>{...queryParameters};
            merged.addAll(buildExtraFilters());
            final exportTypeText = exportType == _ExportType.supplier
                ? sheetL10n.quoteExportBySupplier
                : (exportType == _ExportType.time
                    ? sheetL10n.quoteExportByTime
                    : null);
            final resolvedFilename = exportTypeText == null
                ? filename
                : _appendSuffixBeforeExtension(filename, exportTypeText);

            _downloadExportFromPath(
              item: item,
              path: path,
              queryParameters: merged,
              filename: resolvedFilename,
              context: context,
            );
          },
        );
      }

      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: StatefulBuilder(
          builder: (context, setState) {
            final l10n = context.l10n;

            Future<void> onExportTypeSelected(_ExportType chosen) async {
              setState(() {
                exportType = chosen;
                // reset dependent value when switching type
                selectedSuppliers = [];
                startDateTime = null;
                endDateTime = null;
              });
            }

            Future<void> pickSupplier() async {
              final quoteId = item.id;
              if (quoteId == null) {
                EasyLoading.showInfo(l10n.quoteMissingIdForSupplier);
                return;
              }

              final suppliers = await _showSupplierPickerSheet(
                context: context,
                quotationId: quoteId,
                selectedSupplierIds: selectedSuppliers
                    .map((e) => e.id)
                    .whereType<int>()
                    .toList(),
              );
              if (suppliers == null) return;
              setState(() {
                selectedSuppliers = suppliers;
              });
            }

            Future<void> pickStart() async {
              final now = DateTime.now();
              final min = _dateFloor(now.subtract(const Duration(days: 365)));
              final max = _dateFloor(endDateTime ?? now);
              final current = _dateFloor(startDateTime ?? now);

              final dt = await _pickDateWithinLastYear(
                context: context,
                minTime: min,
                maxTime: max,
                currentTime: current.isAfter(max) ? max : current,
              );
              if (dt == null) return;
              setState(() {
                startDateTime = dt;
                if (endDateTime != null && endDateTime!.isBefore(dt)) {
                  endDateTime = dt;
                }
              });
            }

            Future<void> pickEnd() async {
              final now = DateTime.now();
              final minDefault =
                  _dateFloor(now.subtract(const Duration(days: 365)));
              final min = _dateFloor(startDateTime ?? minDefault);
              final max = _dateFloor(now);
              final current = _dateFloor(endDateTime ?? now);

              final dt = await _pickDateWithinLastYear(
                context: context,
                minTime: min,
                maxTime: max,
                currentTime: current.isBefore(min) ? min : current,
              );
              if (dt == null) return;
              if (startDateTime != null && dt.isBefore(startDateTime!)) {
                EasyLoading.showInfo(l10n.quoteEndBeforeStart);
                return;
              }
              setState(() {
                endDateTime = dt;
              });
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
                          l10n.quoteSelectDownloadMethod,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 253, 250, 243),
                                fontSize: 16,
                              ),
                        ),
                        if (item.quoteNo != null)
                          Text(
                            '(${item.quoteNo!})',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
                      if (from == 'market') ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 56,
                                child: Text(
                                  l10n.quoteTypeLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 16,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () => onExportTypeSelected(
                                            _ExportType.supplier,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Radio<_ExportType>(
                                                value: _ExportType.supplier,
                                                groupValue: exportType,
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                onChanged: (v) {
                                                  if (v == null) return;
                                                  onExportTypeSelected(v);
                                                },
                                                fillColor: WidgetStateProperty
                                                    .resolveWith<Color>(
                                                  (Set<WidgetState> states) {
                                                    if (states.contains(
                                                        WidgetState.selected)) {
                                                      return colorScheme
                                                          .primary;
                                                    }
                                                    return colorScheme.onSurface
                                                        .withOpacity(0.45);
                                                  },
                                                ),
                                              ),
                                              Text(l10n.quoteExportBySupplier),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => onExportTypeSelected(
                                              _ExportType.time),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Radio<_ExportType>(
                                                value: _ExportType.time,
                                                groupValue: exportType,
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                onChanged: (v) {
                                                  if (v == null) return;
                                                  onExportTypeSelected(v);
                                                },
                                                fillColor: WidgetStateProperty
                                                    .resolveWith<Color>(
                                                  (Set<WidgetState> states) {
                                                    if (states.contains(
                                                        WidgetState.selected)) {
                                                      return colorScheme
                                                          .primary;
                                                    }
                                                    return colorScheme.onSurface
                                                        .withOpacity(0.45);
                                                  },
                                                ),
                                              ),
                                              Text(l10n.quoteExportByTime),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (exportType == _ExportType.supplier) ...[
                                      const SizedBox(height: 8),
                                      _TimeSelectRow(
                                        label: l10n.quoteSupplierLabel,
                                        valueText: selectedSuppliers.isEmpty
                                            ? l10n.quoteSelectSupplier
                                            : selectedSuppliersLocalizedText(
                                                context,
                                                selectedSuppliers,
                                              ),
                                        isPlaceholder:
                                            selectedSuppliers.isEmpty,
                                        onTap: pickSupplier,
                                      ),
                                    ],
                                    if (exportType == _ExportType.time) ...[
                                      const SizedBox(height: 8),
                                      _TimeSelectRow(
                                        label: l10n.quoteStartDate,
                                        valueText: startDateTime == null
                                            ? l10n.quoteSelectStartDate
                                            : _formatDateOnly(startDateTime!),
                                        isPlaceholder: startDateTime == null,
                                        onTap: pickStart,
                                      ),
                                      const SizedBox(height: 8),
                                      _TimeSelectRow(
                                        label: l10n.quoteEndDate,
                                        valueText: endDateTime == null
                                            ? l10n.quoteSelectEndDate
                                            : _formatDateOnly(endDateTime!),
                                        isPlaceholder: endDateTime == null,
                                        onTap: pickEnd,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (from == 'market') ...[
                              SizedBox(
                                width: 56,
                                child: Text(
                                  l10n.quoteTemplateLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // 报价单二维码：这里默认展示（如需权限可再加判断）
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.qr_code_2),
                                    title: Text(
                                      l10n.quoteQrCode,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    onTap: () => _showQuotationQrDialog(
                                      context: context,
                                      item: item,
                                    ),
                                  ),
                                  // 产品图片(以SKU为文件) / (无文件夹)
                                  if (permissions.contains(
                                      'showroom.sample.exportImage')) ...[
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/exportImages',
                                      queryParameters: const <String,
                                          dynamic>{},
                                      filename:
                                          '产品图片_${item.quoteNo ?? item.id}.zip',
                                      title: l10n.quoteProductImagesSku,
                                      icon: Icons.folder_copy_outlined,
                                    ),
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/exportImages',
                                      queryParameters: const <String, dynamic>{
                                        'type': 'flat'
                                      },
                                      filename:
                                          '产品图片_${item.quoteNo ?? item.id}.zip',
                                      title: l10n.quoteProductImagesFlat,
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
                                  if (permissions.contains(
                                      'showroom.quotation.export.jybaojiaExcel'))
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/export',
                                      queryParameters: const <String, dynamic>{
                                        'template': 'jybjd'
                                      },
                                      filename:
                                          '极越报价单_${item.quoteNo ?? item.id}_jybjd.xlsx',
                                      title: l10n.quoteJyExcel,
                                      icon: Icons.table_chart_outlined,
                                    ),
                                  // 义荣报价单(xlsx)
                                  if (permissions.contains(
                                      'showroom.quotation.export.yrbaojiaExcel'))
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/export',
                                      queryParameters: const <String, dynamic>{
                                        'template': 'yrbjd'
                                      },
                                      filename:
                                          '义荣报价单_${item.quoteNo ?? item.id}_yirong.xlsx',
                                      title: l10n.quoteYrExcel,
                                      icon: Icons.table_chart_outlined,
                                    ),
                                  // 通西报价单(xlsx)
                                  if (permissions.contains(
                                      'showroom.quotation.export.txbaojiaExcel'))
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/export',
                                      queryParameters: const <String, dynamic>{
                                        'template': 'txbjd'
                                      },
                                      filename:
                                          '通西报价单_${item.quoteNo ?? item.id}_txbjd.xlsx',
                                      title: l10n.quoteTxExcel,
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
                                  if (permissions.contains(
                                      'showroom.quotation.export.baojiaExcel'))
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/export',
                                      queryParameters: const <String, dynamic>{
                                        'template': 'bjd'
                                      },
                                      filename:
                                          '报价单_${item.quoteNo ?? item.id}_quotation.xlsx',
                                      title: l10n.quoteQuotationExcel,
                                      icon: Icons.table_chart_outlined,
                                    ),
                                  // 出货清单(xlsx)
                                  if (permissions.contains(
                                      'showroom.quotation.export.chuhuoExcel'))
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/export',
                                      queryParameters: const <String, dynamic>{
                                        'template': 'chqd'
                                      },
                                      filename:
                                          '出货清单_${item.quoteNo ?? item.id}_shipment_list.xlsx',
                                      title: l10n.quoteShipmentListExcel,
                                      icon: Icons.table_chart_outlined,
                                    ),

                                  // MM 报价相关
                                  if (permissions.contains(
                                      'showroom.quotation.export.mm')) ...[
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/mm_export',
                                      filename:
                                          'MM报价单_${item.quoteNo ?? item.id}_mm.xlsx',
                                      title: l10n.quoteMmQuotation,
                                      queryParameters: const <String,
                                          dynamic>{},
                                      icon: Icons.table_chart_outlined,
                                    ),
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/mm_export',
                                      queryParameters: const <String, dynamic>{
                                        'template': 'mm-order-list'
                                      },
                                      filename:
                                          'MM报价单_${item.quoteNo ?? item.id}_mm_order_list.xlsx',
                                      title: 'MM Order List',
                                      icon: Icons.table_chart_outlined,
                                    ),
                                  ],
                                  // 产品明细(xlsx)
                                  if (permissions.contains(
                                      'showroom.quotation.export.cpmx'))
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/export',
                                      queryParameters: const <String, dynamic>{
                                        'template': 'cpmx'
                                      },
                                      filename:
                                          '产品明细_${item.quoteNo ?? item.id}_product_detail.xlsx',
                                      title: l10n.quoteProductDetailExcel,
                                      icon: Icons.table_chart_outlined,
                                    ),
                                  // 出货清单-含保密信息(xlsx)
                                  if (permissions.contains(
                                      'showroom.quotation.export.admin.chuhuoExcel'))
                                    tile(
                                      path:
                                          'api/tenant/showroom/quotations/{id}/admin_export',
                                      filename:
                                          '出货清单-含保密信息_${item.quoteNo ?? item.id}_shipment_list_admin.xlsx',
                                      title: l10n.quoteShipmentListAdminExcel,
                                      queryParameters: const <String,
                                          dynamic>{},
                                      icon: Icons.table_chart_outlined,
                                    ),
                                  //奕派模板
                                  if (permissions.contains(
                                      'showroom.quotation.export.yipai')) ...[
                                    tile(
                                      title: l10n.quoteQuotationExcel,
                                      icon: Icons.table_chart_outlined,
                                      path:
                                          'api/tenant/showroom/quotations/{id}/yipai_export',
                                      filename:
                                          '报价单_${item.quoteNo ?? item.id}_yipai.xlsx',
                                      queryParameters: const <String,
                                          dynamic>{},
                                    ),
                                    tile(
                                      title: l10n.quoteMarketRecordExcel,
                                      icon: Icons.table_chart_outlined,
                                      path:
                                          'api/tenant/showroom/quotations/{id}/yipai_export',
                                      queryParameters: const <String, dynamic>{
                                        'template': 'shichangjilu'
                                      },
                                      filename:
                                          '市场记录报价单_${item.quoteNo ?? item.id}_yipai.xlsx',
                                    ),
                                  ],
                                  // 动态导出模板（接口返回的 export templates）
                                  for (final t in dynamicTemplates)
                                    if ((t.key ?? '').trim().isNotEmpty)
                                      tile(
                                        title:
                                            t.label?.trim().isNotEmpty == true
                                                ? t.label!.trim()
                                                : t.key!.trim(),
                                        icon: Icons.table_chart_outlined,
                                        path:
                                            'api/tenant/showroom/quotations/{id}/export',
                                        queryParameters: {
                                          'template': t.key!.trim()
                                        },
                                        filename:
                                            '${_safeFileNamePart(t.label ?? t.key ?? "template")}_${item.quoteNo ?? item.id}.xlsx',
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
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

String _appendSuffixBeforeExtension(String filename, String suffix) {
  final safeSuffix = _safeFileNamePart(suffix);
  final dot = filename.lastIndexOf('.');
  if (dot <= 0 || dot == filename.length - 1) {
    return '${filename}_$safeSuffix';
  }
  final name = filename.substring(0, dot);
  final ext = filename.substring(dot);
  return '${name}_$safeSuffix$ext';
}

String _quotationQrValue(QuotationList item) {
  final quoteNo = item.quoteNo;
  if (quoteNo == null || quoteNo.isEmpty) return '';

  final base = Config.coreApiUrl.trim();
  final normalizedBase =
      base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  return '$normalizedBase/showroom/quotations/$quoteNo';
}

String _formatDateOnly(DateTime dt) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
}

DateTime _dateFloor(DateTime dt) => DateTime(
      dt.year,
      dt.month,
      dt.day,
    );

class _TimeSelectRow extends StatelessWidget {
  final String label;
  final String valueText;
  final bool isPlaceholder;
  final VoidCallback onTap;

  const _TimeSelectRow({
    required this.label,
    required this.valueText,
    this.isPlaceholder = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: textTheme.bodyMedium),
        ),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.6),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      valueText,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: isPlaceholder
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 选择供应商抽屉
Future<List<Supplier>?> _showSupplierPickerSheet({
  required BuildContext context,
  required int quotationId,
  required List<int> selectedSupplierIds,
}) async {
  return showModalBottomSheet<List<Supplier>>(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      final height = MediaQuery.of(context).size.height * 0.6;
      List<Supplier>? suppliers;
      bool isLoading = true;
      bool hasFetched = false;
      final selectedIds = selectedSupplierIds.toSet();

      Future<void> fetch(StateSetter setModalState) async {
        try {
          setModalState(() => isLoading = true);
          final resp = await getSupplySuppliers(queryParameters: {
            "quotation_id": quotationId,
          });
          suppliers = resp.data;
        } finally {
          setModalState(() => isLoading = false);
        }
      }

      return StatefulBuilder(
        builder: (context, setModalState) {
          final l10n = context.l10n;

          // 每次抽屉打开后仅请求一次
          if (!hasFetched) {
            hasFetched = true;
            scheduleMicrotask(() => fetch(setModalState));
          }

          return SizedBox(
            height: height,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.quoteSelectSupplierTitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final all = suppliers ?? const <Supplier>[];
                          final picked = all
                              .where((s) =>
                                  s.id != null && selectedIds.contains(s.id))
                              .toList();
                          Navigator.of(context).pop(picked);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          selectedIds.isEmpty
                              ? l10n.quoteConfirm
                              : l10n.quoteConfirmSelected(selectedIds.length),
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : (suppliers == null || suppliers!.isEmpty)
                          ? Center(
                              child: Text(
                                l10n.noData,
                                style: TextStyle(
                                  color: colorScheme.outline,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: suppliers!.length,
                              itemBuilder: (context, index) {
                                final s = suppliers![index];
                                final name = s.shortName ??
                                    s.name ??
                                    l10n.quoteUnknownSupplier;
                                final isSelected =
                                    s.id != null && selectedIds.contains(s.id);
                                return ListTile(
                                  title: Text(name),
                                  trailing: isSelected
                                      ? const Icon(Icons.check)
                                      : null,
                                  onTap: () {
                                    final id = s.id;
                                    if (id == null) return;
                                    setModalState(() {
                                      if (selectedIds.contains(id)) {
                                        selectedIds.remove(id);
                                      } else {
                                        selectedIds.add(id);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<DateTime?> _pickDateWithinLastYear({
  required BuildContext context,
  DateTime? minTime,
  DateTime? maxTime,
  DateTime? currentTime,
}) async {
  final now = _dateFloor(DateTime.now());
  final defaultMin = _dateFloor(now.subtract(const Duration(days: 365)));
  final min = _dateFloor(minTime ?? defaultMin);
  final max = _dateFloor(maxTime ?? now);
  final current = _dateFloor(currentTime ?? max);

  if (max.isBefore(min)) {
    EasyLoading.showInfo(context.l10n.quoteInvalidTimeRange);
    return null;
  }

  final completer = Completer<DateTime?>();
  final colorScheme = Theme.of(context).colorScheme;
  final dateLocale = Localizations.localeOf(context).languageCode == 'en'
      ? LocaleType.en
      : LocaleType.zh;

  DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime: min,
    maxTime: max,
    currentTime:
        current.isBefore(min) ? min : (current.isAfter(max) ? max : current),
    locale: dateLocale,
    theme: DatePickerTheme(
      headerColor: Colors.white,
      backgroundColor: Colors.white,
      itemStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      doneStyle: TextStyle(color: colorScheme.primary, fontSize: 16),
      cancelStyle: const TextStyle(color: Colors.grey, fontSize: 16),
    ),
    onConfirm: (date) {
      if (!completer.isCompleted) completer.complete(_dateFloor(date));
    },
    onCancel: () {
      if (!completer.isCompleted) completer.complete(null);
    },
  );

  return completer.future;
}

Future<void> _showQuotationQrDialog({
  required BuildContext context,
  required QuotationList item,
}) async {
  final value = _quotationQrValue(item);
  if (value.isEmpty) {
    EasyLoading.showInfo(context.l10n.quoteMissingQuoteNoForQr);
    return;
  }

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final l10n = dialogContext.l10n;
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.quoteQrCode,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              Text(l10n.quoteScanWithPda),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.quoteClose),
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
  Map<String, dynamic>? queryParameters,
  required String filename,
  required BuildContext context,
}) async {
  final l10n = context.l10n;
  final quoteId = item.id;
  if (quoteId == null) {
    EasyLoading.showInfo(l10n.quoteMissingIdForDownload);
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(ctx.l10n.quoteDownloading),
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
    EasyLoading.showSuccess(l10n.quoteDownloadedTo(result.path));

    // 分享
    await Share.shareXFiles(
      [XFile(result.path)],
      text: l10n.quoteShareFileText('${item.quoteNo ?? item.id}'),
      subject: filename,
      sharePositionOrigin: _sharePositionOrigin(context),
    );
  } catch (e) {
    if (dialogContext != null && Navigator.canPop(dialogContext!)) {
      Navigator.pop(dialogContext!);
    }
    if (e is DioException) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      String? serverMsg;
      if (data is Map) {
        final m = data['message'];
        if (m is String && m.trim().isNotEmpty) serverMsg = m.trim();
      } else if (data is String) {
        serverMsg = _tryExtractMessageFromJsonString(data) ?? data.trim();
        if (serverMsg.isEmpty) serverMsg = null;
      } else if (data is List<int>) {
        try {
          final raw = utf8.decode(data, allowMalformed: true).trim();
          final m = _tryExtractMessageFromJsonString(raw) ?? raw;
          if (m.trim().isNotEmpty) serverMsg = m.trim();
        } catch (_) {}
      }

      EasyLoading.showError(
        _truncateForToast(
          l10n.quoteDownloadFailed(
            status == null ? '' : '($status)',
            serverMsg ?? e.message ?? e.toString(),
          ),
        ),
      );
      return;
    }
    EasyLoading.showError(l10n.quoteDownloadFailedSimple('$e'));
  }
}

Rect _sharePositionOrigin(BuildContext context) {
  // iPad 上系统 ShareSheet 需要一个非零的锚点 Rect，否则会抛 PlatformException。
  // 优先使用当前 context 的 RenderBox；如果拿不到/为 0，则用 Overlay 中心点兜底。
  final overlayBox =
      Overlay.of(context).context.findRenderObject() as RenderBox?;
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

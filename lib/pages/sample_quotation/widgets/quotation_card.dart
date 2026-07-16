import 'package:cloud/constants/samples.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/sample_quotation/sample_quotation_l10n_helper.dart';
import 'package:cloud/models/quote/export_template.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/sample_quotation/widgets/share_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SampleQuotationCard extends ConsumerWidget {
  const SampleQuotationCard({
    super.key,
    required this.item,
    this.onTap,
    required this.dynamicTemplates,
    required this.permissions,
  });

  final QuotationList item;
  final void Function()? onTap;
  final List<ExportTemplate> dynamicTemplates;
  final List<String> permissions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final statusColor =
        sampleApprovalStatusColor(item.status, fallback: colorScheme.onSurface);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6, top: 3),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1.0,
            ),
            right: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1.0,
            ),
            top: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: colorScheme.surface,
          gradient: LinearGradient(
            begin: Alignment.topRight, // 起点：右上角
            end: Alignment.bottomCenter, // 终点：左下角
            colors: [
              Color.lerp(
                colorScheme.primary.withOpacity(0.01),
                colorScheme.surfaceContainer,
                0.93,
              )!,
              colorScheme.surface,
              colorScheme.surface,
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: Color(0xFFFC8E5B),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            formatDateTimeFull(item.quoteAt),
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  sampleApprovalStatusLocalizedText(
                                    context,
                                    item.status,
                                  ),
                                  style: TextStyle(
                                      color: statusColor, fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Spacer(),
                          if (item.sumQty != null) ...[
                            Container(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              decoration: BoxDecoration(
                                color: colorScheme.error.withOpacity(0.1),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${item.sumQty ?? ""} ',
                                    style: TextStyle(
                                        color: colorScheme.error, fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                   Text(
                                    l10n.quoteUnitCount,
                                    style: TextStyle(
                                        color: colorScheme.error, fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                          if (item.status == 'approved') ...[
                            IconButton(
                              icon: Image.asset(
                                "assets/icons/download.png",
                                width: 19,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topRight,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () => showQuotationDownloadSheet(
                                context: context,
                                item: item,
                                dynamicTemplates: dynamicTemplates,
                                permissions: permissions,
                              ),
                            ),
                          ] else ...[
                            const SizedBox(width: 50)
                          ]
                        ],
                      ),
                      // const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            l10n.quoteCreatorLabel,
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.creator?.name ?? '',
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            l10n.quoteExporterLabel,
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.user?.name ?? '',
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       '业务部门：',
                      //       style: TextStyle(
                      //           color: colorScheme.onSurface, fontSize: 12),
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //     Text(
                      //       item.user?.department?.name ?? '',
                      //       style: TextStyle(
                      //           color: colorScheme.onSurface, fontSize: 12),
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            l10n.quoteOrderNoLabel,
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.quoteNo ?? '',
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

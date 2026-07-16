import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/supply/quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class QuoteItem extends HookWidget {
  final Quote? item;

  const QuoteItem({
    super.key,
    this.item,
  });

  String formatBeijingTime(DateTime? time) {
    if (time == null) return '';

    // 如果是 UTC 时间，则手动加 8 小时作为北京时间
    final beijingTime = time.isUtc ? time.add(const Duration(hours: 8)) : time;

    return DateFormat('yyyy-MM-dd').format(beijingTime);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canBillText = item?.canBill == true
        ? l10n.yes
        : item?.canBill == false
            ? l10n.no
            : '';

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.87) ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        l10n.cartQuoteRegion(item?.sampleLocation ?? ''),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        l10n.cartQuoteShippingDate(
                          formatBeijingTime(item?.chuhuoAt),
                        ),
                         style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        l10n.cartQuotePurchasePrice(item?.purchaseCost ?? ''),
                        overflow: TextOverflow.ellipsis,
                         style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        l10n.cartQuotePurchaseCurrency(item?.currency ?? ''),
                         style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        l10n.cartQuoteCanBill(canBillText),
                         style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        l10n.cartQuoteTaxRate(item?.taxRate ?? ''),
                         style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        l10n.cartQuoteVolume(item?.outerVolume ?? ''),
                         style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        l10n.cartQuoteOuterCapacity(item?.outerCapacity ?? ''),
                         style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Text(
                        l10n.cartQuoteRecordUser(item?.recordUser ?? ''),
                         style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      l10n.cartQuotePacking(item?.packing ?? ''),
                       style: TextStyle(fontSize: 13, color: colorScheme.onSurface.withOpacity(0.87)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

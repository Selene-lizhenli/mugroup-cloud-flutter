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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                        '地区: ${item?.sampleLocation ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '出货日期: ${formatBeijingTime(item?.chuhuoAt)}',
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
                        '采购价: ${item?.purchaseCost ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '采购币种: ${item?.currency ?? ""}',
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
                        '是否开票: ${item?.canBill == true ? '是' : item?.canBill == false ? "否" : ""}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '税率: ${item?.taxRate}',
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
                        '体积: ${item?.outerVolume ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '装箱量: ${item?.outerCapacity ?? ''}',
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
                        '记录人员: ${item?.recordUser ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      '包装: ${item?.packing ?? ''}',
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

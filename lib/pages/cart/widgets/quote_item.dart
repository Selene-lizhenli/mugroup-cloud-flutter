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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('地区: ${item?.sampleLocation ?? ''}'),
                  Text('体积: ${item?.outerVolume ?? ''}'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '出货日期: ${item?.chuhuoAt != null ? DateFormat('yyyy-MM-dd').format(item!.chuhuoAt!) : ''}'),
                  Text('装箱量: ${item?.outerCapacity ?? ''}'),
                ],
              ),
            ],
          ),
          Text('包装: ${item?.packing ?? ''}'),
        ],
      ),
    );
  }
}

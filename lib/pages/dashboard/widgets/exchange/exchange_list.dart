import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/pages/widgets/show_Error.dart';
import 'package:flutter/material.dart';

class ExchangeRatesValueList extends StatelessWidget {
  final List<ExchangeRate>? list;
  final bool? loading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final void Function(ExchangeRate item)? onCurrencyTap;

  const ExchangeRatesValueList({
    super.key,
    this.loading = false,
    this.onCurrencyTap,
    this.errorMessage,
    this.onRetry,
    this.list,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (loading == true) {
      return const SizedBox(
        height: 150,
        child: Center(
          child: MuProgressIndicator(showText: true, text: '加载中...'),
        ),
      );
    }

    if (errorMessage != null) {
      return ShowError(
        errorMessage: '汇率数据加载失败! $errorMessage',
        onRetry: onRetry ?? () {},
        height: 150,
      );
    }

    if (list == null || list!.isEmpty) {
      return const SizedBox(
        height: 110,
        child: Center(child: Empty()),
      );
    }

    const double nameW = 70;
    const double priceW = 75;
    const double dateW = 85;
    const double contentWidth = nameW + (priceW * 5) + dateW;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double tableWidth =
            contentWidth > constraints.maxWidth ? contentWidth : constraints.maxWidth;
        const int columnCount = 7;
        final double extraPerCell =
            tableWidth > contentWidth ? (tableWidth - contentWidth) / columnCount : 0;
        final double nameCellW = nameW + extraPerCell;
        final double priceCellW = priceW + extraPerCell;
        final double dateCellW = dateW + extraPerCell;

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 260),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: tableWidth,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.06),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildCell('货币名称',
                            width: nameCellW,
                            isHeader: true,
                            colorScheme: colorScheme,
                            alignment: Alignment.centerLeft),
                        _buildCell('现汇买入价',
                            width: priceCellW,
                            isHeader: true,
                            colorScheme: colorScheme),
                        _buildCell('现钞买入价',
                            width: priceCellW,
                            isHeader: true,
                            colorScheme: colorScheme),
                        _buildCell('现汇卖出价',
                            width: priceCellW,
                            isHeader: true,
                            colorScheme: colorScheme),
                        _buildCell('现钞卖出价',
                            width: priceCellW,
                            isHeader: true,
                            colorScheme: colorScheme),
                        _buildCell('中行折算价',
                            width: priceCellW,
                            isHeader: true,
                            colorScheme: colorScheme),
                        _buildCell('发布日期',
                            width: dateCellW,
                            isHeader: true,
                            colorScheme: colorScheme,
                            alignment: Alignment.centerRight),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: tableWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: colorScheme.outlineVariant, width: 0.5),
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: list!.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 0.5,
                          color: colorScheme.outlineVariant.withOpacity(0.5),
                        ),
                        itemBuilder: (context, index) {
                          final item = list![index];

                          String dateStr = item.pushedAt ?? '-';
                          if (dateStr.length > 10) {
                            dateStr = dateStr.substring(5, 16);
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (onCurrencyTap != null) {
                                      onCurrencyTap!(item);
                                    }
                                  },
                                  child: _buildCell(
                                    '${item.name ?? ''}\n${item.shortName ?? ''}',
                                    width: nameCellW,
                                    colorScheme: colorScheme,
                                    alignment: Alignment.centerLeft,
                                    isName: true,
                                  ),
                                ),
                                _buildCell(item.xhBuyRate,
                                    width: priceCellW, colorScheme: colorScheme),
                                _buildCell(item.xzBuyRate,
                                    width: priceCellW, colorScheme: colorScheme),
                                _buildCell(item.xhSellRate,
                                    width: priceCellW, colorScheme: colorScheme),
                                _buildCell(item.xzSellRate,
                                    width: priceCellW, colorScheme: colorScheme),
                                _buildCell(item.midRate,
                                    width: priceCellW, colorScheme: colorScheme),
                                _buildCell(dateStr,
                                    width: dateCellW,
                                    colorScheme: colorScheme,
                                    alignment: Alignment.centerRight),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell(
    String? text, {
    required double width,
    bool isHeader = false,
    bool isName = false,
    required ColorScheme colorScheme,
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      width: width,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text ?? '-',
        maxLines: isName ? 2 : 1,
        overflow: TextOverflow.ellipsis,
        textAlign: alignment == Alignment.centerRight
            ? TextAlign.right
            : (alignment == Alignment.centerLeft
                ? TextAlign.left
                : TextAlign.center),
        style: TextStyle(
          fontSize: isHeader ? 11 : 10.5,
          fontWeight: isHeader
              ? FontWeight.w600
              : (isName ? FontWeight.w500 : FontWeight.normal),
          color: isHeader
              ? colorScheme.primary
              : (isName ? colorScheme.onSurface : colorScheme.onSurfaceVariant),
          height: 1.0,
        ),
      ),
    );
  }
}

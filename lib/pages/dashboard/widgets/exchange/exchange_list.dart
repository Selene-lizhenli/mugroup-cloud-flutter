import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/empty.dart';
import 'package:cloud/pages/widgets/show_Error.dart';
import 'package:flutter/material.dart';

///展示汇率列表表格（ 未选择维度时）
class ExchangeRatesValueList extends StatelessWidget {
  final List<ExchangeRate>? list;
  final bool? loading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ExchangeRatesValueList({
    super.key,
    this.loading = false,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // 最少 2 列，最多 4 列；根据可用宽度自适应
            final width = constraints.maxWidth;
            final columns = (width / 180).floor().clamp(2, 4);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list?.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 5.8,
              ),
              itemBuilder: (context, index) {
                final item = list?[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(2),
                    // border: Border.all(
                    //   color: colorScheme.primary,
                    //   width: 0.1,
                    // ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item?.name} ${item?.shortName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        item?.exchangeRate ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

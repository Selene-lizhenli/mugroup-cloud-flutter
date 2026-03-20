import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/dashboard/widgets/product_card.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SampleRankListPage extends StatelessWidget {
  final List<dynamic> data;
  final String? label;

  const SampleRankListPage({
    super.key,
    required this.data,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final displayData = data.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(
          label ?? '排名',
          style: TextStyle(color: colorScheme.onPrimary),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            size: 17,
            color: colorScheme.onPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: displayData.isEmpty
          ? Center(
              child: Container(
                color: colorScheme.primary,
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 12),
                child: Text(
                  '暂无数据',
                  style: TextStyle(color: colorScheme.outline),
                ),
              ),
            )
          : Container(
              color: colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 12),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  TopRankItemCard(
                    displayData: displayData,
                    showInpage: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '没有更多了...',
                          style: TextStyle(
                              color: colorScheme.onPrimary, fontSize: 12),
                        )
                      ],
                    ),
                  )
                ],
              )),
            ),
    );
  }
}

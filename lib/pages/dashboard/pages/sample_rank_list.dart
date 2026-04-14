import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/dashboard/widgets/product_card.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SampleRankListPage extends HookConsumerWidget {
  final List<dynamic> data;
  final String? label;
  final String? type;

  const SampleRankListPage({
    super.key,
    required this.data,
    this.label,
    this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayData = data.toList();
    final themeType = ref.watch(appThemeProvider);

    final backgrundBottomImage = themeType == ThemeType.pink
        ? 'assets/theme/column_chart_blue.png'
        : 'assets/theme/column_chart_pink.png';

    return Scaffold(
        backgroundColor: colorScheme.primary,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
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
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateX(3.1415926535897932),
                child: Image.asset(
                  backgrundBottomImage,
                  fit: BoxFit.contain,
                  width: 190,
                  alignment: Alignment.topRight,
                ),
              ),
            ),
            SafeArea(
              child: displayData.isEmpty
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
                            type: type,
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
                                      color: colorScheme.onPrimary,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                    ),
            ),
          ],
        ));
  }
}

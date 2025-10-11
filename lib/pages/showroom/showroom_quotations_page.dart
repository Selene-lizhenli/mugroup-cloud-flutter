import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/showroom/widgets/showroom_quotations_text_card.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class ShowroomQuotationsPage extends HookConsumerWidget {
  final String quoteNo;
  const ShowroomQuotationsPage({super.key, @pathParam required this.quoteNo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final searchKeyword = useState<String>('');

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onDoubleTap: () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: const Text('报价单详情'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: EasyRefresh(
            refreshOnStart: true,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                MultiSliver(
                  children: [
                    // 固定在顶部的订单信息
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowroomQuotatiosTextCard(
                          title: "报价单号",
                          lable: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Text(
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                  quoteNo,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 10),
                          child: Row(
                            children: [
                              const Text(
                                '产品信息',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) => {
                                    searchKeyword.value = value,
                                  },
                                  decoration: InputDecoration(
                                    hintText: '搜索产品名/条码/编码',
                                    prefixIcon:
                                        const Icon(Icons.search, size: 20),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 0),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // 滚动的产品列表
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return const Text('产品数据');
                    },
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/quotation.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/pages/showroom/widgets/showroom_quotations_items_card.dart';
import 'package:cloud/pages/showroom/widgets/showroom_quotations_operate_bar.dart';
import 'package:cloud/pages/showroom/widgets/showroom_quotations_text_card.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
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
    final cart = ref.read(cartProvider.notifier);
    final scrollController = useScrollController();
    final searchKeyword = useState<String>('');
    final quotation = useState<Quotation?>(null);
    final quotationId = useState<int?>(null);
    final quotationSampleItems = useState<List<QuotationSample>>([]);

    loadQuotation(String quoteNo) async {
      final data = await getShowroomQuotationByQuoteNo(quoteNo);
      quotation.value = data;
      quotationId.value = data?.id;

      if (data?.id != null) {
        final res = await getQuotationSamples(
            queryParameters: {"quotation_id": data!.id!, 'showAll': "1"});
        quotationSampleItems.value = res.data;
      } else { 
        quotationSampleItems.value = [];
      }
    }

    useEffect(() {
      loadQuotation(quoteNo);
    }, [quoteNo]);

    // 计算筛选后的结果
    final filteredItems = useMemoized(() {
      final keyword = searchKeyword.value.trim().toLowerCase();
      if (keyword.isEmpty) return quotationSampleItems.value;
      return quotationSampleItems.value.where((item) {
        final name = item.showroomSample?.nameCn?.toLowerCase() ?? '';
        final barcode = item.showroomSample?.barcode?.toLowerCase() ?? '';
        final code = item.showroomSample?.productNo?.toLowerCase() ?? '';
        return name.contains(keyword) ||
            barcode.contains(keyword) ||
            code.contains(keyword);
      }).toList();
    }, [searchKeyword.value, quotationSampleItems.value]);

    void addCartDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: const Text(
              "确定添加进购物车",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "该操作为追加，在保留原有购物车数据上添加",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "取消",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  cart.setSampleByQuotationSamples(quotationSampleItems.value);
                  context.pushRoute(const CartRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "提交",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

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
                        ShowroomQuotatiosTextCard(
                          title: "业务部门",
                          lable: Text(
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              quotation.value?.user?.department?.name ?? ''),
                        ),
                        ShowroomQuotatiosTextCard(
                          title: "外销员",
                          lable: Text(
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              quotation.value?.user?.name ?? ""),
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
                      return ShowroomQuotationItemsCard(filteredItems[index]);
                    },
                    childCount: filteredItems.length,
                  ),
                ),
              ],
            ),
          ),
          ShowroomQuotationsOperateBar(
            addCart: () {
              addCartDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

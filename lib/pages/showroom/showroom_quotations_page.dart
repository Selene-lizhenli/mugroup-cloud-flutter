import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/quotation.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
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

    final quotationSampleItems = useState<List<QuotationSample>>([]);

    loadQuotation(String quoteNo) async {
      final data = await getShowroomQuotationByQuoteNo(quoteNo);
      quotation.value = data;
      quotationSampleItems.value = data?.quotationSamples ?? [];
    }

    useEffect(() {
      loadQuotation(quoteNo);
      return () {};
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
                  for (final qs in quotationSampleItems.value) {
                    final sample = qs.showroomSample;
                    final qty = qs.qty ?? 1; // 默认数量为 1

                    if (sample == null) continue; // 跳过无效数据

                    final hadSample = cart.getItemBySample(sample);

                    if (hadSample != null) {
                      cart.setSample(sample, hadSample.count + qty);
                    } else {
                      cart.setSample(sample, qty);
                    }
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
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

class ShowroomQuotationItemsCard extends HookConsumerWidget {
  final QuotationSample? quoationSample;

  const ShowroomQuotationItemsCard(this.quoationSample, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cover =
        quoationSample?.showroomSample?.image?.elementAtOrNull(0)?.thumbUrl;

    const showPrice = true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(children: [
                Expanded(
                    child: Text(
                  '${quoationSample?.showroomSample?.name}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${quoationSample?.qty ?? 1}',
                  style: const TextStyle(
                    color: Colors.blue, // 设置颜色
                    fontSize: 18, // 加大字体
                    fontWeight: FontWeight.bold, // 可选，设置加粗
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cover != null
                          ? CachedNetworkImage(
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                              imageUrl: cover,
                            )
                          : Image.asset(
                              'assets/noImage.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "条形码：",
                                    style: TextStyle(),
                                  ),
                                  Expanded(
                                      child: Text(
                                    quoationSample?.showroomSample?.barcode ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  )),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "产品编码：",
                                  ),
                                  Expanded(
                                      child: Text(
                                    quoationSample?.showroomSample?.productNo ??
                                        '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ))
                                ],
                              ),
                              if (showPrice)
                                Row(
                                  children: [
                                    const Text(
                                      "采购单价：",
                                    ),
                                    Expanded(
                                        child: Text(
                                      quoationSample?.showroomSample
                                                  ?.purchaseCost !=
                                              null
                                          ? '￥${quoationSample?.showroomSample!.purchaseCost}'
                                          : '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ))
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShowroomQuotationsOperateBar extends HookConsumerWidget {
  final void Function()? addCart;

  const ShowroomQuotationsOperateBar({super.key, this.addCart});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                  onPressed: addCart,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue[700], // 设置背景颜色
                    foregroundColor: Colors.white, // 设置文字颜色
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16), // 设置内边距
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 圆角
                    ),
                  ),
                  child: const Text(
                    "添加进购物车",
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowroomQuotatiosTextCard extends HookConsumerWidget {
  final String title;
  final Widget lable;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ShowroomQuotatiosTextCard(
      {super.key,
      required this.title,
      required this.lable,
      this.margin,
      this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      margin: margin ?? const EdgeInsets.all(1),
      padding: padding ?? const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        '$title:'),
                  ],
                ),
              )),
          lable,
        ],
      ),
    );
  }
}

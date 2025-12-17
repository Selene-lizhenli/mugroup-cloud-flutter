import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';
import 'package:cloud/pages/quote/widgets/quote_search_bar.dart';
import 'package:cloud/pages/quote/widgets/quote_time_tabs.dart';

@RoutePage()
class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage>
    with AutomaticKeepAliveClientMixin {
  int tabIndex = 0;
  late final TextEditingController _searchController;
  String _lastSearch = ''; // 保存上一次搜索内容
  final ScrollController _scrollController = ScrollController();
  String? quoteAt; // 当前时间筛选状态

  List<QuotationList> list = [];
  bool isLoading = true; // 首次加载
  bool isLoadingMore = false; // 上拉加载更多
  bool hasMore = true; // 是否还有更多数据

  int page = 1;
  final int pageSize = 20;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);

    _fetchData(reset: true); // 首次加载
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final current = _searchController.text.trim();

    // 如果内容和上次相同，直接返回
    if (current == _lastSearch) return;

    _lastSearch = current; // 更新最后一次搜索内容
    _fetchData(reset: true); // 调用接口
  }

  void _onTabChanged(int index) {
    setState(() {
      tabIndex = index;
      quoteAt = QuoteUtils.buildQuoteAtParam(index);
    });
    _fetchData(reset: true); // 使用最新 quoteAt 状态
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore &&
        hasMore &&
        !isLoading) {
      // 滑动到接近底部，加载更多
      _fetchData(reset: false);
    }
  }

  Future<void> _fetchData({required bool reset}) async {
    if (reset) {
      setState(() {
        isLoading = true;
        page = 1;
        hasMore = true;
      });
    } else {
      setState(() => isLoadingMore = true);
      page += 1;
    }

    final search = _searchController.text;
    final paramsData = {
      "search": search,
      "page": page.toString(),
      "pageSize": pageSize.toString(),
      if (quoteAt != null) 'quote_at': quoteAt!,
    };
    logger.d(paramsData);
    final newData = await getShowroomQuotation(paramsData);
    setState(() {
      if (reset) {
        list = newData.data ?? [];
        isLoading = false;
      } else {
        list.addAll(newData.data ?? []);
        isLoadingMore = false;
      }
      hasMore = newData.data.length >= pageSize; // 判断是否还有下一页
    });
  }

  Future<void> _onRefresh() async {
    await _fetchData(reset: true);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: const Text("报价单"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            QuoteSearchBar(controller: _searchController),
            QuoteTimeTabs(
              currentIndex: tabIndex,
              onChanged: _onTabChanged,
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: list.length + 1, // 最后一条用于显示加载或没有更多
                        itemBuilder: (context, index) {
                          if (index < list.length) {
                            return QuoteCard(
                              item: list[index],
                              tabIndex: tabIndex,
                              onTap: () {
                                final tempId = list[index].id;

                                context.router.push(QuoteDetailRoute(
                                    id: tempId!,
                                    userId: list[index].user?.id ?? 0));
                              },
                            );
                          } else {
                            if (isLoadingMore) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else if (!hasMore) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Text(
                                    '没有更多了',
                                    style: TextStyle(
                                        color: colorScheme
                                            .surfaceContainerHighest),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink(); // 占位，什么也不显示
                            }
                          }
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteUtils {
  static String? buildQuoteAtParam(int index) {
    final now = DateTime.now();
    DateTime? start;

    switch (index) {
      case 0:
        return null;
      case 1:
        start = DateTime(
          now.year,
          now.month - 1,
          now.day,
          now.hour,
          now.minute,
          now.second,
        );
        break;
      case 2:
        start = DateTime(
          now.year,
          now.month - 3,
          now.day,
          now.hour,
          now.minute,
          now.second,
        );
        break;
      case 3:
        start = DateTime(
          now.year,
          now.month - 6,
          now.day,
          now.hour,
          now.minute,
          now.second,
        );
        break;
      case 4:
        start = DateTime(
          now.year - 1,
          now.month,
          now.day,
          now.hour,
          now.minute,
          now.second,
        );
        break;
    }

    return '${_format(start!)},${_format(now)}';
  }

  static String _format(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)}'
        ' ${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }
}

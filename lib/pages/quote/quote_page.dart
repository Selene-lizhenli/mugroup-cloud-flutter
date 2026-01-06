import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/widgets/quote_list.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  DateTime? customDate; // 自定义选择的年月

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
      customDate = null; // 切换标签时清除自定义日期
      quoteAt = QuoteUtils.buildQuoteAtParam(index);
    });
    _fetchData(reset: true); // 使用最新 quoteAt 状态
  }

  /// 显示自定义日期选择器（年月日），日期列第一个为 “-” 表示只选年月
  void _showYearMonthPicker() {
    final now = DateTime.now();

    // ===== 初始化默认值 =====
    int year = customDate?.year ?? now.year;
    int month = customDate?.month ?? now.month;
    // 为了兼容老数据：如果 day==1 也可能是之前只选了年月，这里一律当作“有选日期”处理
    int? day = customDate?.day;

    // 年列表：近 10 年
    final years = List<int>.generate(10, (i) => now.year - 5 + i);
    if (!years.contains(year)) {
      year = now.year;
    }
    int yearIndex = years.indexOf(year);

    // 月列表：1-12
    final months = List<int>.generate(12, (i) => i + 1);
    int monthIndex = month - 1;

    // 根据年月计算当月天数
    int daysInMonth(int y, int m) => DateTime(y, m + 1, 0).day;

    // 日列表：["-", "1", "2", ..., "N"]
    int maxDay = daysInMonth(year, month);
    List<String> buildDayOptions(int y, int m) {
      final max = daysInMonth(y, m);
      return ['-',
        ...List<String>.generate(max, (i) => '${i + 1}'),
      ];
    }

    List<String> days = buildDayOptions(year, month);
    int dayIndex;
    if (day == null || day < 1 || day > maxDay) {
      dayIndex = 0; // 默认选择 “-”
    } else {
      dayIndex = day; // day=1 -> index=1, 与列表对齐
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return StatefulBuilder(
          builder: (context, setModalState) {
            // 当年份或月份变化时，更新天数列表
            void updateDaysIfNeeded() {
              final newMax = daysInMonth(year, month);
              if (newMax + 1 != days.length) {
                days = buildDayOptions(year, month);
                if (dayIndex > newMax) {
                  dayIndex = 0; // 超出范围则重置为 “-”
                }
              }
            }

            updateDaysIfNeeded();

            return SizedBox(
              height: 260,
              child: Column(
                children: [
                  // 头部
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '选择时间',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        // 年
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(initialItem: yearIndex),
                            onSelectedItemChanged: (index) {
                              setModalState(() {
                                yearIndex = index;
                                year = years[yearIndex];
                              });
                            },
                            children: years
                                .map((y) => Center(child: Text('$y年')))
                                .toList(),
                          ),
                        ),
                        // 月
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(initialItem: monthIndex),
                            onSelectedItemChanged: (index) {
                              setModalState(() {
                                monthIndex = index;
                                month = months[monthIndex];
                              });
                            },
                            children: months
                                .map((m) => Center(child: Text('$m月')))
                                .toList(),
                          ),
                        ),
                        // 日（第一个为 "-"）
                        Expanded(
                          child: CupertinoPicker(
                            itemExtent: 32,
                            scrollController: FixedExtentScrollController(initialItem: dayIndex),
                            onSelectedItemChanged: (index) {
                              setModalState(() {
                                dayIndex = index;
                              });
                            },
                            children: days
                                .map((d) => Center(child: Text(d == '-' ? '-' : '$d日')))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 底部按钮
                  Padding(
                    padding: const EdgeInsets.only(right: 16, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          Navigator.pop(context);

                          final selectedYear = years[yearIndex];
                          final selectedMonth = months[monthIndex];
                          final int? selectedDay =
                              dayIndex == 0 ? null : int.parse(days[dayIndex]);

                          setState(() {
                            // 使用自定义日期后，时间范围 tabs 不再高亮任何一项
                            tabIndex = -1;
                            if (selectedDay == null) {
                              // 只选择了年月：整月范围
                              customDate = DateTime(selectedYear, selectedMonth, 1);
                              final startDate =
                                  DateTime(selectedYear, selectedMonth, 1);
                              final endDate =
                                  DateTime(selectedYear, selectedMonth + 1, 0, 23, 59, 59);
                              quoteAt =
                                  '${QuoteUtils._format(startDate)},${QuoteUtils._format(endDate)}';
                            } else {
                              // 选择了具体日期：当天范围
                              customDate =
                                  DateTime(selectedYear, selectedMonth, selectedDay);
                              final startDate = DateTime(
                                  selectedYear, selectedMonth, selectedDay, 0, 0, 0);
                              final endDate = DateTime(
                                  selectedYear, selectedMonth, selectedDay, 23, 59, 59);
                              quoteAt =
                                  '${QuoteUtils._format(startDate)},${QuoteUtils._format(endDate)}';
                            }
                          });

                          _fetchData(reset: true);
                        },
                        child: const Text('确定'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
        list = newData.data;
        isLoading = false;
      } else {
        list.addAll(newData.data);
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
        backgroundColor: colorScheme.surfaceTint,
        title: const Text("报价单"), 
        actions: [
          // 刷新按钮：重新拉取当前条件下的数据
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新', 
            iconSize: 22,
            onPressed: () => _fetchData(reset: true),
          ),
          // 新增按钮：跳转到市场产品列表页
          TextButton(
            onPressed: () {
              context.router.push(  QuoteCreateRoute());
            },
            child: const Text(
              '新增',
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            QuoteSearchBar(controller: _searchController),
            QuoteTimeTabs(
              currentIndex: tabIndex,
              onChanged: _onTabChanged,
              isCalendarSelected: customDate != null,
              onCalendarTap: _showYearMonthPicker,
            ),
            BuildQuoteList(
              isLoading: isLoading,
              isLoadingMore: isLoadingMore,
              hasMore: hasMore,
              list: list,
              tabIndex: tabIndex,
              scrollController: _scrollController,
              onRefresh: _onRefresh,
              onItemTap: (item) {
                final tempId = item.id;
                if (tempId == null) return;
                context.router.push(
                  QuoteDetailRoute(
                    id: tempId,
                    userId: item.user?.id ?? 0,
                  ),
                );
              },
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


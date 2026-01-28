import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/quote/widgets/quote_card.dart';
import 'package:cloud/pages/quote/widgets/quote_search_bar.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  String _lastSearch = '';
  final ScrollController _scrollController = ScrollController();

  String? quoteAt;
  List<QuotationList> list = [];
  bool isLoading = true;
  final int pageSize = 20;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _fetchData();
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
    if (current == _lastSearch) return;
    _lastSearch = current;
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);

    final search = _searchController.text;
    final paramsData = {
      "search": search,
      "page": "1",
      "pageSize": pageSize.toString(),
      if (quoteAt != null) 'quote_at': quoteAt!,
      "type": "market",
    };

    try {
      final newData = await getShowroomQuotation(paramsData);
      if (mounted) {
        setState(() {
          list = newData.data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _onRefresh() async {
    await _fetchData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "带客记录",
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              QuoteSearchBar(controller: _searchController),

              // === 区域一：近期记录 (核心业务) ===
              _buildSectionCard(
                context,
                title: "近期记录",
                icon: Icons.access_time_filled_rounded,
                iconColor: Colors.blueAccent,
                action: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 刷新按钮
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.refresh,
                          color: Colors.grey[600], size: 22),
                      tooltip: "刷新",
                      onPressed: _onRefresh,
                    ),

                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.add_circle_outline,
                          color: colorScheme.primary, size: 22),
                      tooltip: "新增",
                      onPressed: () => context.router.push(QuoteCreateRoute()),
                    ),
                  ],
                ),
                content: _buildRecentRecordsContent(context),
              ),

              const SizedBox(height: 16),

              _buildSectionCard(
                context,
                title: "带客记录详情",
                icon: Icons.list_alt_rounded, // 换个图标
                iconColor: Colors.orangeAccent,
                content: _buildDetailList(context), // 调用新的详情构建方法
              ),

              const SizedBox(height: 16),

              // === 区域三：快捷功能 ===
              _buildSectionCard(
                context,
                title: "创建产品",
                icon: Icons.grid_view_rounded,
                iconColor: Colors.purpleAccent,
                content: _buildQuickActionsPlaceholder(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget content,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 12, 8, 8), // 右侧padding减小以适应按钮
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                if (action != null) action,
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
          // 内容
          content,
        ],
      ),
    );
  }

  Widget _buildRecentRecordsContent(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 40, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text("暂无近期记录",
                style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          ],
        ),
      );
    }

    // 截取前3条
    final displayList = list.take(3).toList();

    return Column(
      children: [
        // 1. 列表内容
        ...displayList.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: QuoteCard(
              item: item,
              tabIndex: tabIndex,
              onTap: () {
                final tempId = item.id;
                if (tempId == null) return;
                context.router.push(QuoteDetailRoute(id: tempId));
              },
            ),
          );
        }),

        // 2. 【修改点2】底部的“查看全部”按钮
        // 只有当有数据时才显示
        if (displayList.isNotEmpty) ...[
          // 分割线，让按钮看起来是独立的 footer
          Divider(height: 1, thickness: 0.5, color: Colors.grey[100]),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("跳转全部记录页面")),
              );
              // context.router.push(QuoteListRoute());
            },
            // 底部圆角适配
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Container(
              height: 48, // 增加高度，方便点击
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "查看全部",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_right_rounded,
                      size: 18, color: Colors.grey[500]),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickActionsPlaceholder() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      padding: const EdgeInsets.symmetric(vertical: 16),
      mainAxisSpacing: 16,
      children: [
        _buildActionIcon(Icons.add_a_photo_outlined, "拍照开单"),
        _buildActionIcon(Icons.qr_code_scanner, "扫码识别"),
        _buildActionIcon(Icons.analytics_outlined, "销售报表"),
        _buildActionIcon(Icons.settings_outlined, "设置"),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.grey[700], size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildDetailList(
    BuildContext context,
  ) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Text(
          "暂无数据详情",
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
      );
    }

    // 获取上方展示的相同数据 (前3条)
    final detailList = list.take(3).toList();

    return ListView.separated(
      shrinkWrap: true, // 关键：在Column中使用ListView需要这个
      physics: const NeverScrollableScrollPhysics(), // 禁用内部滚动，跟随页面滚动
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: detailList.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final item = detailList[index];
        return _buildDetailRowItem(context, item);
      },
    );
  }

  Widget _buildDetailRowItem(BuildContext context, QuotationList item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.company?.name ?? '无客户名称',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 80),
                      child: Text(
                        "外销员: ${item.creator?.name ?? '暂无'}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 1,
                        height: 10,
                        color: Colors.grey[300],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.createdAt != null
                            ? DateFormat('yyyy-MM-dd').format(item.createdAt!)
                            : '--',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: 按钮1逻辑
                    print("点击了按钮1: ${item.id}");
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "添加供应商",
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 按钮 2 (例如：操作/跟进)
              SizedBox(
                height: 32,
                child: FilledButton(
                  onPressed: () {
                    // TODO: 按钮2逻辑
                    print("点击了按钮2: ${item.id}");
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "从供应商导入",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

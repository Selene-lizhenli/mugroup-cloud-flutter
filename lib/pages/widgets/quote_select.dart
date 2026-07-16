import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class QuoteSelect extends HookConsumerWidget {
  final bool showCreateQuote;

  const QuoteSelect({
    super.key,
    this.showCreateQuote = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final double height = MediaQuery.of(context).size.height * 0.55;
    final searchController = useTextEditingController();
    useListenable(searchController);

    final search = useState<String?>(null);
    final quotes = useState<List<QuotationList>?>(null);
    final isLoading = useState<bool>(true);
    final debounceTimer = useRef<Timer?>(null);

    Future<void> loadQuotes() async {
      try {
        isLoading.value = true;
        final resp = await getShowroomQuotation({
          "search": search.value,
          "type": "market",
        });
        quotes.value = resp.data;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadQuotes();
      return () => debounceTimer.value?.cancel();
    }, [search.value]);

    void onSearchChanged(String val) {
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
        search.value = val.isEmpty ? null : val;
      });
    }

    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("选择客户 ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text(" (已有带客记录)", style: TextStyle(fontSize: 12)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: '搜索客户名称、编号...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              searchController.clear();
                              search.value = null;
                            },
                            child: const Icon(Icons.cancel,
                                size: 18, color: Colors.grey),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                    onPressed: () async {
                      await context.router.push(QuoteCreateRoute());
                      if (context.mounted) loadQuotes();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("新增带客",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading.value
                ? const Center(child: MuProgressIndicator(showText: true))
                : (quotes.value == null || quotes.value!.isEmpty)
                    ? _buildEmptyState(colorScheme)
                    : ListView.builder(
                        itemCount: quotes.value!.length,
                        itemBuilder: (context, index) {
                          final quote = quotes.value![index];
                          return _QuoteCard(
                            quote: quote,
                            onTap: () =>
                                Navigator.of(context).pop(quote.toJson()),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 使用更具现代感的图标
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[200]),
            const SizedBox(height: 16),
            Text(
              "未找到相关带客记录",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "您可以尝试更换关键词，或点击右上角“新增”直接创建带客记录",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
                height: 1.5, // 增加行高，提升易读性
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final QuotationList quote;
  final VoidCallback onTap;

  const _QuoteCard({required this.quote, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final createDate = quote.createdAt != null
        ? DateFormat('yyyy-MM-dd').format(quote.createdAt!)
        : '--';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quote.company?.name ?? '未知客户',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3133),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      quote.quoteNo ?? '',
                      style:
                          TextStyle(fontSize: 11, color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "创建日期：$createDate",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/sample.dart';
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
    final double height = MediaQuery.of(context).size.height * 0.75;
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

    // 2. 接口请求逻辑
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
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text("选择带客记录",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text(
                      '不选择代表不关联客户',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: '搜索名称、编号或相关产品...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                prefixIcon:
                    const Icon(Icons.search, size: 18, color: Colors.grey),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.cancel,
                            size: 16, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                          debounceTimer.value?.cancel();
                          search.value = null;
                        },
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                      )
                    : null,
                prefixIconConstraints: const BoxConstraints(minWidth: 32),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading.value
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: MuProgressIndicator(barWidth: 2),
                    ),
                  )
                : (quotes.value == null || quotes.value!.isEmpty)
                    ? Center(
                        child: Text("暂无数据",
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 13)))
                    : Column(
                        children: [
                          if (showCreateQuote)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 17, 30, 17),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorScheme.primary,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () async {
                                      await context.router
                                          .push(QuoteCreateRoute());

                                      if (context.mounted) {
                                        loadQuotes();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: colorScheme.primary,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '创建新带客记录',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                              child: ListView.separated(
                            padding: const EdgeInsets.all(4),
                            itemCount: quotes.value!.length,
                            separatorBuilder: (context, index) => Column(
                              children: [
                                const SizedBox(height: 4),
                                Divider(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                            itemBuilder: (context, index) {
                              final quote = quotes.value![index];

                              final supplierName =
                                  quote.company?.name ?? '未知客户';

                              final quoteNo = quote.quoteNo;

                              final createDate = quote.createdAt != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(quote.createdAt!)
                                  : '';

                              return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(quote.toJson());
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 8, 12, 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    supplierName,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black87,
                                                      // color: colorScheme.secondary,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  "$quoteNo",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: colorScheme
                                                        .surfaceContainerHighest,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    createDate,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: colorScheme
                                                          .surfaceContainerHighest,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          )),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

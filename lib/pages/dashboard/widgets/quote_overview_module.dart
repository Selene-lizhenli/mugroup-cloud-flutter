import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/quote_detail/quote_detail_page.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'dashboard_card.dart';

class QuoteOverviewModule extends StatelessWidget {
  const QuoteOverviewModule({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '报价单概览',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const QuoteOverviewSection(),
      ],
    );
  }
}

class QuoteOverviewSection extends StatelessWidget {
  const QuoteOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        const Text(
          '最近一周新增：3 条\n ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            height: 1.2,
          ),
        ),
        // const Text(
        //   '今日新增：3 条\n ',
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 14,
        //     height: 1.2,
        //   ),
        // ),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () {
              context.router.push(QuoteRoute());
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
            child: Text(
              '查看详情 >',
              style: TextStyle(color: colorScheme.secondary),
            ),
          ),
        ),
      ]),
    );
  }
}

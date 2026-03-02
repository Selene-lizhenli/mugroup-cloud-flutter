import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/pages/quote/quote_create/widgets/select_language_sheet.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:cloud/pages/quote/quote_create/widgets/quote_base_info_step.dart';
import 'package:cloud/pages/quote/quote_detail/providers/quote_detail_provider.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:cloud/services/quotation_list.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class QuoteCreatePage extends HookConsumerWidget {
  final int? quoteId; // 编辑模式时传递报价单ID

  const QuoteCreatePage({
    super.key,
    this.quoteId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditMode = quoteId != null;
    final notifier = ref.read(quoteCreateProvider.notifier);

    final isLoading = useState<bool>(false);

    useEffect(() {
      Future<void> loadInitialData() async {
        if (quoteId == null) return;

        isLoading.value = true;
        try {
          final data = await getQuotationListById(quoteId!);

          if (data.company != null) notifier.setSelectedCustomer(data.company!);
          if (data.contact != null) notifier.setSelectedContact(data.contact!);

          notifier.setCurrency(data.curreny ?? 'USD');

          final double rawExchange =
              double.tryParse(data.exchange ?? '') ?? 0.0;
          notifier.setRate((rawExchange / 100).toString());

          final String? langCode = data.language;
          final languageItem =
              getLanguageByCode(langCode ?? 'EN') ?? getLanguageByCode('EN');

          if (languageItem != null) {
            notifier.setLanguage(languageItem);
          }

          if (data.quoteAt != null) {
            final date = DateTime.tryParse(data.quoteAt!);
            if (date != null) notifier.setQuoteDate(date);
          }
        } catch (e) {
          logger.e('加载报价单数据失败: $e');
        } finally {
          isLoading.value = false;
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => loadInitialData());

      return () => notifier.reset();
    }, [quoteId]);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '编辑报价单' : '新增报价单'),
        backgroundColor: colorScheme.surface,
      ),
      body: isLoading.value
          ? const Center(child: MuProgressIndicator())
          : Column(
              children: [
                const Expanded(child: QuoteBaseInfoStep()),
                QuoteCreateBottomBar(quoteId: quoteId),
              ],
            ),
    );
  }
}

class QuoteCreateBottomBar extends ConsumerWidget {
  final int? quoteId;

  const QuoteCreateBottomBar({super.key, this.quoteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final state = ref.watch(quoteCreateProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final quoteDetailNotifier = ref.read(quoteDetailProvider.notifier);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E6EB))),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: state.submitting
                ? null
                : () async {
                    if (state.selectedCustomers == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('请选择客户'),
                            backgroundColor: Colors.orange),
                      );
                      return;
                    }

                    final submitData = {
                      "sample_items": const [],
                      "user_id": user?.id,
                      "curreny": state.currency,
                      "exchange": state.rate,
                      "quote_at": state.quoteDate.toIso8601String(),
                      "contact_id": state.contact,
                      "company_id": state.selectedCustomers?.id,
                      "language": state.language?.name,
                      "company": state.selectedCustomers,
                      "type": "market",
                    };

                    try {
                      if (quoteId != null) {
                        final success = await updateShowroomQuotation(
                            quoteId.toString(), submitData);
                        if (success && context.mounted) {
                          quoteDetailNotifier.fetchQuoteDetail(quoteId!);
                          context.router.maybePop();
                        }
                      } else {
                        final result = await storeShowroomQuotation(submitData);
                        if (result?.id != null && context.mounted) {
                          context.router
                              .replace(QuoteDetailRoute(id: result!.id!));
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('保存失败: $e'),
                              backgroundColor: colorScheme.error),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: state.submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: MuProgressIndicator(barWidth: 2))
                : Text('保存',
                    style:
                        TextStyle(fontSize: 16, color: colorScheme.onPrimary)),
          ),
        ),
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/quote/quotation_list.dart';
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

    // 本地状态：是否加载中 / 编辑数据
    final isLoading = useState<bool>(false);
    final editData = useState<QuotationList?>(null);

    // 首次进入 & quoteId 变化时：重置表单状态并（在编辑模式下）加载数据
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (quoteId == null) {
          return;
        }
        isLoading.value = true;
        () async {
          try {
            final data = await getQuotationListById(quoteId!);
            editData.value = data;
            isLoading.value = false;
            // 用接口数据初始化表单
            notifier.setSelectedCustomer(data.company!);
            notifier.setSelectedContact(data.contact!);
            notifier.setCurrency(data.curreny!);
            notifier.setRate(data.exchange!);

            if (data.quoteAt != null) {
              try {
                final date = DateTime.parse(data.quoteAt!);
                notifier.setQuoteDate(date);
              } catch (_) {
                // 解析失败则忽略，继续用默认日期
              }
            }
          } catch (_) {
            isLoading.value = false;
          }
        }();
      });

      return () => WidgetsBinding.instance.addPostFrameCallback((_) {
            notifier.reset();
          });
    }, [quoteId]);

    if (isLoading.value) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? '编辑报价单' : '新增报价单'),
          backgroundColor: colorScheme.surface,
        ),
        body: const Center(child: MuProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? '编辑报价单' : '新增报价单'),
        backgroundColor: colorScheme.surface,
      ),
      body: Column(
        children: [
          const Expanded(child: QuoteBaseInfoStep()),
          QuoteCreateBottomBar(quoteId: quoteId),
        ],
      ),
    );
  }
}

class QuoteCreateBottomBar extends ConsumerWidget {
  final int? quoteId; // 编辑模式时的报价单ID

  const QuoteCreateBottomBar({
    super.key,
    this.quoteId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user; //  保存时使用
    final state = ref.watch(quoteCreateProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = state.submitting;
    final quoteDetailNotifier = ref.read(quoteDetailProvider.notifier);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E6EB)),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 6),

            // ================= 保存 =================
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (context.mounted) {
                          // 校验：客户为必填项
                          if (state.selectedCustomers == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('请选择客户'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            return;
                          }
                          // 组装提交数据
                          final submitData = {
                            "sample_items": const [],
                            "user_id": user?.id, //外销员
                            "curreny": state.currency, //货币
                            "exchange": state.rate, //汇率
                            "quote_at": state.quoteDate.toIso8601String(),
                            "contact_id": state.contact, //联系人
                            "company_id": state.selectedCustomers?.id, //客户
                            "language": state.language?.name,
                            "company": state.selectedCustomers,
                            "type": "market", //区分市场采购的报价单
                          };
                          bool isSuccess = false;
                          if (quoteId != null) {
                            // 接口需要调整参数：编辑模式更新
                            final result = await updateShowroomQuotation(
                              quoteId.toString(),
                              submitData,
                            );
                            isSuccess = result == true;
                            if (context.mounted) {
                              context.router.maybePop(QuoteDetailRoute(
                                id: quoteId!,
                              ));
                              //刷新报价单详情page
                              quoteDetailNotifier.fetchQuoteDetail(quoteId!);
                            }
                          } else {
                            // 创建模式：新建
                            final result = await storeShowroomQuotation(
                              submitData,
                            );
                            isSuccess = result != null;
                            if (result != null && context.mounted) {
                              context.router.replace(QuoteDetailRoute(
                                id: result.id!,
                              ));
                            }
                          }

                          if (!isSuccess && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                content: const Text('保存失败，请稍后重试'),
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: state.submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: MuProgressIndicator(
                          barWidth: 2,
                        ),
                      )
                    : Text(
                        '保存',
                        style: TextStyle(
                            fontSize: 16, color: colorScheme.onPrimary),
                      ),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/models/dashboard/market_stats.dart';
import 'package:cloud/models/dashboard/public_news_article.dart';
import 'package:cloud/models/dashboard/stats.dart';

/// 类型别名，用于向后兼容路由系统
typedef NewsArticle = PublicNewsArticle;

/// 获取汇率列表
Future<List<ExchangeRate>?> getExchangesList() async {
  final res = await api.get('api/tenant/exchanges');

  if (res.data == null) {
    return null;
  }

  if (res.data is List) {
    return (res.data as List)
        .map((e) => ExchangeRate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  return null;
}

/// 获取统计数据汇总
Future<StatsSummary?> getStatsSummary({
  Map<String, dynamic>? params,
}) async {
  try {
    final res = await api.get('api/core/stats/summary', data: params);

    if (res.data == null) {
      return null;
    }

    return StatsSummary.fromJson(res.data as Map<String, dynamic>);
  } catch (e) {
    // 如果 API 调用失败，返回 null
    return null;
  }
}

/// 获取市场采购的统计数据（已废弃，使用 getStatsSummary 代替）
// @Deprecated('使用 getStatsSummary 代替')
// Future<MarketPurchaseStats?> getMarketPurchasesStats() async {
//   // 调用新接口获取数据
//   final summary = await getStatsSummary();
//   if (summary?.data == null || summary!.data!.isEmpty) {
//     return null;
//   }

//   // 转换数据格式
//   final sortedEntries = summary.data!.entries.toList()
//     ..sort((a, b) => a.key.compareTo(b.key)); // 按月份排序

//   final timeLabels = <String>[];
//   final productData = <int>[];
//   final customerData = <int>[];
//   final serviceProviderData = <int>[];

//   for (final entry in sortedEntries) {
//     // 将 "2026-01" 格式转换为 "1月" 格式
//     final monthStr = _formatMonthLabel(entry.key);
//     timeLabels.add(monthStr);
//     productData.add(entry.value.marketProduct ?? 0);
//     customerData.add(entry.value.crmCompany ?? 0);
//     serviceProviderData.add(entry.value.supplySupplier ?? 0);
//   }

//   return MarketPurchaseStats(
//     timeLabels: timeLabels,
//     productData: productData,
//     customerData: customerData,
//     serviceProviderData: serviceProviderData,
//   );
// }

/// 格式化月份标签，将 "2026-01" 转换为 "1月"
String _formatMonthLabel(String monthKey) {
  try {
    final parts = monthKey.split('-');
    if (parts.length >= 2) {
      final month = int.parse(parts[1]);
      return '${month}月';
    }
    return monthKey;
  } catch (e) {
    return monthKey;
  }
}

/// 获取新闻文章列表
Future<List<PublicNewsArticle>?> getNewsArticles() async {
  try {
    final res = await api.get('api/tenant/news');

    if (res.data == null) {
      return null;
    }

    // 处理响应结构：可能直接是数组，也可能是 {data: [...], meta: {...}}
    List? articlesList;
    if (res.data is Map) {
      final data = res.data as Map<String, dynamic>;
      if (data['data'] is List) {
        articlesList = data['data'] as List;
      }
    } else if (res.data is List) {
      articlesList = res.data as List;
    }

    if (articlesList == null) {
      return null;
    }
    final result = articlesList
        .map((e) => PublicNewsArticle.fromJson(e as Map<String, dynamic>))
        .toList();
    logger.d('result9999: ${result[0].media}');
    logger.d('result9999: ${result[1].media}');
    return result;
  } catch (e) {
    // 如果 API 调用失败，返回空列表而不是抛出异常
    // 这样不会影响应用的其他功能
    return [];
  }
}

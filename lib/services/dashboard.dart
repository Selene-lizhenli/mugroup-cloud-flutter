import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/models/dashboard/market_stats.dart';
import 'package:cloud/models/dashboard/public_news_article.dart';
import 'package:cloud/models/dashboard/quote_top_stats.dart';
import 'package:cloud/models/dashboard/ship_top_stats.dart';
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
    StatsSummary? returnedData;
    final res = await api.get('api/tenant/stats/summary', data: params);
    if (res.data == null) {
      returnedData = null;
    }
    returnedData = StatsSummary.fromJson(res.data as Map<String, dynamic>);
    logger.d('returnedData ${returnedData.toString()}');
    return returnedData;
    // ignore: empty_catches
  } catch (e) {}
  return null;
}

 
Future<List<QuoteTopStats>?> getQuoteStatsSummary({
  Map<String, dynamic>? params,
}) async { 
    List<QuoteTopStats>? returnedData;
    final res = await api.get('api/tenant/showroom/quotations/charts/sample', data: params); 
    if (res.data == null) {
      returnedData = null;
    }
    returnedData = (res.data as List).map((e) => QuoteTopStats.fromJson(e as Map<String, dynamic>)).toList();
    logger.d(' returnedData ${returnedData}'); 
    return returnedData;  
}

Future<List<ShipTopStats>?> getShipStatsSummary({
  Map<String, dynamic>? params,
}) async { 
    List<ShipTopStats>? returnedData;
    final res = await api.get('api/tenant/showroom/samples/charts/shipmentamount',  ); 
    if (res.data == null) { 
      returnedData = null;
    }
    returnedData = (res.data as List).map((e) => ShipTopStats.fromJson(e as Map<String, dynamic>)).toList();
    logger.d(' getShipStatsSummary returnedData ${returnedData}'); 
    return returnedData;  
}

/// 格式化月份标签，将 "2026-01" 转换为 "1月"
// String _formatMonthLabel(String monthKey) {
//   try {
//     final parts = monthKey.split('-');
//     if (parts.length >= 2) {
//       final month = int.parse(parts[1]);
//       return '${month}月';
//     }
//     return monthKey;
//   } catch (e) {
//     return monthKey;
//   }
// }

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
    return result;
  } catch (e) {
    // 如果 API 调用失败，返回空列表而不是抛出异常
    // 这样不会影响应用的其他功能
    return [];
  }
}

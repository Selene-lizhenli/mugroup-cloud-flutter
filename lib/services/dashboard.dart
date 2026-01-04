import 'package:cloud/http/api.dart';
import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/models/dashboard/market_stats.dart';



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



/// 获取市场采购的统计数据
/// TODO: 接口待开发，目前返回 mock 数据
Future<MarketPurchaseStats?> getMarketPurchasesStats() async {
  // TODO: 当接口开发完成后，取消注释以下代码，并删除 mock 数据部分
  // final res = await api.get('api/tenant/market_purchases/stats');
  // if (res.data == null) {
  //   return null;
  // }
  // return MarketPurchaseStats.fromJson(res.data as Map<String, dynamic>);

  // Mock 数据
  await Future.delayed(const Duration(milliseconds: 300)); // 模拟网络延迟
  
  return const MarketPurchaseStats(
    timeLabels: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月'],
    productData: [120, 150, 180, 165, 200, 190, 220, 210],
    customerData: [80, 95, 110, 105, 130, 125, 145, 140],
    serviceProviderData: [60, 70, 85, 80, 95, 90, 105, 100],
  );
}

/// 文章数据模型
class NewsArticle {
  final int id;
  final String title; // 标题
  final String content; // 内容
  final String? imageUrl; // 图片URL

  NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
    );
  }
}

/// 获取新闻文章列表
/// TODO: 接口待开发，目前返回 mock 数据
Future<List<NewsArticle>?> getNewsArticles() async {
  // TODO: 当接口开发完成后，取消注释以下代码，并删除 mock 数据部分
  // final res = await api.get('api/tenant/news/articles');
  // if (res.data == null) {
  //   return null;
  // }
  // if (res.data is List) {
  //   return (res.data as List)
  //       .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
  //       .toList();
  // }
  // return null;

  // Mock 数据
  await Future.delayed(const Duration(milliseconds: 300)); // 模拟网络延迟

  return [
    NewsArticle(
      id: 1,
      title: '集团2024年度总结大会圆满召开',
      content: '''
 2024年12月，集团年度总结大会在总部隆重召开。本次大会全面回顾了2024年的工作成果，深入分析了当前市场形势，并对2025年的发展目标进行了规划。

会议期间，各部门负责人分别汇报了本年度的工作情况。在全体员工的共同努力下，集团在业务拓展、技术创新、团队建设等方面都取得了显著成绩。特别是在数字化转型方面，我们成功上线了多个重要系统，大大提升了工作效率。

展望2025年，集团将继续坚持创新驱动发展战略，加大研发投入，拓展新的业务领域。同时，我们也将进一步加强人才队伍建设，为集团的可持续发展提供有力保障。

会议最后，集团领导对全体员工一年来的辛勤付出表示感谢，并鼓励大家在新的一年里继续努力，为实现集团的发展目标而奋斗。
      ''',
      imageUrl: 'assets/splash.png',
    ),
    NewsArticle(
      id: 2,
      title: '新产品线正式发布，市场反响热烈',
      content: '''
经过数月的精心研发和市场调研，我们的新产品线于本月正式发布。新产品在功能、设计、用户体验等方面都进行了全面升级，一经推出便获得了市场的热烈反响。

/n\n
新产品线涵盖了多个系列，能够满足不同客户群体的需求。在发布会上，我们详细介绍了产品的核心功能和创新点，并进行了现场演示。与会客户对新产品的表现给予了高度评价。

目前，新产品已经开始接受预订，订单量持续增长。我们相信，随着新产品的逐步推广，将为集团带来新的增长点。
      ''',
      imageUrl: 'assets/splash.png',
    ),
    NewsArticle(
      id: 3,
      title: '集团荣获"年度最佳雇主"称号',
      content: '''
在刚刚结束的年度评选中，集团荣获"年度最佳雇主"称号。这一荣誉的获得，充分体现了集团在人力资源管理、员工关怀、企业文化建设等方面的卓越表现。

集团一直致力于为员工创造良好的工作环境和发展平台。我们提供有竞争力的薪酬福利、完善的培训体系、广阔的职业发展空间，让每一位员工都能在这里实现自己的价值。

未来，我们将继续坚持以人为本的管理理念，不断提升员工的获得感和幸福感，打造更加优秀的企业文化。
      ''',
      imageUrl: 'assets/splash.png',
    ),
  ];
}


 
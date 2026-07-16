import 'package:cloud/models/dashboard/exchange.dart';
import 'package:cloud/services/dashboard.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'exchange.g.dart';

@Riverpod(keepAlive: true)
class Exchange extends _$Exchange {
  @override
  Future<List<ExchangeRate>> build() async {
    return await _fetch();
  }

  Future<List<ExchangeRate>> _fetch() async {
    final response = await getExchangesList();
    return response ?? [];
  }

  /// 刷新汇率数据
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch());
  }

  /// 根据货币名称或简称查找汇率
  ExchangeRate? findRateByName(String? name) {
    final rates = state.value;
    if (rates == null || name == null || name.isEmpty) return null;
    
    return rates.firstWhere(
      (rate) => 
        rate.name?.toLowerCase() == name.toLowerCase() ||
        rate.shortName?.toLowerCase() == name.toLowerCase(),
      orElse: () => rates.first, // 如果找不到，返回第一个
    );
  }

  /// 根据货币简称查找汇率
  ExchangeRate? findRateByShortName(String? shortName) {
    final rates = state.value;
    if (rates == null || shortName == null || shortName.isEmpty) return null;
    
    return rates.firstWhere(
      (rate) => rate.shortName?.toLowerCase() == shortName.toLowerCase(),
      orElse: () => rates.first,
    );
  }

  /// 获取维度选项列表（返回包含 name、shortName、reverseExchangeRate 的对象列表）
  List<ExchangeRate> getDimensionOptions() {
    final rates = state.value;
    if (rates == null || rates.isEmpty) return [];
    
    // 过滤掉 name 为空的项，并按 name 去重
    final Map<String, ExchangeRate> uniqueRates = {};
    for (final rate in rates) {
      if (rate.name != null && rate.name!.isNotEmpty) {
        // 使用 name 作为 key 去重
        if (!uniqueRates.containsKey(rate.name)) {
          uniqueRates[rate.name!] = rate;
        }
      }
    }
    
    return uniqueRates.values.toList();
  }

  /// 计算货币换算
  /// [amount] 金额
  /// [fromCurrency] 源货币（供应商报价货币，通常是CNY）
  /// [toCurrency] 目标货币（报价单货币）
  /// 返回换算后的金额
  double? convertCurrency(double? amount, String? fromCurrency, String? toCurrency) {
    if (amount == null || fromCurrency == null || toCurrency == null) {
      return null;
    }

    final rates = state.value;
    if (rates == null || rates.isEmpty) return null;

    // 如果货币相同，直接返回
    if (fromCurrency.toLowerCase() == toCurrency.toLowerCase()) {
      return amount;
    }

    // 查找目标货币的汇率
    final toRate = findRateByShortName(toCurrency);
    if (toRate == null) return null;

    // 汇率是相对于CNY的，exchangeRate 是百分比形式（如 22 表示 0.22）
    final rateStr = toRate.exchangeRate ?? '0';
    final rate = double.tryParse(rateStr) ?? 0.0;
    final exchangeRate = rate / 100.0;

    // 从CNY转换为目标货币：amount / exchangeRate
    // 例如：100 CNY / 0.22 = 454.55 AUD
    if (fromCurrency.toUpperCase() == 'CNY') {
      if (exchangeRate == 0) return null;
      return amount / exchangeRate;
    }

    // 从目标货币转换为CNY：amount * exchangeRate
    // 例如：454.55 AUD * 0.22 = 100 CNY
    if (toCurrency.toUpperCase() == 'CNY') {
      return amount * exchangeRate;
    }

    // 如果都不是CNY，先转换为CNY，再转换为目标货币
    final fromRate = findRateByShortName(fromCurrency);
    if (fromRate == null) return null;

    final fromRateStr = fromRate.exchangeRate ?? '0';
    final fromRateValue = (double.tryParse(fromRateStr) ?? 0.0) / 100.0;
    
    if (fromRateValue == 0) return null;
    
    // 先转为CNY
    final cnyAmount = amount * fromRateValue;
    // 再转为目标货币
    if (exchangeRate == 0) return null;
    return cnyAmount / exchangeRate;
  }
}


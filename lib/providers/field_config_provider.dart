import 'dart:convert';
import 'package:cloud/models/field_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'field_config_provider.freezed.dart';

@freezed
class FieldConfigParams with _$FieldConfigParams {
  const factory FieldConfigParams({
    required String storageKey, // 存储的 Key
    required List<FieldConfig> defaultFields, // 默认字段列表
  }) = _FieldConfigParams;
}

class FieldConfigNotifier extends StateNotifier<List<FieldConfig>> {
  final String storageKey;
  final List<FieldConfig> defaultFields;

  FieldConfigNotifier(this.storageKey, this.defaultFields)
      : super(defaultFields) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(storageKey);

    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        final savedList = jsonList.map((e) => FieldConfig.fromJson(e)).toList();

        final savedMap = {for (var e in savedList) e.name: e.isVisible};

        state = defaultFields.map((item) {
          return item.copyWith(
            isVisible: savedMap[item.name] ?? item.isVisible,
          );
        }).toList();
        return;
      } catch (e) {
        debugPrint("FieldConfig 解析失败: $e");
      }
    }

    state = defaultFields;
  }

  Future<void> updateConfigs(List<FieldConfig> newConfigs) async {
    state = newConfigs;

    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(newConfigs.map((e) => e.toJson()).toList());
    await prefs.setString(storageKey, jsonString);
  }
}

final fieldConfigProvider = StateNotifierProvider.family<FieldConfigNotifier,
    List<FieldConfig>, FieldConfigParams>(
  (ref, params) {
    return FieldConfigNotifier(params.storageKey, params.defaultFields);
  },
);

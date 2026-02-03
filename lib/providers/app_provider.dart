import 'package:cloud/constants/app_feature_constants.dart';
import 'package:cloud/models/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// EntryFeature.id -> 权限字符串（后端 permissions 中的 key）
///
/// 逻辑定义在 `EntryFeatures` 中，这里只是一个便捷别名。
final Map<String, String> entryFeaturePermissionKeys =
    EntryFeatures.permissionKeys;

/// EntryFeature.id -> 是否拥有权限
final entryFeaturePermissionBoolsProvider = Provider<Map<String, bool>>((ref) {
  final permissions = ref.watch(userProvider).permissions ?? const <String>[]; 
  return {
    for (final e in entryFeaturePermissionKeys.entries)
      e.key: permissions.contains(e.value),
  };
});

class AuthNotifier extends ChangeNotifier {
  User? user;
  List<String>? permissions;
  bool get isLogged => user != null;

  void setUser(User? commingUser) {
    user = commingUser;
    permissions = commingUser?.permissions;
    notifyListeners();
  }

  void logout() {
    user = null;
    permissions = null;
    notifyListeners();
  }
}




final authNotifier = AuthNotifier();

final userProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return authNotifier;
});

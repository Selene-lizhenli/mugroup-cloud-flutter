import 'package:cloud/http/api.dart';
import 'package:cloud/models/user.dart';

/// 获取当前用户
Future<User?> fetchCurrentUser() async {
  try {
    final res = await api.get("api/tenant/user");
    return User.fromJson(res.data);
  } catch (e) {
    return null;
  }
}

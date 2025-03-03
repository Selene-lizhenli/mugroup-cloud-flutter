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

Future<List<User>?> fetchCurrentUsers({String? query}) async {
  try {
    final res = await api.get(
      'api/tenant/users',
      queryParameters:
          query != null && query.isNotEmpty ? {'keywords': query} : {},
    );
    return (res.data['data'] as List)
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e) {
    return [];
  }
}

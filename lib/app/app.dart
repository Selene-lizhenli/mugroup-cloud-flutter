import 'dart:io';

import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/user.dart';
import 'package:path_provider/path_provider.dart';

class App {
  late final Directory temporaryDirectory;

  User? _user;

  Future bootstrap() async {
    temporaryDirectory = await getTemporaryDirectory();
  }

  Future<User?> fetchUser() async {
    logger.d("获取用户");
    // TODO：模拟登录
    _user = const User(id: 1);

    return _user;
  }

  Future<User?> get user async {
    return _user ?? fetchUser();
  }
}

final app = App();

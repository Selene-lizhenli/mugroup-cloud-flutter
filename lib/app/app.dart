import 'dart:io';

import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/services/tenant.dart';
import 'package:path_provider/path_provider.dart';

class App {
  late final Directory temporaryDirectory;

  User? _user;

  Future bootstrap() async {
    temporaryDirectory = await getTemporaryDirectory();
  }

  Future<User?> fetchUser() async {
    logger.d("获取用户");
    _user = await fetchCurrentUser();

    return _user;
  }

  Future<User?> get user async {
    return _user ?? fetchUser();
  }

  void logout() {
    app._user = null;
  }
}

final app = App();

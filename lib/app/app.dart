import 'dart:io';

import 'package:cloud/models/user.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/services/tenant.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class App {
  late final Directory temporaryDirectory;

  final container = ProviderContainer();

  Future bootstrap() async {
    temporaryDirectory = await getTemporaryDirectory();
  }

  Future<User?> fetchUser() async {
    authNotifier.setUser(await fetchCurrentUser());

    return authNotifier.user;
  }

  Future<User?> get user async {
    return authNotifier.user ?? await fetchUser();
  }
}

final app = App();

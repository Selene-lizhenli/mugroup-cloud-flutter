import 'dart:io';

import 'package:cloud/models/cloud.dart';
import 'package:cloud/models/core.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/router/router.dart';
import 'package:cloud/services/tenant.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  late String fullVersion;
  late final Directory temporaryDirectory;

  late final SharedPreferences prefs;

  late List<Tenant> tenants;

  final container = ProviderContainer();

  final router = AppRouter();

  Future bootstrap() async {
    temporaryDirectory = await getTemporaryDirectory();
    prefs = await SharedPreferences.getInstance();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    fullVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  Future<Cloud> loadCoreProvider() {
    return container.read(coreProvider.future);
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

import 'dart:io';

import 'package:cloud/helper/helper.dart';
import 'package:cloud/http/core.dart';
import 'package:cloud/models/core.dart';
import 'package:cloud/models/user.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/router/router.dart';
import 'package:cloud/services/tenant.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  late final Directory temporaryDirectory;

  late final SharedPreferences prefs;

  late List<Tenant> tenants;

  final container = ProviderContainer();

  final router = AppRouter();

  Future bootstrap() async {
    temporaryDirectory = await getTemporaryDirectory();
    prefs = await SharedPreferences.getInstance();
  }

  Future fetchTenants() async {
    final resp = await coreApi.get("/api/core/tenants");
    final list =
        (resp.data as List).map((e) => e as Map<String, dynamic>).toList();

    tenants = list.map((e) => Tenant.fromJson(e)).toList();
    logger.d(tenants);
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

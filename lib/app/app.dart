import 'dart:io';

import 'package:path_provider/path_provider.dart';

class App {
  late final Directory temporaryDirectory;

  Future bootstrap() async {
    temporaryDirectory = await getTemporaryDirectory();
  }
}

final app = App();

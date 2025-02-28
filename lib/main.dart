import 'package:cloud/app/app.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await app.bootstrap();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // 设置状态栏图标亮度
    ),
  );

  runApp(
    UncontrolledProviderScope(
      container: app.container,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(
        reevaluateListenable: authNotifier,
      ),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF355EBF),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F4F6),
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
      ),
      builder: EasyLoading.init(),
    );
  }
}

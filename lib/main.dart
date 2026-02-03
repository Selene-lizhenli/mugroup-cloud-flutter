import 'package:cloud/app/app.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:cloud/widgets/watermark/watermark_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await app.bootstrap();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // 设置状态栏图标亮度
    ),
  );

  EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
        dragText: '下拉刷新',
        armedText: '释放开始',
        readyText: '刷新中...',
        processingText: '刷新中...',
        processedText: '成功了',
        noMoreText: '没有更多',
        failedText: '失败了',
        messageText: '最后更新于 %T',
      );

  EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
        dragText: '上拉加载',
        armedText: '释放开始',
        readyText: '加载中...',
        processingText: '加载中...',
        processedText: '成功了',
        noMoreText: '没有更多',
        failedText: '失败了',
        messageText: '最后更新于 %T',
      );

  try {
    await app.loadCoreProvider();
  } catch (e, stackTrace) {
    logger.e("加载核心Provider失败", error: e, stackTrace: stackTrace);
  }
  runApp(
    UncontrolledProviderScope(
      container: app.container,
      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final core = ref.watch(coreProvider);
    if (core.isLoading) {
      return MaterialApp(
        key: const ValueKey('loading'),
        home: const Scaffold(
          body: SizedBox(),
        ),
        builder: EasyLoading.init(),
      );
    }

    if (core.hasError) {
      final error = core.error is DioException
          ? (core.error as DioException).message
          : core.error.toString();

      return MaterialApp(
        key: const ValueKey('error'),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    return ref.refresh(coreProvider);
                  },
                  child: const Text('点击重试'),
                ),
              ],
            ),
          ),
        ),
        builder: EasyLoading.init(),
      );
    }

    TDTheme.needMultiTheme();

    // 监听主题变化
    final themeType = ref.watch(appThemeProvider);

    final tdTheme = TDThemeData.defaultData().copyWith(
      name: 'default',
      colorMap: {
        "brandColor1": const Color(0xFFF2F3FF),
        "brandColor2": const Color(0xFFD9E1FF),
        "brandColor3": const Color(0xFFB5C8FF),
        "brandColor4": const Color(0xFF8BABFF),
        "brandColor5": const Color(0xFF698EF2),
        "brandColor6": const Color(0xFF4C73D5),
        "brandColor7": const Color(0xFF355EBF),
        "brandColor8": const Color(0xFF063FA0),
        "brandColor9": const Color(0xFF002B79),
        "brandColor10": const Color(0xFF001B54),
      },
    );

    // 根据主题类型设置颜色
    final primaryColor = themeType == ThemeType.pink
        ? const Color(0xFFFA338A) // 玫粉色
        : const Color(0xFF355EBF); // 蓝色
    final secondaryColor = themeType == ThemeType.pink
        ? const Color(0xFF355EBF) // 蓝色
        : const Color(0xFFFA338A); // 玫粉色

    return MaterialApp.router(
      routerConfig: app.router.config(
        reevaluateListenable: authNotifier,
      ),
      theme: ThemeData(
        extensions: [tdTheme],
        useMaterial3: true,
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder: (BuildContext context) {
            return const Icon(Icons.arrow_back_ios_new_rounded);
          },
        ),
        brightness: Brightness.light,
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 240, 239, 240), //纸张背景色
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white, //玫粉色上的颜色
          secondary: secondaryColor,
          onSecondary: Colors.white, //蓝色上的颜色
          surfaceTint: const Color.fromARGB(255, 240, 239, 240), //纸张背景色  更淡
          surface: Colors.white, //卡片背景颜色
          onSurface: Colors.black, //字体颜色 黑色
          surfaceContainerHighest: Colors.grey, //灰色 不重要的文字
          error: const Color(0xFFDC3545), //错误提示
          errorContainer: const Color(0xFFF8D7DA),
          onErrorContainer: const Color(0xFF58151C),
          outline: Colors.grey, //分割线  灰色
          outlineVariant: const Color.fromARGB(235, 230, 230, 230), //分割线 淡淡
          tertiary: const Color.fromARGB(255, 248, 227, 164), //提醒色 淡淡
          surfaceContainer: const Color(0xFFF7F8FA),
          onTertiaryContainer: const Color(0xFF4A3A00),
        ),
        // 补充主题色：橘色(Color(0xFFFF9800))、绿色(Color(0xFF4CAF50))已添加到tdTheme.colorMap
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 240, 239, 240),
          centerTitle: true,
          titleTextStyle:
              TextStyle(color: Color.fromARGB(255, 18, 18, 18), fontSize: 18),
          scrolledUnderElevation: 0,
          elevation: 0,
          foregroundColor: Color.fromARGB(255, 74, 74, 74),
          toolbarHeight: 48,
        ),
      ),
      builder: (context, child) {
        return EasyLoading.init()(
          context,
          WatermarkWrapper(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}

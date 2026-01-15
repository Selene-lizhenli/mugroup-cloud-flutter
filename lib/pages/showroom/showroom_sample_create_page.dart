import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/showroom/widgets/showroom_sample_form.dart';
import 'package:cloud/pages/widgets/confirm_dialog.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class ShowroomSampleCreatePage extends HookConsumerWidget {
  const ShowroomSampleCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasValue = useState(false);

    Future<void> handleBack() async {
      if (!hasValue.value) {
        Navigator.of(context).pop();
        return;
      }
      final isConfirmed = await ConfirmDialog.show(
        context,
        title: '确认退出',
        content: '确定要退出吗？未保存的内容将会丢失。',
        confirmText: '确定退出',
        cancelText: '取消',
        confirmColor: Colors.red,
      );

      if (isConfirmed && context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          await handleBack();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('市场产品创建'),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: handleBack,
            ),
          ),
          body: ShowroomSampleForm(
            initial: null,
            onDirtyChanged: (dirty) {
              hasValue.value = dirty;
            },
            onSubmit: (data) async {
              EasyLoading.show(status: '创建中...');

              await storeShowroomSample(
                  {...data, 'item_type': 'market_product'});

              EasyLoading.dismiss();

              final prefs = await SharedPreferences.getInstance();
              // 序列化数据并存储，Key 可以根据 itemType 区分，防止不同类型产品混用
              String storageKey = 'last_sample_data_market_product';
              await prefs.setString(storageKey, jsonEncode(data));

              if (!context.mounted) return false;

              final isConfirmed = await ConfirmDialog.show(
                context,
                title: '创建成功',
                content: '样品已成功创建，您希望接下来做什么？',
                cancelText: '完成并返回',
                confirmText: '继续创建',
                confirmColor: Colors.blue,
              );

              if (isConfirmed) {
                hasValue.value = false;
                return true;
              } else {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }

              return true;
            },
          ),
        ));
  }
}

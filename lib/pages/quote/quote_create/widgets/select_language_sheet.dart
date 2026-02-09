import 'package:cloud/pages/quote/quote_create/provider/quote_create_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ================= Language Model =================

class LanguageItem {
  final String name;
  final String code;

  const LanguageItem({
    required this.name,
    required this.code,
  });
}

/// ================= Language List =================
/// 可随时换成接口数据
const List<LanguageItem> _languages = [
  LanguageItem(name: '英语(EN)', code: 'EN'),
  LanguageItem(name: '日语(JA)', code: 'JA'),
  LanguageItem(name: '西班牙语(ES)', code: 'ES'),
  LanguageItem(name: '葡萄牙语(PT)', code: 'PT'),
  LanguageItem(name: '俄语(RU)', code: 'RU'),
  LanguageItem(name: '法语(FR)', code: 'FR'),
  LanguageItem(name: '德语(DE)', code: 'DE'),
];

/// 根据语言代码获取 LanguageItem，用于按国家自动设置语言
LanguageItem? getLanguageByCode(String code) {
  for (final e in _languages) {
    if (e.code == code) return e;
  }
  return null;
}

class SelectLanguageSheet extends ConsumerWidget {
  const SelectLanguageSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(quoteCreateProvider.notifier);
    final state = ref.watch(quoteCreateProvider);
    const languages = _languages;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ================= Header =================
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "选择语言",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      '关闭',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            // ================= List =================
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: languages.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 16),
                itemBuilder: (context, index) {
                  final item = languages[index];
                  final selected = state.language != null &&
                      state.language?.code == item.code; 
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(item.name),
                    trailing: selected
                        ? const Icon(Icons.check, color: Colors.blue)
                        : null,
                    onTap: () {
                      notifier.setLanguage(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

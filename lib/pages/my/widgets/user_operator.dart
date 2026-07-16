import 'package:cloud/app/app.dart';
import 'package:cloud/constants/theme_config.dart';
import 'package:cloud/http/api.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/pages/cart/providers/cart_provider.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:cloud/providers/locale_provider.dart';
import 'package:cloud/providers/setting_provider.dart';
import 'package:cloud/providers/theme_provider.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flant/components/action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class UserOperatorSection extends HookConsumerWidget {
  const UserOperatorSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final cart = ref.read(cartProvider.notifier);
    final cloud = ref.watch(coreProvider).value;
    final currentTenant = cloud?.currentTenant;

    final theme = Theme.of(context);

    void showThemeSelector() {
      final currentTheme = ref.read(appThemeProvider);
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: 200,
          maxHeight: 320,
        ),
        builder: (sheetContext) {
          final sheetL10n = sheetContext.l10n;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheetL10n.selectTheme,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    ref
                        .read(appThemeProvider.notifier)
                        .setTheme(ThemeType.pink);
                    Navigator.pop(sheetContext);
                    EasyLoading.showSuccess(sheetL10n.themeSwitchedPink);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: currentTheme == ThemeType.pink
                            ? primaryColorPink
                            : colorScheme.outlineVariant,
                        width: currentTheme == ThemeType.pink ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: primaryColorPink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            sheetL10n.themePinkLabel,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: currentTheme == ThemeType.pink
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (currentTheme == ThemeType.pink)
                          Icon(
                            Icons.check_circle,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    ref
                        .read(appThemeProvider.notifier)
                        .setTheme(ThemeType.blue);
                    Navigator.pop(sheetContext);
                    EasyLoading.showSuccess(sheetL10n.themeSwitchedBlue);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: currentTheme == ThemeType.blue
                            ? primaryColorBlue
                            : colorScheme.outlineVariant,
                        width: currentTheme == ThemeType.blue ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: primaryColorBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            sheetL10n.themeBlueLabel,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: currentTheme == ThemeType.blue
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (currentTheme == ThemeType.blue)
                          Icon(
                            Icons.check_circle,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    }

    void showSettingSelector() {
      final settings = ref.read(settingProvider);
      final backupEnabled = settings.photoBackupToGallery;
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: 200,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        builder: (sheetContext) {
          return StatefulBuilder(
            builder: (context, setSheetState) {
              final sheetL10n = sheetContext.l10n;
              final selectedLanguage =
                  ref.read(appLocaleProvider.notifier).currentLanguage;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 备份照片到相册
                      Row(
                        children: [
                          Text(
                            sheetL10n.photoBackupToGalleryQuestion,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          ref
                              .read(settingProvider.notifier)
                              .setPhotoBackupToGallery(true);
                          Navigator.pop(sheetContext);
                          EasyLoading.showSuccess(sheetL10n.photoBackupEnabled);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                backupEnabled
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                sheetL10n.yes,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: backupEnabled
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                sheetL10n.photoBackupYesHint,
                                style: theme.textTheme.titleSmall?.copyWith(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          ref
                              .read(settingProvider.notifier)
                              .setPhotoBackupToGallery(false);
                          Navigator.pop(sheetContext);
                          EasyLoading.showSuccess(
                              sheetL10n.photoBackupDisabled);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                backupEnabled
                                    ? Icons.radio_button_unchecked
                                    : Icons.radio_button_checked,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                sheetL10n.no,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: backupEnabled
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                     
                      const Divider(height: 32),


                      // 选择语言
                      Text(
                        sheetL10n.switchLanguageQuestion,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          if (selectedLanguage == AppLanguage.zh) return;
                          ref
                              .read(appLocaleProvider.notifier)
                              .setLanguage(AppLanguage.zh);
                          setSheetState(() {});
                          EasyLoading.showSuccess(
                            sheetL10n.languageSwitchedChinese,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedLanguage == AppLanguage.zh
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                sheetL10n.languageChinese,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: selectedLanguage == AppLanguage.zh
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          if (selectedLanguage == AppLanguage.en) return;
                          ref
                              .read(appLocaleProvider.notifier)
                              .setLanguage(AppLanguage.en);
                          setSheetState(() {});
                          EasyLoading.showSuccess(
                            sheetL10n.languageSwitchedEnglish,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedLanguage == AppLanguage.en
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                sheetL10n.languageEnglish,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: selectedLanguage == AppLanguage.en
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(color: colorScheme.surface.withOpacity(0.49)),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            tileColor: colorScheme.surface.withOpacity(0.9),
            title: Text(
              l10n.myTheme,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface,
            ),
            leading: Icon(
              Icons.palette,
              color: colorScheme.primary,
            ),
            onTap: showThemeSelector,
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 1,
            color: colorScheme.primary.withOpacity(0.05),
          ),
          ListTile(
            tileColor: colorScheme.surface.withOpacity(0.9),
            title: Text(
              l10n.clearCache,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface,
            ),
            leading: Icon(
              Icons.cleaning_services,
              color: colorScheme.secondary,
            ),
            onTap: () {
              showFlanActionSheet(
                context,
                cancelText: l10n.cancel,
                actions: [
                  FlanActionSheetAction(
                    name: l10n.clearCartCache,
                    callback: (action) async {
                      cart.clear();
                      EasyLoading.showSuccess(l10n.clearSuccess);
                    },
                  ),
                ],
                closeable: false,
                safeAreaInsetBottom: true,
                closeOnClickAction: true,
              );
            },
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 1,
            color: colorScheme.primary.withOpacity(0.05),
          ),
          ListTile(
            tileColor: colorScheme.surface,
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface,
            ),
            title: Row(children: [
              Text(
                l10n.contactSupport,
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
            ]),
            leading: const Icon(
              Icons.phone,
              color: Color(0xFF08D9D6),
            ),
            onTap: () async {
              showFlanActionSheet(
                context,
                cancelText: l10n.cancel,
                actions: [
                  FlanActionSheetAction(
                    name: l10n.callShortNumber(
                      customerPhoneNumber.toString(),
                    ),
                    callback: (action) async {
                      final phoneNumber = customerPhoneNumber.toString().trim();
                      if (phoneNumber.isEmpty) {
                        EasyLoading.showError(l10n.shortNumberEmpty);
                        return;
                      }
                      try {
                        final uri = Uri(scheme: 'tel', path: phoneNumber);
                        await launchUrl(uri);
                      } catch (e) {
                        EasyLoading.showError(
                          l10n.callFailedWithError(
                            l10n.callFailed,
                            e.toString(),
                          ),
                        );
                      }
                    },
                  ),
                ],
                closeable: false,
                safeAreaInsetBottom: true,
                closeOnClickAction: true,
              );
            },
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 1,
            color: colorScheme.primary.withOpacity(0.05),
          ),
          ListTile(
            tileColor: colorScheme.surface,
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface,
            ),
            title: Row(children: [
              Text(
                l10n.settings,
                style: TextStyle(
                  color: colorScheme.onSurface,
                ),
              ),
            ]),
            leading: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 63, 63, 63),
            ),
            onTap: showSettingSelector,
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 1,
            color: colorScheme.primary.withOpacity(0.05),
          ),
          ListTile(
            tileColor: colorScheme.surface,
            title: Text(
              l10n.aboutApp(
                currentTenant?.title ?? '',
                app.fullVersion,
              ),
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
            ),
            leading: Icon(
              CupertinoIcons.info,
              color: colorScheme.tertiary,
            ),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            height: 1,
            color: colorScheme.primary.withOpacity(0.05),
          ),
          ListTile(
            tileColor: colorScheme.surface,
            title: Text(
              l10n.logout,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
            ),
            leading: Icon(
              Icons.logout,
              color: colorScheme.primary,
            ),
            onTap: () {
              showFlanActionSheet(
                context,
                cancelText: l10n.cancel,
                actions: [
                  FlanActionSheetAction(
                    name: l10n.logout,
                    callback: (action) async {
                      try {
                        await api.post('api/logout');
                      } catch (_) {}
                      authNotifier.logout();
                      app.router.replaceAll([LoginRoute()]);
                    },
                  ),
                ],
                closeOnClickAction: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

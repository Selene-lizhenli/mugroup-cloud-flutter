import 'package:cloud/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

class SearchAppTabbar extends HookConsumerWidget {
  final VoidCallback? onSearch;
  final Color? themeColor;
  /// 为 true 时进入页面后自动聚焦搜索框并弹出软键盘（适合独立搜索页）。
  final bool autofocus;

  const SearchAppTabbar({
    super.key,
    this.onSearch,
    this.themeColor, //搜索bar 默认是蓝色
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textController = useTextEditingController();
    final focusNode = useFocusNode();
    final themeColorValue = themeColor ?? colorScheme.primary;

    useEffect(() {
      textController.addListener(() {
        ref.read(searchTextProvider.notifier).state = textController.text;
      });
      return null;
    }, [textController]);

    useEffect(() {
      if (!autofocus) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
      return null;
    }, [autofocus, focusNode]);

    void handleSearch() {
      FocusScope.of(context).unfocus();
      // 触发搜索回调
      if (onSearch != null) {
        onSearch!();
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                boxShadow: const [], borderRadius: BorderRadius.circular(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    autofocus: autofocus,
                    cursorColor: themeColorValue,
                    controller: textController,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => handleSearch(),
                    decoration: InputDecoration(
                      hintText: l10n.selectUserSearchBarHint,
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeColorValue,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.outline,
                          width: 0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeColorValue,
                          width: 1.5,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          top: 2, bottom: 2, left: 12, right: 12),
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          )),
          GestureDetector(
            onTap: handleSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                l10n.search,
                style: TextStyle(
                  color: themeColorValue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

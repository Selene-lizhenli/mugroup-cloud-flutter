import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const double _kSearchFieldHeight = 40;

InputDecoration _buildSearchDecoration({
  required ColorScheme colorScheme,
  required TextEditingController searchController,
}) {
  return InputDecoration(
    hintText: '搜索SKU',
    isDense: true,
    filled: true,
    fillColor: Colors.grey[100],
    hintStyle: const TextStyle(
      color: Color(0xFF999999),
      fontSize: 12,
      height: 1.0,
    ),
    prefixIcon: const Icon(Icons.search, color: Color(0xFF999999), size: 16),
    prefixIconConstraints:
        const BoxConstraints(minWidth: 32, minHeight: _kSearchFieldHeight),
    suffixIcon: ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, child) {
        if (value.text.isEmpty) return const SizedBox();
        return IconButton(
          icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
          onPressed: searchController.clear,
        );
      },
    ),
    suffixIconConstraints:
        const BoxConstraints(minWidth: 30, minHeight: _kSearchFieldHeight),
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
  );
}

class InspectionDetailListHeader extends HookWidget {
  const InspectionDetailListHeader({
    super.key,
    required this.filteredCount,
    required this.totalCount,
    required this.finishedCount,
    required this.unfinishedCount,
    required this.searchController,
    required this.currentTab,
    required this.onAddTap,
  });

  final int filteredCount;
  final int totalCount;
  final int finishedCount;
  final int unfinishedCount;
  final TextEditingController searchController;
  final ValueNotifier<int> currentTab;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final keyboardFocusNode = useFocusNode();
    final overlayEntryRef = useRef<OverlayEntry?>(null);

    final removeKeyboardOverlay = useCallback(() {
      final entry = overlayEntryRef.value;
      if (entry == null) return;
      overlayEntryRef.value = null;
      entry.remove();
    }, const []);

    final dismissKeyboardSearch = useCallback(() {
      if (overlayEntryRef.value == null) return;
      keyboardFocusNode.unfocus();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        removeKeyboardOverlay();
      });
    }, [keyboardFocusNode, removeKeyboardOverlay]);

    final openKeyboardSearch = useCallback(() {
      if (overlayEntryRef.value != null) {
        keyboardFocusNode.requestFocus();
        return;
      }

      late final OverlayEntry entry;
      entry = OverlayEntry(
        builder: (overlayContext) => _KeyboardSearchOverlay(
          focusNode: keyboardFocusNode,
          controller: searchController,
          colorScheme: colorScheme,
          onDismiss: dismissKeyboardSearch,
        ),
      );

      overlayEntryRef.value = entry;
      Overlay.of(context).insert(entry);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (overlayEntryRef.value == entry) {
          keyboardFocusNode.requestFocus();
        }
      });
    }, [
      context,
      keyboardFocusNode,
      searchController,
      colorScheme,
      dismissKeyboardSearch,
    ]);

    useEffect(() {
      final observer = _MetricsObserver(() {
        overlayEntryRef.value?.markNeedsBuild();
      });
      WidgetsBinding.instance.addObserver(observer);
      return () {
        WidgetsBinding.instance.removeObserver(observer);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          removeKeyboardOverlay();
        });
      };
    }, [removeKeyboardOverlay]);

    return Column(
      mainAxisSize: MainAxisSize.min, // 避免无限扩张导致布局震荡
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5),
          child: Row(
            children: [
              Icon(Icons.format_list_bulleted,
                  color: colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              const Text(
                '验货SKU列表',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 30),
              const Spacer(),
              SizedBox(
                height: _kSearchFieldHeight,
                width: 123,
                child: TextField(
                  controller: searchController,
                  readOnly: true,
                  onTap: openKeyboardSearch,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(fontSize: 12, height: 1.2),
                  decoration: _buildSearchDecoration(
                    colorScheme: colorScheme,
                    searchController: searchController,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onAddTap,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  minimumSize: const Size(44, 36), // 高度合理，避免过小
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '新增',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontSize: 13,
                    height: 1.1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }
}

class _KeyboardSearchOverlay extends StatelessWidget {
  const _KeyboardSearchOverlay({
    required this.focusNode,
    required this.controller,
    required this.colorScheme,
    required this.onDismiss,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final ColorScheme colorScheme;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    const height = _kSearchFieldHeight * 2;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: bottomInset,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SizedBox(
                  height: height,
                  width: double.infinity,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: 2,
                    textInputAction: TextInputAction.search,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(fontSize: 12, height: 1.2),
                    onSubmitted: (_) => onDismiss(),
                    decoration: InputDecoration(
                      hintText: '搜索SKU',
                      isDense: true,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 241, 241, 241),
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 187, 187, 187),
                        fontSize: 12,
                        height: 1.0,
                      ),
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFF999999), size: 16),
                      prefixIconConstraints: const BoxConstraints(
                          minWidth: 32, minHeight: _kSearchFieldHeight),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: controller,
                        builder: (context, value, child) {
                          if (value.text.isEmpty) return const SizedBox();
                          return IconButton(
                            icon: const Icon(Icons.clear,
                                size: 16, color: Colors.grey),
                            onPressed: controller.clear,
                          );
                        },
                      ),
                      suffixIconConstraints: const BoxConstraints(
                          minWidth: 30, minHeight: _kSearchFieldHeight),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricsObserver extends WidgetsBindingObserver {
  _MetricsObserver(this._onMetricsChanged);

  final VoidCallback _onMetricsChanged;

  @override
  void didChangeMetrics() => _onMetricsChanged();
}

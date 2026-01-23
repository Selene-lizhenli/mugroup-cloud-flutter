import 'package:cloud/models/user.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/tenant.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// 可复用的员工搜索选择组件
class SearchableEmployeeField extends StatefulWidget {
  final String? label;
  final String hintText;
  final User? selectedEmployee;
  final ValueChanged<User?> onEmployeeSelected;
  final int maxHeight;

  const SearchableEmployeeField({
    super.key,
    this.label,
    this.hintText = '根据关键字搜索员工',
    this.selectedEmployee,
    required this.onEmployeeSelected,
    this.maxHeight = 300,
  });

  @override
  State<SearchableEmployeeField> createState() =>
      _SearchableEmployeeFieldState();
}

class _SearchableEmployeeFieldState extends State<SearchableEmployeeField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<User> _list = [];
  bool _loading = false;
  bool _showList = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // 如果有选中的员工，显示在搜索框中
    if (widget.selectedEmployee != null) {
      _controller.text = widget.selectedEmployee?.name ?? '';
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(SearchableEmployeeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果选中的员工发生变化，更新搜索框
    if (widget.selectedEmployee?.id != oldWidget.selectedEmployee?.id) {
      _controller.text = widget.selectedEmployee?.name ?? '';
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // 失去焦点时，如果搜索框为空，隐藏列表
      if (_controller.text.trim().isEmpty) {
        setState(() {
          _showList = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _search(String keyword) async {
    if (keyword.trim().isEmpty) {
      setState(() {
        _list = [];
        _showList = false;
      });
      return;
    }

    if (_loading) return;

    setState(() {
      _loading = true;
      _showList = true;
    });

    try {
      final result = await fetchCurrentUsers(queryParameters: {
        "search": keyword.trim(),
        "pageSize": 50,
      });

      if (!mounted) return;

      setState(() {
        _list = result ?? [];
        _loading = false;
      });
    } catch (e, s) {
      if (!mounted) return;

      debugPrint('搜索员工失败: $e\n$s');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('搜索失败，请稍后重试'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );

      setState(() {
        _loading = false;
      });
    }
  }

  void _onTextChanged(String value) {
    // 取消之前的定时器
    _debounceTimer?.cancel();

    // 如果搜索框被清空，清空选中状态
    if (value.trim().isEmpty) {
      widget.onEmployeeSelected(null);
      setState(() {
        _showList = false;
        _list = [];
      });
      return;
    }

    // 设置新的定时器，延迟搜索
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _search(value);
    });
  }

  void _onEmployeeTap(User employee) {
    setState(() {
      _controller.text = employee.name ?? '';
      _showList = false;
    });
    _focusNode.unfocus();
    widget.onEmployeeSelected(employee);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
        ],
        // 搜索框
        Stack(
          clipBehavior: Clip.none,
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !_loading,
              onChanged: _onTextChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                filled: true,
                fillColor: colorScheme.surfaceTint.withOpacity(0.85),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                suffixIcon: _loading
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: MuProgressIndicator(barWidth: 2),
                        ),
                      )
                    : _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _controller.clear();
                              widget.onEmployeeSelected(null);
                              setState(() {
                                _showList = false;
                                _list = [];
                              });
                            },
                          )
                        : const Icon(Icons.search, size: 18),
                isDense: true,
              ),
              textInputAction: TextInputAction.search,
            ),
            // 搜索结果列表
            if (_showList && _list.isNotEmpty)
              Positioned(
                top: 48,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: widget.maxHeight.toDouble(),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final emp = _list[index];
                        final isSelected =
                            widget.selectedEmployee?.id == emp.id;

                        return ListTile(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          title: Text(
                            emp.name ?? "-",
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 18,
                                  color: colorScheme.primary,
                                )
                              : null,
                          onTap: () => _onEmployeeTap(emp),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        // 空状态提示
        if (_showList && !_loading && _list.isEmpty && _controller.text.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '未搜索到员工',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
      ],
    );
  }
}


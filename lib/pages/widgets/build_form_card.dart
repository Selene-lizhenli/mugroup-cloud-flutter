import 'package:flutter/material.dart';

class BuildFormCard extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool isLast;
  final Widget? action;
  final bool defaultExpanded;
  final bool collapsible; // 新增：是否启用折叠功能

  const BuildFormCard({
    super.key,
    required this.title,
    required this.children,
    this.isLast = false,
    this.action,
    this.defaultExpanded = false,
    this.collapsible = false, // 默认不启用折叠
  });

  @override
  State<BuildFormCard> createState() => _BuildFormCardState();
}

class _BuildFormCardState extends State<BuildFormCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.collapsible ? widget.defaultExpanded : true;
  }

  void _toggleExpand() {
    if (!widget.collapsible) return;

    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldShowContent = widget.collapsible ? _isExpanded : true;

    return Container(
      margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: widget.collapsible ? _toggleExpand : null,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: Radius.circular(shouldShowContent ? 0 : 12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.action != null) ...[
                        widget.action!,
                        // 只有当有 action 且 启用了折叠 显示箭头时，才需要间距
                        if (widget.collapsible) const SizedBox(width: 8),
                      ],
                      // 只有启用折叠时，才显示箭头
                      if (widget.collapsible)
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 控制内容显示
          if (shouldShowContent)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 0),
                  ...widget.children,
                ],
              ),
            ),
        ],
      ),
    );
  }
}

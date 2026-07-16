import 'package:flutter/material.dart';

class AppExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget child;
  final Widget? subtitle;
  final VoidCallback? onForward;

  const AppExpansionTile({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onForward,
  });

  @override
  State<AppExpansionTile> createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends State<AppExpansionTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _arrowRotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _arrowRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
        widget.onForward?.call();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _toggleExpansion,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              children: [
                Expanded(child: widget.title),
                RotationTransition(
                  turns: _arrowRotation,
                  child: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
        ),
        if (widget.subtitle != null) widget.subtitle!,
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: ClipRect(
            child: ConstrainedBox(
              constraints: _isExpanded
                  ? const BoxConstraints(maxHeight: double.infinity)
                  : const BoxConstraints(maxHeight: 0.0),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

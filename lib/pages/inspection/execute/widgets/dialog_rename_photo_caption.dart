import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; 

class RenameCaptionDialog extends HookWidget {
  final String? caption;
  const RenameCaptionDialog({
    super.key,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: caption ?? '');
    final focusNode = useFocusNode();
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxWidth = MediaQuery.sizeOf(context).width;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          focusNode.requestFocus();
        }
      });
      return null;
    }, [focusNode]);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Material(
            color: colorScheme.surface,
            elevation: 24,
            shadowColor: Theme.of(context).shadowColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            maxLines: 3,
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: '请输入文字描述',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: colorScheme.outline.withOpacity(0.15),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    width: 0,
                                    color: colorScheme.surfaceTint
                                        .withOpacity(0.85)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color:
                                      colorScheme.surfaceTint.withOpacity(0.85),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: colorScheme.surfaceTint.withOpacity(1),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                    Positioned(
                      right: 13,
                      bottom: 3,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          // backgroundColor: Colors.green[100]!.withOpacity(0.65),
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () {
                          final name = nameController.text.trim();
                          if (name.isEmpty) return;
                          Navigator.of(context).pop(name);
                        },
                        child: Text(
                          '确定',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1, 
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

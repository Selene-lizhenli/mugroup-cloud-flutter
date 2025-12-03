import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SampleAppBar extends HookWidget {
  const SampleAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (Navigator.canPop(context))
          Material(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

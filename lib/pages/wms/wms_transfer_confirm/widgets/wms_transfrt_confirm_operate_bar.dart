import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class WmsTransferConfirmOperateBar extends HookConsumerWidget {
  final bool checked;
  final void Function(bool)? selectAll;
  final void Function()? transferIn;

  const WmsTransferConfirmOperateBar({
    super.key,
    required this.checked,
    this.selectAll,
    this.transferIn,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 120,
              child: TDCheckbox(
                title: "全选",
                checked: checked,
                onCheckBoxChanged: selectAll,
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: TextButton(
                  onPressed: transferIn,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "确认入库",
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

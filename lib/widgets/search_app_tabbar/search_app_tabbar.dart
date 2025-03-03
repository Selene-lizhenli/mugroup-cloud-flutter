import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchAppTabbar extends HookConsumerWidget {
  SearchAppTabbar({super.key});

  final textController = useTextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textController.addListener(() {
      print("当前输入框内容: ${textController.text}");
    });

    return SizedBox(
      width: double.infinity,
      height: 30,
      child: Row(
        children: [
          Expanded(
              child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 3)
                ],
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(left: 8)),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: textController,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        backgroundColor: Colors.white),
                    decoration: const InputDecoration(
                      hintText: '输入姓名/工号',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          )),
          GestureDetector(
            onTap: () {
              textController.clear();
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Text(
                '取消',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

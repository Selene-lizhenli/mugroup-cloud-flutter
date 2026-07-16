import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InspectionRemark extends HookWidget {
  final Color blue;
  final Color text;
  final TextEditingController controller;
  final bool hasError;

  const InspectionRemark({
    super.key,
    required this.blue,
    required this.text,
    required this.controller,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.edit_note, color: blue, size: 20),
              const SizedBox(width: 6),
              Text('验货备注',
                  style: TextStyle(
                      color: text,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1)),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '请输入验货备注信息（选填）',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError ? Colors.red : blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

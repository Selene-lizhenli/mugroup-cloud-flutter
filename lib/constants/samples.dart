import 'package:flutter/material.dart';

// 报价单审批状态文案
const Map<String, String> sampleApprovalStatusTextMap = {
  'draft': '待提交',
  'pending': '审批中',
  'approved': '已通过',
  'rejected': '已拒绝',
};

// 报价单审批状态颜色
const Map<String, Color> sampleApprovalStatusColorMap = {
  'draft': Colors.blue,
  'pending': Colors.orange,
  'approved': Colors.green,
  'rejected': Colors.red,
};

String sampleApprovalStatusText(String? status) {
  final key = (status ?? '').trim();
  return sampleApprovalStatusTextMap[key] ?? (status ?? '');
}

Color sampleApprovalStatusColor(String? status, {required Color fallback}) {
  final key = (status ?? '').trim();
  return sampleApprovalStatusColorMap[key] ?? fallback;
}


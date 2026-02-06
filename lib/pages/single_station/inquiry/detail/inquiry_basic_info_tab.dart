import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/single_station/single_station_inquiries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 询盘详情 - 基本信息 Tab
class InquiryBasicInfoTab extends StatelessWidget {
  const InquiryBasicInfoTab({super.key, required this.item});

  final SingleStationInquiries? item;

  /// 根据 UA 生成「来源」展示文案
  /// - 使用 [parseUaDeviceType] 得到设备中文描述
  /// - 包含 "wxwork" 时，追加 "企微"
  String _formatSource(String? ua) {
    final parsed = parseUaDeviceType(ua);
    String desc = parsed['description'] as String? ?? '未知设备'; 
    final lowerUa = ua?.toLowerCase() ?? '';
    if (lowerUa.contains('wxwork')) {
      desc = '$desc；企微';
    } 
    return desc;
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('已复制$label到剪贴板'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _rowWithCopy(
    BuildContext context,
    String label,
    String? value,
    ColorScheme colorScheme,
  ) {
    final displayValue = (value == null || value.isEmpty) ? '—' : value;
    final canCopy = value != null && value.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    displayValue,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (canCopy) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      _copyToClipboard(context, value!, label);
                    },
                    child: Icon(
                      Icons.copy_outlined,
                      size: 15,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String? value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              (value == null || value.isEmpty) ? '—' : value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (item == null) {
      return Center(
        child: Text(
          '缺少询盘信息',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      children: [
        Card(
          elevation: 0,
          color: colorScheme.surface.withOpacity(0.85),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                _row('客户名称', item!.name, colorScheme),
                _rowWithCopy(context, '邮箱', item!.email, colorScheme),
                _row('电话', item!.phone, colorScheme),
                _row('创建时间', formatDateTimeFull(item!.createdAt), colorScheme),
                _row('站点名称', item!.station?.nameCn ?? item!.station?.nameEn,
                    colorScheme),
                _row('IP 地址', item!.ip, colorScheme),
                _row('来源', _formatSource(item!.ua), colorScheme),
                _row('消息内容', item!.message, colorScheme),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


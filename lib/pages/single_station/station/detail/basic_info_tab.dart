import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 独立站详情 - 基本信息 Tab
class BasicInfoTab extends StatelessWidget {
  const BasicInfoTab({super.key, required this.item});

  final SingleStationItem? item;

  String _translateTheme(String? theme) {
    if (theme == null || theme.isEmpty) return '—';
    final t = theme.toLowerCase();
    if (t.contains('meimeiimage')) return '玫玫印象';
    if (t.contains('christmas')) return '圣诞恋歌';
    if (t.contains('default')) return '默认';
    return theme;
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: GestureDetector(
                    onDoubleTap: canCopy
                        ? () {
                            _copyToClipboard(
                              context,
                              value as String,
                              label,
                            );
                          }
                        : null,
                    child: Text(
                      displayValue,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (canCopy) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      _copyToClipboard(context, value as String, label);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.copy_outlined,
                        size: 15,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                      ),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
              (value == null || value.isEmpty) ? '无' : value,
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
          '缺少站点信息',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.86),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  _row('标题', item!.nameCn ?? item!.nameEn, colorScheme),
                  _row('英文标题', item!.nameEn, colorScheme),
                  _row('主题', _translateTheme(item!.theme), colorScheme),
                  _row('有效期', item!.expireTime, colorScheme),
                  _row('联系人', item!.contactPerson, colorScheme),
                  _rowWithCopy(context, '邮箱', item!.email, colorScheme),
                  _row('地址', item!.address, colorScheme),
                  _rowWithCopy(context, '分享链接', item!.stationUrl, colorScheme),
                  _row('备注', item!.remark, colorScheme),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

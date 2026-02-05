import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String _formatExpire(String? expireTime) {
  if (expireTime == null || expireTime.isEmpty) return '—';
  final s = expireTime.length >= 10 ? expireTime.substring(0, 10) : expireTime;
  return s.replaceAll('-', '.');
}

String _translateTheme(String? theme) {
  if (theme == null || theme.isEmpty) return '—';
  final t = theme.toLowerCase();
  if (t.contains('meimeiimage')) return '玫玫印象';
  if (t.contains('christmas')) return '圣诞恋歌';
  if (t.contains('default')) return '默认';
  return theme;
}

class StationItemCard extends StatelessWidget {
  const StationItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final SingleStationItem item;
  final void Function()? onTap;

  static const _christmasGreen = Color(0xFF165B33);
  static const _meimeiPink = Color(0xFFfa338a);

  bool get _isChristmasTheme => (item.theme ?? '').contains('christmas');

  bool get _isMeimeiTheme => (item.theme ?? '').contains('meimeiimage');

  bool get _hasCustomTheme => _isChristmasTheme || _isMeimeiTheme;

  Color? get _gradientRightColor {
    if (_isChristmasTheme) return _christmasGreen;
    if (_isMeimeiTheme) return null;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface.withOpacity(1);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Card(
        elevation: 0,
        color: surfaceColor,
        margin: const EdgeInsets.only(bottom: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item.nameCn ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if ((item.expireTime ?? '').isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '过期时间：${_formatExpire(item.expireTime)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 15),
                            ],
                            if ((item.theme ?? '').isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '主题：${_translateTheme(item.theme)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if ((item.stationUrl ?? '').isNotEmpty)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                          text: item.stationUrl ?? ''),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('已复制到剪贴板'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '站点链接：',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Flexible(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  item.stationUrl!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                Icons.copy_outlined,
                                                size: 15,
                                                color: colorScheme
                                                    .onSurfaceVariant
                                                    .withOpacity(0.4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

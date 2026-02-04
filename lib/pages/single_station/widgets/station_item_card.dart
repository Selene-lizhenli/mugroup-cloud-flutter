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
    final surfaceColor = colorScheme.surface.withOpacity(0.45);

    return Card(
      elevation: 0,
      color: surfaceColor,
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          // decoration: _gradientRightColor != null
          //     ? BoxDecoration(
          //         borderRadius: BorderRadius.circular(12),
          //         gradient: LinearGradient(
          //           begin: Alignment.centerRight,
          //           end: Alignment.center,
          //           colors: [_gradientRightColor!, surfaceColor],
          //         ),
          //       )
          //     : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // if (_isChristmasTheme)
              //   Positioned(
              //     right: 0,
              //     bottom: 0,
              //     child: Image.asset(
              //       'assets/photo/merrychristmas.png',
              //       fit: BoxFit.contain,
              //       width: 65,
              //       // height: 80,
              //     ),
              //   ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.nameCn ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(),
                          ),
                          if ((item.theme ?? '').isNotEmpty)
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
                          if ((item.expireTime ?? '').isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
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
                          // if ((item.stationUrl ?? '').isNotEmpty)
                          //   Padding(
                          //     padding: const EdgeInsets.only(top: 0),
                          //     child: Row(
                          //       children: [
                          //         Text(
                          //           '分享：',
                          //           style: Theme.of(context)
                          //               .textTheme
                          //               .bodySmall
                          //               ?.copyWith(
                          //                 color: colorScheme.onSurfaceVariant,
                          //               ),
                          //           maxLines: 1,
                          //           overflow: TextOverflow.ellipsis,
                          //         ),
                          //         Expanded(
                          //           child: Text(
                          //             item.stationUrl!,
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .bodySmall
                          //                 ?.copyWith(
                          //                   color: colorScheme.onSurfaceVariant,
                          //                 ),
                          //             maxLines: 1,
                          //             overflow: TextOverflow.ellipsis,
                          //           ),
                          //         ),
                          //         IconButton(
                          //           icon: Icon(
                          //             Icons.copy_outlined,
                          //             size: 15,
                          //             // color: colorScheme.outline,
                          //           ),
                          //           onPressed: () {
                          //             Clipboard.setData(
                          //               ClipboardData(
                          //                   text: item.stationUrl ?? ''),
                          //             );
                          //             ScaffoldMessenger.of(context)
                          //                 .showSnackBar(
                          //               const SnackBar(
                          //                 content: Text('已复制到剪贴板'),
                          //                 duration: Duration(seconds: 2),
                          //               ),
                          //             );
                          //           },
                          //           padding: EdgeInsets.zero,
                          //           constraints: const BoxConstraints(),
                          //           style: IconButton.styleFrom(
                          //             minimumSize: const Size(32, 32),
                          //             tapTargetSize:
                          //                 MaterialTapTargetSize.shrinkWrap,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

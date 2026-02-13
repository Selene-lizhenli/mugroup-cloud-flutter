import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/single_station/single_station_products.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StationProductCard extends HookWidget {
  const StationProductCard({
    super.key,
    required this.item,
  });

  final SingleStationSample item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Sample? sample = item.showroomSample;
    final int? sampleId = sample?.id ?? item.sampleId;

    final nameCn = useMemoized(
      () => sample?.nameCn ?? sample?.nameEn ?? '—',
      [sample?.nameCn, sample?.nameEn],
    );

    final catalog = useMemoized(
      () => sample?.category?.name ?? '—',
      [sample?.category?.name],
    );

    final purchaseCost = useMemoized(
      () => sample?.purchaseCost ?? '—',
      [sample?.purchaseCost],
    );

    final onTap = useCallback(() {
      if (!context.mounted) return;
      if (sampleId == null) return;
      context.router.push(ShowroomSampleDetailRoute(id: sampleId));
    }, [sampleId]);

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(10),
           boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(19, 0, 0, 0),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset.zero,
              ),
            ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                final coverUrl = sample?.cover;
                if (coverUrl == null || coverUrl.isEmpty) return;

                showDialog<void>(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: const EdgeInsets.all(16),
                      backgroundColor: Colors.transparent,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: InteractiveViewer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: _CoverImage(url: coverUrl),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 66,
                  height: 66,
                  child: _CoverImage(url: sample?.cover),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: sampleId == null ? null : onTap,
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameCn,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14, 
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _MetaLine(
                      label: '目录',
                      value: catalog,
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 4),
                    _MetaLine(
                      label: '采购单价',
                      value: purchaseCost,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
          height: 1.2,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Image.asset(
        'assets/icons/no_image.png',
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      placeholder: (_, __) => const ColoredBox(color: Colors.transparent),
      errorWidget: (_, __, ___) => Image.asset(
        'assets/icons/no_image.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

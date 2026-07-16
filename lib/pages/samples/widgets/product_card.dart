import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/core.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/sample/sample_extensions.dart';
import 'package:cloud/pages/samples/samples_l10n_helper.dart';
import 'package:cloud/providers/core_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ProductCard extends HookConsumerWidget {
  final Sample sample;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onTapAddSample;

  final int? cartCount;

  const ProductCard({
    super.key,
    required this.sample,
    this.onTap,
    this.onTapAddSample,
    this.cartCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayName =
        sample.localizedName(preferChinese: samplesPreferChinese(context));
    final itemTypeLabel = sample.itemType != null
        ? sampleItemTypeLabel(context, sample.itemType!)
        : '';
// ----------------------------------------------------------------------------
    // 有 xTenantId 表示列表曾带 X-Tenant-ID；展示名从 core 租户列表按 id 匹配。
    final cloud = ref.watch(coreProvider).value;
    final tenants = cloud?.tenants ?? const <Tenant>[];
    final xTenantKey = sample.xTenantId?.trim();
    final parsedTenantId = xTenantKey != null ? int.tryParse(xTenantKey) : null;
    final matchedTenant = xTenantKey == null || xTenantKey.isEmpty
        ? null
        : tenants.firstWhereOrNull(
            (t) => parsedTenantId != null
                ? t.id == parsedTenantId
                : t.id?.toString() == xTenantKey,
          );
    final tenantName = matchedTenant?.title?.trim();
// ----------------------------------------------------------------------------

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  sample.cover == null
                      ? Image.asset(
                          'assets/icons/no_image.png',
                          width: double.infinity,
                          fit: BoxFit.contain,
                        )
                      : CachedNetworkImage(
                          width: double.infinity,
                          fit: BoxFit.contain,
                          imageUrl: sample.cover!,
                          placeholder: (context, url) => AspectRatio(
                            aspectRatio: 1,
                            child: Container(),
                          ),
                        ),
                  if (itemTypeLabel.isNotEmpty)
                    Positioned(
                      top: 2,
                      left: 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: sampleItemTypeColor(sample.itemType!) ??
                              Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            itemTypeLabel,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (tenantName != null && tenantName.isNotEmpty)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: TDTag(
                        '  $tenantName  ',
                        isLight: true,
                        textColor: const Color.fromARGB(255, 51, 51, 51),
                        backgroundColor:
                            const Color.fromARGB(108, 202, 202, 202),
                        size: TDTagSize.small,
                      ),
                    ),
                ],
              ),
              if (displayName.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

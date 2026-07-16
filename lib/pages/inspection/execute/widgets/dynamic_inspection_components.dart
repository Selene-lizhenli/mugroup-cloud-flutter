import 'dart:math';

import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/inspection/execute/widgets/add_photo_category_dialog.dart';
import 'package:cloud/pages/inspection/execute/widgets/dialog_rename_photo_caption.dart';
import 'package:cloud/pages/inspection/providers/inspection_detail_provider.dart';
import 'package:cloud/pages/widgets/image_uploader_light.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _cText = Color(0xFF333333);
const _tipsText = Color.fromARGB(255, 147, 147, 147);

class DynamicTemplateCard extends StatelessWidget {  final Widget child;
  final EdgeInsetsGeometry? padding;

  const DynamicTemplateCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: _cBorder),
      ),
      child: child,
    );
  }
}

class MediaWithCaption {
  final TemporaryMedia media;
  final String? caption;
  final int? currentContainerPhotosCount;

  const MediaWithCaption({
    required this.media,
    this.caption,
    this.currentContainerPhotosCount,
  });
}

List<MediaWithCaption> parsePhotoSlots(dynamic raw) {
  if (raw is! List) return const [];
  final result = <MediaWithCaption>[];
  for (final item in raw) {
    if (item is! Map) continue;

    final map = Map<String, dynamic>.from(item);
    final idRaw = map['id'];

    if (idRaw == null) continue;

    final url = (map['url']?.toString() ?? '').trim();
    final media = TemporaryMedia(
      id: temporaryMediaIdFromJson(idRaw),
      uuid: map['uuid']?.toString(),
      thumbUrl: map['thumbUrl']?.toString() ?? map['thumb_url']?.toString(),
      url: url,
    );
    result.add(
      MediaWithCaption(
        media: media,
        currentContainerPhotosCount: parseContainerPhotosCount(
          map['currentContainerPhotosCount'],
        ),
        caption: map['caption']?.toString(),
      ),
    );
  }
  return result;
}

String photoSlotKey(TemporaryMedia media) {
  final uuid = media.uuid?.trim();
  if (uuid != null && uuid.isNotEmpty) return uuid;
  return media.id.toString();
}

bool photoSlotMatchesKey(Map<String, dynamic> photo, String key) {
  final photoId = photo['id']?.toString();
  final photoUuid = photo['uuid']?.toString();
  return key == photoId ||
      key == 'id-$photoId' ||
      (photoUuid != null && key == photoUuid);
}

bool photoSlotHasPersistedUuid(Map<String, dynamic> photo) {
  final photoUuid = photo['uuid']?.toString().trim();
  return photoUuid != null && photoUuid.isNotEmpty;
}

bool photoSlotIsEmpty(Map<String, dynamic> photo) {
  return (photo['url']?.toString() ?? '').trim().isEmpty;
}

bool photoSlotOccupied(Map<String, dynamic> photo) {
  return photoSlotHasPersistedUuid(photo) || !photoSlotIsEmpty(photo);
}

Map<String, dynamic>? readPhotoSlotData(
  List<Map<String, dynamic>> nodes,
  PhotoSlotPosition pos,
) {
  final node = nodes[pos.nodeIndex];
  final nodeProps = node['props'];
  if (nodeProps is! Map) return null;
  final photos = nodeProps['photos'];
  if (photos is! List || pos.photoIndex >= photos.length) return null;
  final photoRaw = photos[pos.photoIndex];
  if (photoRaw is! Map) return null;
  return Map<String, dynamic>.from(photoRaw);
}

void applyMediaToPhotoSlot(
  Map<String, dynamic> photo,
  TemporaryMedia? media,
) {
  if (media == null) {
    photo['url'] = '';
    photo['thumb_url'] = '';
    photo['uuid'] = '';
    return;
  }
  photo['id'] = media.id;
  photo['url'] = media.url;
  photo['uuid'] = media.uuid;
  photo['thumb_url'] = media.thumbUrl;
}

List<PhotoSlotPosition> collectPhotoCategorySlotPositions(
  List<Map<String, dynamic>> nodes,
) {
  final positions = <PhotoSlotPosition>[];
  for (var nodeIndex = 0; nodeIndex < nodes.length; nodeIndex++) {
    final node = nodes[nodeIndex];
    if (node['type']?.toString() != 'PhotoCategory') continue;
    final props = node['props'];
    if (props is! Map) continue;
    final photos = props['photos'];
    if (photos is! List) continue;
    for (var photoIndex = 0; photoIndex < photos.length; photoIndex++) {
      if (photos[photoIndex] is Map) {
        positions.add((nodeIndex: nodeIndex, photoIndex: photoIndex));
      }
    }
  }
  return positions;
}

bool hasDisplayablePhoto(TemporaryMedia media) {
  return media.url.trim().isNotEmpty;
}

void syncZoneContainerPhotosCount(List<Map<String, dynamic>> nodes) {
  var total = 0;
  for (final node in nodes) {
    if (node['type']?.toString() != 'PhotoCategory') continue;
    final nodeProps = node['props'];
    if (nodeProps is Map) {
      final photos = nodeProps['photos'];
      if (photos is List) total += photos.length;
    }
  }

  for (var nodeIndex = 0; nodeIndex < nodes.length; nodeIndex++) {
    final node = Map<String, dynamic>.from(nodes[nodeIndex]);
    if (node['type']?.toString() != 'PhotoCategory') continue;

    final nodePropsRaw = node['props'];
    if (nodePropsRaw is! Map) continue;

    final nodeProps = Map<String, dynamic>.from(nodePropsRaw);
    final photos = nodeProps['photos'];
    if (photos is! List) continue;

    nodeProps['photos'] = photos.map((item) {
      if (item is Map) {
        final photo = Map<String, dynamic>.from(item);
        photo['currentContainerPhotosCount'] = total;
        return photo;
      }
      return item;
    }).toList();
    node['props'] = nodeProps;
    nodes[nodeIndex] = node;
  }
}

typedef DynamicZones = Map<String, List<Map<String, dynamic>>>;
typedef DynamicZonesInput = Map<String, List<Map<String, dynamic>>?>;
typedef PhotoSlotPosition = ({int nodeIndex, int photoIndex});

DynamicZones cloneDynamicZones(DynamicZonesInput zones) {  return {
    for (final entry in zones.entries)
      entry.key: (entry.value ?? const <Map<String, dynamic>>[])
          .map((n) => Map<String, dynamic>.from(n))
          .toList(),
  };
}

int? parseContainerPhotosCount(dynamic raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '');
}

int? findSlotIndexByKey(List<Map<String, dynamic>> nodes, String key) {
  final slotPositions = collectPhotoCategorySlotPositions(nodes);
  for (var i = 0; i < slotPositions.length; i++) {
    final photo = readPhotoSlotData(nodes, slotPositions[i]);
    if (photo != null && photoSlotMatchesKey(photo, key)) {
      return i;
    }
  }
  return null;
}

({List<String> labels, List<String> keys}) buildPhotoCaptureFieldMeta(
  List<MediaWithCaption> mediaList,
) {
  final labels = <String>[];
  final keys = <String>[];
  for (final item in mediaList) {
    labels.add(item.caption ?? '');
    keys.add(photoSlotKey(item.media));
  }
  return (labels: labels, keys: keys);
}

/// 汇总 zone 内所有 PhotoCategory 的连拍字段（顺序与 [collectPhotoCategorySlotPositions] 一致）。
({List<String> labels, List<String> keys}) buildPhotoCaptureFieldMetaFromZoneNodes(
  List<Map<String, dynamic>> nodes,
) {
  final labels = <String>[];
  final keys = <String>[];
  for (final node in nodes) {
    if (node['type']?.toString() != 'PhotoCategory') continue;
    final props = node['props'];
    if (props is! Map) continue;
    final meta = buildPhotoCaptureFieldMeta(parsePhotoSlots(props['photos']));
    labels.addAll(meta.labels);
    keys.addAll(meta.keys);
  }
  return (labels: labels, keys: keys);
}

/// 从 [startSlotKey] 对应位置起，取当前及后续所有分类下的连拍 label / key（跳过已有图片的 slot）。
({List<String> labels, List<String> keys}) buildPendingCaptureFieldMetaFromSlot(
  List<Map<String, dynamic>> zoneNodes,
  String startSlotKey,
) {
  final all = buildPhotoCaptureFieldMetaFromZoneNodes(zoneNodes);
  final slotPositions = collectPhotoCategorySlotPositions(zoneNodes);
  final startIndex = findSlotIndexByKey(zoneNodes, startSlotKey);
  if (startIndex == null) {
    return (labels: const [], keys: const []);
  }

  final labels = <String>[];
  final keys = <String>[];
  for (var i = startIndex; i < slotPositions.length && i < all.labels.length; i++) {
    final photo = readPhotoSlotData(zoneNodes, slotPositions[i]);
    if (photo != null && photoSlotOccupied(photo)) continue;
    labels.add(all.labels[i]);
    keys.add(all.keys[i]);
  }
  return (labels: labels, keys: keys);
}

double computeUploaderSize(
  double maxWidth, {
  int crossAxisCount = 4,
  int maxUploaderColumns = 4,
  double spacing = 22,
}) {
  final slotWidth =
      ((maxWidth - spacing * (crossAxisCount - 1)) / crossAxisCount)
          .floorToDouble();
  final maxUploaderSize =
      ((maxWidth - spacing * (maxUploaderColumns - 1)) / maxUploaderColumns)
          .floorToDouble();
  return min(slotWidth, maxUploaderSize);
}

Map<int, TemporaryMedia?> assignMediasToPhotoSlots({
  required List<Map<String, dynamic>> nodes,
  required List<PhotoSlotPosition> slotPositions,
  required int startSlotIndex,
  required List<TemporaryMedia> medias,
}) {
  final slotMediaMap = <int, TemporaryMedia?>{};

  if (medias.isEmpty) {
    slotMediaMap[startSlotIndex] = null;
    return slotMediaMap;
  }

  for (var i = 0; i < medias.length; i++) {
    final preferredSlotIdx = startSlotIndex + i;
    int? targetSlotIdx;

    if (preferredSlotIdx < slotPositions.length &&
        !slotMediaMap.containsKey(preferredSlotIdx)) {
      final preferredPhoto =
          readPhotoSlotData(nodes, slotPositions[preferredSlotIdx]);
      if (preferredPhoto == null ||
          !photoSlotHasPersistedUuid(preferredPhoto)) {
        targetSlotIdx = preferredSlotIdx;
      }
    }

    if (targetSlotIdx == null) {
      final searchFrom = preferredSlotIdx < slotPositions.length
          ? preferredSlotIdx + 1
          : slotPositions.length;
      for (var slotIdx = searchFrom;
          slotIdx < slotPositions.length;
          slotIdx++) {
        if (slotMediaMap.containsKey(slotIdx)) continue;
        final photo = readPhotoSlotData(nodes, slotPositions[slotIdx]);
        if (photo != null && photoSlotHasPersistedUuid(photo)) continue;
        if (photo != null && !photoSlotIsEmpty(photo)) continue;
        targetSlotIdx = slotIdx;
        break;
      }
    }

    if (targetSlotIdx != null) {
      slotMediaMap[targetSlotIdx] = medias[i];
    }
  }

  return slotMediaMap;
}

List<Map<String, dynamic>> applySlotMediaUpdates(
  List<Map<String, dynamic>> nodes,
  List<PhotoSlotPosition> slotPositions,
  Map<int, TemporaryMedia?> slotMediaMap,
) {
  final updatesByNode = <int, Map<int, TemporaryMedia?>>{};
  for (final slotEntry in slotMediaMap.entries) {
    final pos = slotPositions[slotEntry.key];
    updatesByNode.putIfAbsent(pos.nodeIndex, () => {})[pos.photoIndex] =
        slotEntry.value;
  }

  final nextNodes = nodes.map((n) => Map<String, dynamic>.from(n)).toList();
  for (final nodeEntry in updatesByNode.entries) {
    final nodeMap = Map<String, dynamic>.from(nextNodes[nodeEntry.key]);
    final nodePropsRaw = nodeMap['props'];
    if (nodePropsRaw is! Map) continue;

    final nodeProps = Map<String, dynamic>.from(nodePropsRaw);
    final rawPhotos = nodeProps['photos'];
    if (rawPhotos is! List) continue;

    final nextPhotos = rawPhotos.asMap().entries.map((photoEntry) {
      final photoRaw = photoEntry.value;
      if (photoRaw is! Map) return photoRaw;
      final photo = Map<String, dynamic>.from(photoRaw);
      final media = nodeEntry.value[photoEntry.key];
      if (media != null || nodeEntry.value.containsKey(photoEntry.key)) {
        applyMediaToPhotoSlot(photo, media);
      }
      return photo;
    }).toList();

    nodeProps['photos'] = nextPhotos;
    nodeMap['props'] = nodeProps;
    nextNodes[nodeEntry.key] = nodeMap;
  }

  return nextNodes;
}

/// 在 zone 节点列表中按 key 找到首个 photo slot 并执行 [mutate]。
bool mutatePhotoSlotInNodes(
  List<Map<String, dynamic>> nodes,
  String key,
  void Function(Map<String, dynamic> photo) mutate, {
  int? targetNodeIndex,
}) {
  for (var nodeIndex = 0; nodeIndex < nodes.length; nodeIndex++) {
    if (targetNodeIndex != null && nodeIndex != targetNodeIndex) continue;

    final nodeMap = Map<String, dynamic>.from(nodes[nodeIndex]);
    if (nodeMap['type']?.toString() != 'PhotoCategory') continue;

    final nodePropsRaw = nodeMap['props'];
    if (nodePropsRaw is! Map) continue;

    final nodeProps = Map<String, dynamic>.from(nodePropsRaw);
    final rawPhotos = nodeProps['photos'];
    if (rawPhotos is! List) continue;

    var updated = false;
    final nextPhotos = rawPhotos.map((photoRaw) {
      if (photoRaw is! Map) return photoRaw;
      final photo = Map<String, dynamic>.from(photoRaw);
      if (!updated && photoSlotMatchesKey(photo, key)) {
        mutate(photo);
        updated = true;
      }
      return photo;
    }).toList();

    if (!updated) continue;

    nodeProps['photos'] = nextPhotos;
    nodeMap['props'] = nodeProps;
    nodes[nodeIndex] = nodeMap;
    return true;
  }
  return false;
}

// 单个字段的图片集合
class DynamicPhotoCategoryWidget extends HookConsumerWidget {
  final Map<String, dynamic> props;
  final String zoneKey;
  final int nodeIndex;

  const DynamicPhotoCategoryWidget({
    super.key,
    required this.props,
    required this.zoneKey,
    required this.nodeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = props['name']?.toString() ?? '照片';
    final mediaList = parsePhotoSlots(props['photos']);
    final detailState = ref.watch(inspectionDetailProvider);
    final zoneNodes =
        detailState.dynamicZonesNodes?[zoneKey] ?? const <Map<String, dynamic>>[];
    const crossAxisCount = 4; //每行展示几个，仅在手机端固定UI的，
    // final crossAxisCount =
    // (int.tryParse(props['columns']?.toString() ?? '') ?? 4).clamp(1, 6);
    final detailNotifier = ref.read(inspectionDetailProvider.notifier);
    const spacing = 22.0;
    const maxUploaderColumns = 4;

    void addPhotoSlot() {
      final currentZones = detailState.dynamicZonesNodes ?? const {};
      final nodes = currentZones[zoneKey];
      if (nodes == null || nodeIndex < 0 || nodeIndex >= nodes.length) return;

      final nextZones = cloneDynamicZones(currentZones);
      final nextNodes = nextZones[zoneKey]!;
      final nodeMap = Map<String, dynamic>.from(nextNodes[nodeIndex]);
      if (nodeMap['type']?.toString() != 'PhotoCategory') return;

      final nodePropsRaw = nodeMap['props'];
      if (nodePropsRaw is! Map) return;

      final nodeProps = Map<String, dynamic>.from(nodePropsRaw);
      final photos = List<dynamic>.from(nodeProps['photos'] as List? ?? []);
      final newId = Random().nextInt(0x7FFFFFFF);

      photos.add({
        'id': newId,
        'url': '',
        'thumb_url': '',
        'uuid': '',
        'caption': '照片 ${photos.length + 1}',
      });
      nodeProps['photos'] = photos;
      nodeMap['props'] = nodeProps;
      nextNodes[nodeIndex] = nodeMap;
      syncZoneContainerPhotosCount(nextNodes);
      detailNotifier.setDynamicZonesNode(nextZones);
    }

    void deleteMedia(TemporaryMedia deletedItem) {
      final currentZones = detailState.dynamicZonesNodes ?? const {};
      if (currentZones.isEmpty) return;

      final deleteKey = photoSlotKey(deletedItem);
      final nextZones = cloneDynamicZones(currentZones);
      var found = false;

      for (final nodes in nextZones.values) {
        if (found) break;
        if (mutatePhotoSlotInNodes(
          nodes,
          deleteKey,
          (photo) => applyMediaToPhotoSlot(photo, null),
        )) {
          found = true;
        }
      }

      if (found) {
        detailNotifier.setDynamicZonesNode(nextZones);
      }
    }

    void onMediaChanged(
        String key, List<TemporaryMedia> medias, TemporaryMedia? deletedItem) {
      if (deletedItem != null) {
        deleteMedia(deletedItem);
        return;
      }

      final currentZones = detailState.dynamicZonesNodes ?? const {};
      final nodes = currentZones[zoneKey];
      if (nodes == null) return;

      final slotPositions = collectPhotoCategorySlotPositions(nodes);
      final startSlotIndex = findSlotIndexByKey(nodes, key);
      if (startSlotIndex == null) return;

      final slotMediaMap = assignMediasToPhotoSlots(
        nodes: nodes,
        slotPositions: slotPositions,
        startSlotIndex: startSlotIndex,
        medias: medias,
      );

      final nextZones = cloneDynamicZones(currentZones);
      nextZones[zoneKey] = applySlotMediaUpdates(
        nextZones[zoneKey]!,
        slotPositions,
        slotMediaMap,
      );
      detailNotifier.setDynamicZonesNode(nextZones);
    }

    void onCaptionChanged(String key, String newCaption) {
      final currentZones = detailState.dynamicZonesNodes ?? const {};
      final nodes = currentZones[zoneKey];
      if (nodes == null || nodeIndex < 0 || nodeIndex >= nodes.length) return;

      final nextZones = cloneDynamicZones(currentZones);
      final nextNodes = nextZones[zoneKey]!;
      final updated = mutatePhotoSlotInNodes(
        nextNodes,
        key,
        (photo) => photo['caption'] = newCaption,
        targetNodeIndex: nodeIndex,
      );

      if (updated) {
        detailNotifier.setDynamicZonesNode(nextZones);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _cText,
          ),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final uploaderSize = computeUploaderSize(
              constraints.maxWidth,
              crossAxisCount: crossAxisCount,
              maxUploaderColumns: maxUploaderColumns,
              spacing: spacing,
            );

            Widget buildSlot(int index) {
              final slot = mediaList[index];
              final slotKey = photoSlotKey(slot.media);
              final caption = slot.caption ?? '';
              final pendingCaptureMeta =
                  buildPendingCaptureFieldMetaFromSlot(zoneNodes, slotKey);
              final List<TemporaryMedia> medias =
                  hasDisplayablePhoto(slot.media)
                      ? [slot.media]
                      : const <TemporaryMedia>[];

              return SizedBox(
                width: uploaderSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 图片上传组件
                    SizedBox(
                      width: uploaderSize,
                      height: uploaderSize - 10,
                      child: ImageUploaderInspection(
                        label: null,
                        maxCount: 1,
                        width: uploaderSize,
                        height: uploaderSize - 10,
                        value: medias, 
                        customIcon: Icons.camera_alt,
                        enableContinuous: true,
                        continuousMaxCount: pendingCaptureMeta.labels.length,
                        pendingCaptureFieldLabels: pendingCaptureMeta.labels, 
                        onMediaChanged: (list, [deletedItem]) =>
                            onMediaChanged(slotKey, list, deletedItem),
                      ),
                    ),
                    if (caption.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: GestureDetector(
                          onTap: () async {
                            //修改图片的描述文案
                            final captionResult = await showDialog<String>(
                              context: context,
                              useRootNavigator: true,
                              barrierDismissible: true,
                              builder: (dialogContext) => RenameCaptionDialog(
                                caption: caption,
                              ),
                            );
                            if (captionResult != null &&
                                captionResult != caption) {
                              onCaptionChanged(slotKey, captionResult);
                            }
                          },
                          child: Text(
                            caption,
                            style: const TextStyle(
                              fontSize: 12,
                              color: _tipsText,
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }

            // 加号占位符，点击后可以增加相机的数量
            Widget buildAddSlot() {
              return SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: uploaderSize,
                      height: uploaderSize - 15,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: addPhotoSlot,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 243, 243),
                              borderRadius: BorderRadius.circular(6),
                              // border: Border.all(
                              //   color: Colors.grey.shade300,
                              // ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Color(0xFF999999),
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final rowWidgets = <Widget>[];

            if (mediaList.isEmpty) {
              //当前只有分类，没有拍摄卡槽位
              rowWidgets.add(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [buildAddSlot()],
                ),
              );
            } else {
              for (var i = 0; i < mediaList.length; i += crossAxisCount) {
                final rowChildren = <Widget>[];
                final end = i + crossAxisCount;
                for (var j = i; j < end && j < mediaList.length; j++) {
                  if (j > i) rowChildren.add(const SizedBox(width: spacing));
                  rowChildren.add(buildSlot(j));
                }
                final lastIndex = mediaList.length - 1;
                var addSlotOnNextRow = false;
                if (lastIndex >= i && lastIndex < end) {
                  final slotCountInRow = lastIndex - i + 1;
                  if (slotCountInRow < crossAxisCount) {
                    rowChildren.add(const SizedBox(width: spacing));
                    rowChildren.add(buildAddSlot());
                  } else {
                    addSlotOnNextRow = true;
                  }
                }
                rowWidgets.add(
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rowChildren,
                  ),
                );
                if (addSlotOnNextRow) {
                  rowWidgets.add(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [buildAddSlot()],
                    ),
                  );
                }
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var r = 0; r < rowWidgets.length; r++) ...[
                  if (r > 0) const SizedBox(height: spacing),
                  rowWidgets[r],
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

Future<({String name, int columns})?> showAddPhotoCategoryDialog(
  BuildContext context,
) {
  return showDialog<({String name, int columns})>(
    context: context,
    builder: (_) => const AddPhotoCategoryDialog(),
  );
}

// 添加图片分类
void addPhotoCategoryToZone({
  required WidgetRef ref,
  required String zoneKey,
  required String name,
  required int columns,
}) {
  final detailState = ref.read(inspectionDetailProvider);
  final detailNotifier = ref.read(inspectionDetailProvider.notifier);
  final currentZones = detailState.dynamicZonesNodes ?? const {};
  if (!currentZones.containsKey(zoneKey)) return;

  final nextZones = cloneDynamicZones(currentZones);
  final nextNodes = nextZones[zoneKey]!;

  final randomString = generateRandomString(10);

  nextNodes.add({
    'type': 'PhotoCategory',
    'props': {
      "id": "PhotoCategory-$randomString",
      'name': name,
      'columns': columns,
      'photos': [],
    },
  });
  syncZoneContainerPhotosCount(nextNodes);
  detailNotifier.setDynamicZonesNode(nextZones);
}

//所有图片分类的集合
class DynamicInspectionPhotosWidget extends ConsumerWidget {
  final Map<String, dynamic> props;
  final List<Map<String, dynamic>> zoneChildren;
  final String zoneKey;

  const DynamicInspectionPhotosWidget({
    super.key,
    required this.props,
    required this.zoneChildren,
    required this.zoneKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = props['title']?.toString() ?? '验货内容';

    return DynamicTemplateCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.camera_alt_outlined,
                  size: 24, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _cText,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final result = await showAddPhotoCategoryDialog(context);
                  if (result == null || !context.mounted) return;
                  addPhotoCategoryToZone(
                    ref: ref,
                    zoneKey: zoneKey,
                    name: result.name,
                    columns: result.columns,
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 8),
          ...zoneChildren.asMap().entries.map((entry) {
            final node = entry.value;
            if (node['type']?.toString() != 'PhotoCategory') {
              return const SizedBox.shrink();
            }
            final nodeProps = node['props'];
            if (nodeProps is! Map) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: DynamicPhotoCategoryWidget(
                props: Map<String, dynamic>.from(nodeProps),
                zoneKey: zoneKey,
                nodeIndex: entry.key,
              ),
            );
          }),
        ],
      ),
    );
  }
}

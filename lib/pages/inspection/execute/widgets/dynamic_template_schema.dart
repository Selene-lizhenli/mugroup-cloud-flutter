/// 低代码验货动态模板 JSON 解析工具。
class DynamicTemplateSchema {
  DynamicTemplateSchema._();

  /// 从验货任务项、验货单或模板根对象中提取模板 schema。
  static Map<String, dynamic>? extract(dynamic source) {
    if (source == null) return null;
    if (source is! Map) return null;
    final map = Map<String, dynamic>.from(source);

    if (map.containsKey('content') || map.containsKey('zones')) {
      return map;
    }

    final nested = map['inspection_dynamic_template_json'];
    if (nested is Map) {
      return Map<String, dynamic>.from(nested);
    }
    return null;
  }

  static Map<String, List<Map<String, dynamic>>> zoneNodes(
    Map<String, dynamic> schema,
  ) {
    final zones = schema['zones'];
    if (zones is! Map) return const {};
    final result = <String, List<Map<String, dynamic>>>{};
    final zoneEntries = zones.entries.toList();

    for (var zoneIndex = 0; zoneIndex < zoneEntries.length; zoneIndex++) {
      final entry = zoneEntries[zoneIndex];
      final value = entry.value;
      if (value is! List) continue;

      var currentContainerPhotosCount = 0;  //当前容器下总共的图片的个数
      for (final raw in value) {
        if (raw is! Map) continue;
        if (raw['type']?.toString() != 'PhotoCategory') continue;
        final propsRaw = raw['props'];
        if (propsRaw is! Map) continue;
        final photosRaw = propsRaw['photos'];
        if (photosRaw is List) {
          currentContainerPhotosCount += photosRaw.length;
        }
      }

      final nodes = <Map<String, dynamic>>[];
      for (var nodeIndex = 0; nodeIndex < value.length; nodeIndex++) {
        final raw = value[nodeIndex];
        if (raw is! Map) continue;

        final node = Map<String, dynamic>.from(raw);
        if (node['type']?.toString() == 'PhotoCategory') {
          final propsRaw = node['props'];
          if (propsRaw is Map) {
            final props = Map<String, dynamic>.from(propsRaw);
            final photosRaw = props['photos'];
            if (photosRaw is List) {
              final photos = <dynamic>[];
              for (var photoIndex = 0;
                  photoIndex < photosRaw.length;
                  photoIndex++) {
                final item = photosRaw[photoIndex];
                if (item is Map) {
                  final photo = Map<String, dynamic>.from(item);
                  photo['id'] = '$zoneIndex-$nodeIndex-$photoIndex'; 
                  photo['currentContainerPhotosCount'] =    //当前容器下的图片的个数
                      currentContainerPhotosCount; 
                  photos.add(photo);
                } else {
                  photos.add(item);
                }
              }
              props['photos'] = photos;
            }
            node['props'] = props;
          }
        }
        nodes.add(node);
      }
      result[entry.key.toString()] = nodes;
    }
    return result;
  }
}

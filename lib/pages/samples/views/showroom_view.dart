import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/models/wms/warehouse_image.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 样品间列表页
class SamplesPageView extends HookConsumerWidget {
  const SamplesPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    useEffect(() {
      Future.microtask(() async { 
        await homeNotifier.fetchWarehouses(); 
      });

      return null;
    }, []);

    if (home.isLoadingWarehouses) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 过滤掉 abandoned 为 true 的样品间
    final filteredWarehouses = home.warehouses
        .where((warehouse) => warehouse.abandoned != true)
        .toList();

    if (filteredWarehouses.isEmpty) {
      return const Center(
        child: Text('暂无样品间数据'),
      );
    }
    // 使用 ListView.builder 构建可滚动列表，避免使用 ListView.separated
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.2;
    
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      cacheExtent: 500, // 增加缓存范围，减少重建
      itemCount: filteredWarehouses.length,
      itemBuilder: (context, index) {
        final warehouse = filteredWarehouses[index];
        return RepaintBoundary(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: index == filteredWarehouses.length - 1 ? 0 : 8),
            child: _WarehouseCard(
              warehouse: warehouse,
              imageHeight: imageHeight,
            ),
          ),
        );
      },
    );
  }

  List<WarehouseImage> _orderedImages(Warehouse? warehouse) {
    final images = warehouse?.image ?? [];
    final buildingImages =
        images.where((img) => _isBuildingImage(img)).toList();
    final otherImages = images.where((img) => !_isBuildingImage(img)).toList();
    return [...buildingImages, ...otherImages];
  }

  bool _isBuildingImage(WarehouseImage image) {
    final name = (image.filename ?? image.name ?? '').toLowerCase();
    return name.startsWith('building');
  }
}

// 独立的 Widget 以减少重建
class _WarehouseCard extends ConsumerWidget {
  final Warehouse warehouse;
  final double imageHeight;

  const _WarehouseCard({
    required this.warehouse,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);
    final orderedImages = _orderedImages(warehouse);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题，点击跳转
          InkWell(
            onTap: () {
              // 设置当前选中的样品间
              homeNotifier.setCurrentSelectedWarehouse(warehouse);
              // 点击样品间标题后切换到商品列表页（ProductView）
              homeNotifier.switchToProductView();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      warehouse.name ?? '-',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          // 图片区域（左右滑动，单张高度占屏幕 20%），点击预览大图
          SizedBox(
            height: imageHeight,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: _ImageGallery(images: orderedImages),
            ),
          ),
        ],
      ),
    );
  }

  List<WarehouseImage> _orderedImages(Warehouse warehouse) {
    final images = warehouse.image ?? [];
    final buildingImages =
        images.where((img) => _isBuildingImage(img)).toList();
    final otherImages = images.where((img) => !_isBuildingImage(img)).toList();
    return [...buildingImages, ...otherImages];
  }

  bool _isBuildingImage(WarehouseImage image) {
    final name = (image.filename ?? image.name ?? '').toLowerCase();
    return name.startsWith('building');
  }
}

// 独立的图片画廊 Widget，使用 RepaintBoundary 优化性能
class _ImageGallery extends StatelessWidget {
  final List<WarehouseImage> images;

  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        color: Colors.transparent,
        child: const Icon(Icons.warehouse, color: Colors.grey, size: 48),
      );
    }

    // 计算图片尺寸，限制内存使用
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = (screenWidth * 0.2).round(); // 大约屏幕宽度的20%

    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        cacheExtent: 200, // 限制水平列表的缓存范围
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          final imageUrl = image.thumbUrl ?? image.url ?? image.whiteUrl;
          return RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == images.length - 1 ? 0 : 8,
              ), 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    color: Colors.grey.shade300,
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? ImageShow(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            memCacheWidth: imageSize,
                            memCacheHeight: imageSize, 
                            enablePreview: true,
                          )
                        :  const Icon(Icons.image_not_supported,
                            color: Colors.grey, size: 48),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

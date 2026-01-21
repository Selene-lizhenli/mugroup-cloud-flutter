import 'package:cloud/models/wms.dart';
import 'package:cloud/models/wms/warehouse_image.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:flutter/material.dart'; 
import 'package:hooks_riverpod/hooks_riverpod.dart';


// 每个样品间 名称及图片
class WarehouseShowCard extends ConsumerWidget {
  final Warehouse warehouse;
  final double imageHeight;

  const WarehouseShowCard({
    super.key, 
    required this.warehouse,
    required this.imageHeight,
  });

  void _showImagePreview(BuildContext context, List<WarehouseImage> images, int initialIndex, String warehouseName) {
    int currentIndex = initialIndex;
    final pageController = PageController(initialPage: initialIndex);

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Stack(
                children: [
                  // 图片查看器
                  PageView.builder(
                    controller: pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final image = images[index];
                      final imageUrl = image.thumbUrl ?? image.url ?? image.whiteUrl;

                      return Center(
                        child: InteractiveViewer(
                          panEnabled: true,
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: imageUrl != null && imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image_not_supported, color: Colors.grey, size: 48);
                                  },
                                )
                              : const Icon(Icons.image_not_supported, color: Colors.grey, size: 48),
                        ),
                      );
                    },
                  ),
                  // 顶部标题栏
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            warehouseName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 底部指示器
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == currentIndex ? Colors.white : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
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
              child: _ImageGallery(
                images: orderedImages,
                warehouseName: warehouse.name ?? '-',
                onImageTap: _showImagePreview,
              ),
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
  final String warehouseName;
  final Function(BuildContext, List<WarehouseImage>, int, String) onImageTap;

  const _ImageGallery({
    required this.images,
    required this.warehouseName,
    required this.onImageTap,
  });

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
                        ? GestureDetector(
                            onTap: () => onImageTap(context, images, index, warehouseName),
                            child: ImageShow(
                              imageUrl: imageUrl,
                              fit: BoxFit.contain,
                              memCacheWidth: imageSize,
                              memCacheHeight: imageSize,
                              enablePreview: false, // 禁用默认预览，使用自定义预览
                            ),
                          )
                        : const Icon(Icons.image_not_supported,
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
 
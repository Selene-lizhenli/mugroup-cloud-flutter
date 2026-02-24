
import 'package:cloud/models/wms.dart';
import 'package:cloud/models/wms/warehouse_image.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 每个样品间 名称及图片
class WarehouseShowCard extends ConsumerWidget {
  final Warehouse warehouse;
  final bool? isPad;
  final double imageHeight;

  const WarehouseShowCard({
    super.key,
    required this.warehouse,
    required this.imageHeight,
    this.isPad,
  });
  //大图查看图片
  void showImagePreview(BuildContext context, List<WarehouseImage> images,
      int initialIndex, String warehouseName) {
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
                  // 图片查看器（支持全屏缩放）
                  InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final image = images[index];
                        final imageUrl =
                            image.url ?? image.thumbUrl ?? image.whiteUrl;

                        return Center(
                          child: imageUrl != null && imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: MuProgressIndicator(
                                      showText: true,
                                      fontSize: 11,
                                      textColor: Colors.white,
                                    ));
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image_not_supported,
                                        color: Colors.grey, size: 48);
                                  },
                                )
                              : const Icon(Icons.image_not_supported,
                                  color: Colors.grey, size: 48),
                        );
                      },
                    ),
                  ),
                  // 顶部标题栏
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                            color: index == currentIndex
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
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

  void showNotOpenDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标容器
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFFF9800),
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              // 标题
              const Text(
                '独立样品间暂未开放',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                  height: 1.2,
                ),
              ),
              //  文案换成：有独立样品间的部门请联系数字发展中心进行适配
              const SizedBox(height: 12),
              // 内容描述
              const Text(
                '敬请期待！',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),
              // 按钮
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    '我知道了',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTrumbImageTap(context, images, index, warehouseName) {
    if (warehouse.id == null) {
      // 如果warehouse.id没有，显示弹窗提示
      showNotOpenDialog(context);
    } else {
      // 正常显示图片预览
      showImagePreview(context, images, index, warehouseName);
    }
  }

  void onWarehouseTitleTap(context, homeNotifier) {
    // 设置当前选中的样品间
    // 点击样品间标题后切换到商品列表页（ProductView）
    if (warehouse.id == null) {
      showNotOpenDialog(context);
      return;
    }
    homeNotifier.setCurrentSelectedWarehouse(warehouse);
    homeNotifier.switchToProductView();
  }

  List<WarehouseImage> orderImages(Warehouse warehouse) {
    final images = warehouse.image ?? [];
    final startImages =
        images.where((img) => isSpecialImage(img, 'bs')).toList();
    final endImages = images.where((img) => isSpecialImage(img, 'be')).toList();
    final otherImages =
        images.where((img) => isNotSpecialImage(img, 'bs', 'be')).toList();
    return [...startImages, ...otherImages, ...endImages];
  }

  bool isSpecialImage(WarehouseImage image, String specialName) {
    final name = (image.filename ?? image.name ?? '').toLowerCase();
    return name.startsWith(specialName);
  }

  bool isNotSpecialImage(
      WarehouseImage image, String specialName1, String specialName2) {
    final name = (image.filename ?? image.name ?? '').toLowerCase();
    return !name.startsWith(specialName1) && !name.startsWith(specialName2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);
    final orderedImages = orderImages(warehouse);

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
            onTap: () => onWarehouseTitleTap(context, homeNotifier),
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
                onImageTap: onTrumbImageTap,
                isPad: isPad,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 独立的图片画廊 Widget，使用 RepaintBoundary 优化性能
/// 每屏最多显示 3 张图片，其余需左右滑动查看
class _ImageGallery extends StatelessWidget {
  final List<WarehouseImage> images;
  final String warehouseName;

  final Function(BuildContext, List<WarehouseImage>, int, String) onImageTap;
  final bool? isPad;

  const _ImageGallery({
    required this.images,
    required this.warehouseName,
    required this.onImageTap,
    this.isPad,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        color: Colors.transparent,
        child: const Icon(Icons.warehouse, color: Colors.grey, size: 48),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 8.0;
    // 左右 padding 各 8，3 张图之间 2 个间隔各 8 => 8*4=32
    final itemWidth = isPad == true
        ? (screenWidth - padding * 10) / 5
        : (screenWidth - padding * 8) / 3;
    final imageSize = itemWidth.round();

    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
        cacheExtent: 200,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          final imageUrl = image.thumbUrl ?? image.url ?? image.whiteUrl;
          return RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == images.length - 1 ? 0 : padding,
              ),
              child: SizedBox(
                width: itemWidth,
                // height: itemWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.grey.shade300,
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? GestureDetector(
                            onTap: () => onImageTap(
                                context, images, index, warehouseName),
                            child: ImageShow(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              memCacheWidth:
                                  image.thumbUrl == null ? imageSize : null,
                              memCacheHeight:
                                  image.thumbUrl == null ? imageSize : null,
                              enablePreview: false,
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

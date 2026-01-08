import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/wms.dart';
import 'package:cloud/pages/samples/providers/home_provider.dart';
import 'package:cloud/pages/widgets/image_show.dart';
import 'package:cloud/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SamplesPage extends HookConsumerWidget {
  const SamplesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    useEffect(() {
      Future.microtask(() async {
        try {
          EasyLoading.show(status: '加载中...');
          await homeNotifier.fetchWarehouses();
          EasyLoading.dismiss();
        } catch (e) {
          EasyLoading.dismiss();
        }
      });

      return null;
    }, []);

    return Scaffold(
      backgroundColor: colorScheme.surfaceTint,
      appBar: AppBar(
        title: const Text('样品间'),
        backgroundColor: colorScheme.surfaceTint,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildContent(
          context, ref, home.warehouses, home.isLoadingWarehouses),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref,
      List<Warehouse> warehouses, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (warehouses.isEmpty) {
      return const Center(
        child: Text('暂无样品间数据'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 两列
        crossAxisSpacing: 12, // 列间距
        mainAxisSpacing: 12, // 行间距
        childAspectRatio: 0.85, // 宽高比，调整卡片比例
      ),
      itemCount: warehouses.length,
      itemBuilder: (context, index) {
        final warehouse = warehouses[index];
        return _buildWarehouseCard(context, warehouse, ref);
      },
    );
  }

  Widget _buildWarehouseCard(
      BuildContext context, Warehouse warehouse, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // 设置当前选中的样品间并导航到 SamplesListPage
            homeNotifier.setCurrentSelectedWarehouse(warehouse);
            context.router.push(SamplesListRoute());
          },
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 顶部：图片
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: _buildImagePlaceholder(warehouse),
                ),
              ),
              // 底部：文本标签
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: Text(
                  warehouse.name ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Warehouse? warehouse) {
    // 安全获取图片 URL：优先使用缩略图，其次使用原图
    String? imageUrl;
    if (warehouse?.image != null && warehouse!.image!.isNotEmpty) {
      final firstImage = warehouse.image!.first;
      imageUrl = firstImage.thumbUrl ?? firstImage.url ?? firstImage.whiteUrl;
    }
    logger.d('imageUrl${imageUrl}${warehouse}');
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? ImageShow(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            )
          : Container(
              color: Colors.grey.shade300,
              child: const Icon(
                Icons.warehouse,
                color: Colors.grey,
                size: 48,
              ),
            ),
    );
  }
}

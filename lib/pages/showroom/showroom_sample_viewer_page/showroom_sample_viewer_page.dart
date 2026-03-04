import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/showroom/showroom_sample_detail_page/showroom_sample_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleViewerPage extends HookConsumerWidget {
  final List<int> initialIds; // 初始进入时已知的 ID 列表
  final int initialIndex; // 点击的是第几个
  final Future<List<int>> Function(int page)? onLoadMore; // 可选：加载更多 ID 的回调

  const ShowroomSampleViewerPage({
    super.key,
    required this.initialIds,
    required this.initialIndex,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 管理 ID 列表状态，支持动态追加
    final idsState = useState<List<int>>(initialIds);
    final isNoMore = useState(false);
    final isLoadingMore = useState(false);
    final currentPage = useRef(1);

    final pageController = usePageController(initialPage: initialIndex);

    // 2. 加载更多逻辑
    Future<void> handleLoadMore() async {
      if (onLoadMore == null || isNoMore.value || isLoadingMore.value) return;

      isLoadingMore.value = true;
      try {
        currentPage.value++;
        final nextIds = await onLoadMore!(currentPage.value);
        if (nextIds.isEmpty) {
          isNoMore.value = true;
        } else {
          idsState.value = [...idsState.value, ...nextIds];
        }
      } catch (e) {
        // 出错则回退页码
        currentPage.value--;
        EasyLoading.showError('加载更多失败');
      } finally {
        isLoadingMore.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        allowImplicitScrolling: false,
        controller: pageController,
        itemCount: idsState.value.length + (onLoadMore != null ? 1 : 0),
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          if (onLoadMore != null && index >= idsState.value.length - 2) {
            handleLoadMore();
          }
        },
        itemBuilder: (context, index) {
          if (index == idsState.value.length) {
            return _buildEndStatus(isLoadingMore.value, isNoMore.value);
          }

          final id = idsState.value[index];

          return ShowroomSampleDetailPage(
            key: ValueKey('sample_$id'),
            id: id,
          );
        },
      ),
    );
  }

  Widget _buildEndStatus(bool isLoading, bool noMore) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_motion_outlined,
              size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            noMore ? "已经看到最后啦" : "继续滑动加载更多",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud/core/rx_bus.dart';
import 'package:cloud/models/sample/media.dart';
import 'package:cloud/pages/home/models/home_state.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
class Home extends _$Home {
  @override
  HomeState build() {
    final homeState = HomeState(
      bus: RxBus(),
      currentPage: 0,
      pageController: PageController(),
      searchTextController: TextEditingController(),
      search: null,
      media: [
        const TemporaryMedia(
          id: 1222,
          url:
              "https://mu-cloud.oss-cn-hangzhou.aliyuncs.com/tenant-cloud/showroom/image/367194/conversions/199A1187-white.jpg",
        ),
        const TemporaryMedia(
          id: 1223,
          url:
              "https://mu-cloud.oss-cn-hangzhou.aliyuncs.com/tenant-cloud/showroom/image/367194/conversions/199A1187-white.jpg",
        )
      ],
      currentMediaId: 1222,
    );

    ref.onDispose(() {
      homeState.pageController.dispose();
      homeState.searchTextController.dispose();
      homeState.bus.dispose();
    });

    return homeState;
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
  }

  void addMedia(TemporaryMedia media) {
    var list = state.media;
    if (!state.media.contains(media)) {
      list = [media, ...list];
    }

    state = state.copyWith(
      media: list,
      currentMediaId: media.id,
    );
  }
}

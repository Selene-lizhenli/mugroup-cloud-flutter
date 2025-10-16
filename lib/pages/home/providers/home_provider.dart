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
          id: 2318463,
          thumbUrl:
              'https://mu-cloud.oss-cn-hangzhou.aliyuncs.com/tenant-cloud/temporary/2318463/conversions/CAP2644820930011794157-thumb.jpg',
          url:
              "https://mu-cloud.oss-cn-hangzhou.aliyuncs.com/tenant-cloud/temporary/2318463/CAP2644820930011794157.jpg",
        ),
        const TemporaryMedia(
          id: 2318464,
          thumbUrl:
              'https://mu-cloud.oss-cn-hangzhou.aliyuncs.com/tenant-cloud/temporary/2318464/conversions/CAP5753167623670165613-thumb.jpg',
          url:
              "https://mu-cloud.oss-cn-hangzhou.aliyuncs.com/tenant-cloud/temporary/2318464/CAP5753167623670165613.jpg",
        )
      ],
      currentMediaId: 2318463,
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

  HomeState deleteMedia(TemporaryMedia media) {
    final nextMedia = List.of(state.media);
    var nextCurrentMediaId = state.currentMediaId;

    nextMedia.remove(media);

    if (media.id == nextCurrentMediaId) {
      nextCurrentMediaId = nextMedia.firstOrNull?.id;
    }

    state = state.copyWith(
      media: nextMedia,
      currentMediaId: nextCurrentMediaId,
    );

    return state;
  }
}

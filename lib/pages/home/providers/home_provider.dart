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
      pageController: PageController(initialPage: 0),
      searchTextController: TextEditingController(),
      search: null,
      media: [],
      currentMediaId: null,
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

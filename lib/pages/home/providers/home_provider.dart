import 'package:cloud/core/rx_bus.dart';
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
}

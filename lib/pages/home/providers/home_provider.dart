import 'package:cloud/pages/home/models/home_state.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
class Home extends _$Home {
  @override
  HomeState build() {
    return HomeState(
      currentPage: 0,
      pageController: PageController(),
    );
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }
}

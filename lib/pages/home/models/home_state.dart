import 'package:cloud/core/rx_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    required RxBus bus,
    required int currentPage,
    required PageController pageController,
    required TextEditingController searchTextController,
    String? search,
  }) = _HomeState;
}

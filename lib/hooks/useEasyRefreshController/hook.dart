import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

EasyRefreshController useEasyRefreshController({
  bool controlFinishRefresh = false,
  bool controlFinishLoad = false,
}) {
  return use(_EasyRefreshControllerHook(
    controlFinishRefresh: controlFinishRefresh,
    controlFinishLoad: controlFinishLoad,
  ));
}

class _EasyRefreshControllerHook extends Hook<EasyRefreshController> {
  const _EasyRefreshControllerHook({
    required this.controlFinishLoad,
    required this.controlFinishRefresh,
  });

  final bool controlFinishLoad;
  final bool controlFinishRefresh;

  @override
  _EasyRefreshControllerHookState createState() =>
      _EasyRefreshControllerHookState();
}

class _EasyRefreshControllerHookState
    extends HookState<EasyRefreshController, _EasyRefreshControllerHook> {
  @override
  void initHook() {
    super.initHook();
  }

  late final controller = EasyRefreshController(
    controlFinishRefresh: hook.controlFinishRefresh,
    controlFinishLoad: hook.controlFinishLoad,
  );

  @override
  EasyRefreshController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useEasyRefreshController';
}

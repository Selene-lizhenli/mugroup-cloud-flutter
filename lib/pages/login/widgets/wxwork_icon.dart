import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 纯展示用的企微圆形图标，可在多个地方复用
class WxworkIcon extends StatelessWidget {
  final double size;

  const WxworkIcon({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 2,
      height: size + 2,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/icons/wxwork.svg',
        width: size,
        height: size,
      ),
    );
  }
}


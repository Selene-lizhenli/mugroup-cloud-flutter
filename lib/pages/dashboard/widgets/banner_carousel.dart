import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

/// 首页 Banner 轮播图
/// - 自动轮播
/// - 底部小圆点指示
class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  int _currentIndex = 0;

  final List<String> _images = [
    'assets/carouse/yiwudong4.jpg',
    'assets/carouse/yiwudong4-2.jpg',
    'assets/carouse/yiwudong4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final bannerHeight = size.height * 0.19;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ===== Banner =====
        SizedBox(
          height: bannerHeight,
          width: double.infinity,
          child: CarouselSlider(
            items: _images.map((url) {
              return _BannerItem(imageUrl: url);
            }).toList(),
            options: CarouselOptions(
              height: bannerHeight,
              viewportFraction: 1,
              autoPlay: true,
              enableInfiniteScroll: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              onPageChanged: (index, _) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
        ),

        const SizedBox(height: 6),

        // ===== 底部指示点 =====
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (index) {
            final selected = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: selected ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: selected
                    ? colorScheme.secondary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// 单个 Banner Item
class _BannerItem extends StatelessWidget {
  final String imageUrl;

  const _BannerItem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}

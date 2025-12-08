import 'package:cloud/pages/showroom/showroom_sample_detail_page/type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SampleAppBar extends HookWidget {
  final ScrollController scrollController;
  final List<ElevatorFloor> electorFloors;
  const SampleAppBar({
    super.key,
    required this.scrollController,
    required this.electorFloors,
  });

  @override
  Widget build(BuildContext context) {
    final appBarKey = GlobalKey();
    final backgroupOpacity = useState(0.0);

    useEffect(() {
      calAppOpacity() {
        final offset = scrollController.offset;

        // final opactiy1 = (1 - offset / 200).clamp(0.0, 1.0);

        final opactiy2 = ((offset - 200) / 200).clamp(0.0, 1.0);

        backgroupOpacity.value = opactiy2;
      }

      scrollController.addListener(calAppOpacity);

      return () {
        scrollController.removeListener(calAppOpacity);
      };
    }, []);

    return Container(
      key: appBarKey,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(backgroupOpacity.value),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(backgroupOpacity.value * 0.5),
            width: 0.3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (Navigator.canPop(context))
                  Stack(
                    children: [
                      Opacity(
                        opacity: 1 - backgroupOpacity.value,
                        child: Material(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: backgroupOpacity.value,
                        child: IgnorePointer(
                          ignoring: true,
                          child: Material(
                            borderRadius: BorderRadius.circular(4),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 26,
                                height: 26,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
              ],
            ),
            Opacity(
              opacity: backgroupOpacity.value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var electorFloor in electorFloors)
                    _ElevatorFloor(
                      electorFloor.name,
                     onTap: () {
                        final context = electorFloor.key.currentContext;
                        if (context == null) {
                          return;
                        }

                        // appbar 高度
                        final appBarBox = appBarKey.currentContext!
                            .findRenderObject() as RenderBox;
                        final appBarheight = appBarBox.size.height;

                        final ctx = electorFloor.key.currentContext;
                        if (ctx == null) return;

                        final box = ctx.findRenderObject() as RenderBox;

                        final offset = box.localToGlobal(Offset.zero);

                        final realOffset =
                            offset.dy + scrollController.offset - appBarheight;

                        scrollController.animateTo(
                          realOffset,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class _ElevatorFloor extends StatelessWidget {
  final String name;
  final GestureTapCallback onTap;
  const _ElevatorFloor(this.name, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(name),
      ),
    );
  }
}

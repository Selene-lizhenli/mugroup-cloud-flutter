import 'package:cloud/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SampleAppBar extends HookWidget {
  final ScrollController scrollController;
  const SampleAppBar({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
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
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 15,
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
                                width: 20,
                                height: 20,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 15,
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
            // Opacity(
            //   opacity: backgroupOpacity.value,
            //   child: const Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("商品"),
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}

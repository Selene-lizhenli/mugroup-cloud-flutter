import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/showroom/widgets/showroom_sample_form.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleEditPage extends HookConsumerWidget {
  final int id;
  const ShowroomSampleEditPage({super.key, @pathParam required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sample = useState<Sample?>(null);

    useEffect(() {
      () async {
        final resp = await getSample(id);
        sample.value = resp;
      }();
      return null;
    }, [id]);

    if (sample.value == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text('样品编辑')),
      body: ShowroomSampleForm(
        initial: sample.value,
        onSubmit: (data) async {
          await updateShowroomMarketProduct(id, data);
          EasyLoading.showSuccess("编辑成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

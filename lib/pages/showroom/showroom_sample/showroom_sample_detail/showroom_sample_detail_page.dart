import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleDetailPage extends HookConsumerWidget {
  final int id;
  const ShowroomSampleDetailPage({super.key, @pathParam required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sample = useState<Sample?>(null);

    loadSample(int id) async {
      final data = await getSample(id);
      sample.value = data;
      logger.d(sample);
    }

    useEffect(() {
      loadSample(id);
      return () {};
    }, [id]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('样品详情'),
      ),
      body: const Column(
        children: [Text('wici')],
      ),
    );
  }
}

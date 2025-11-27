import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/schema.dart';
import 'package:cloud/services/schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleCreatePage extends HookConsumerWidget {
  const ShowroomSampleCreatePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schema = useState<List<Schema>?>(null);

    useEffect(() {
      loadSchema() async {
        final resp = await getSchema('showroom_samples');
        schema.value = resp;
      }

      loadSchema();
      return () {};
    }, []);
    return Scaffold(
      appBar: AppBar(title: const Text('样品创建')),
      body: Container(),
    );
  }
}

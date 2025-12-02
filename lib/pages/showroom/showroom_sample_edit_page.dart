import 'package:auto_route/auto_route.dart';
import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/models/schema.dart';
import 'package:cloud/pages/widgets/dynamic_build_field.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleEditPage extends HookConsumerWidget {
  final int id;
  const ShowroomSampleEditPage({super.key, @pathParam required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final schemas = useState<List<Schema>?>(null);
    final sample = useState<Sample?>(null);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    useEffect(() {
      loadSchema() async {
        final resp = await getSchema('showroom_samples');
        schemas.value = resp?.where((s) => s.hidden != true).toList();
      }

      loadSchema();
      return () {};
    }, []);

    useEffect(() {
      () async {
        final resp = await getSample(id);
        sample.value = resp;
      }();
      return null;
    }, [id]);

    if (schemas.value == null || sample.value == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    logger.d(sample.value);
    logger.d(schemas.value);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('样品编辑')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            initialValue: sample.value!.toJson(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in schemas.value ?? [])
                  DynamicBuildField(schema: item),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () async {
            final formState = formKey.currentState;
            if (formState?.saveAndValidate() ?? false) {
              final values = formState?.value;
              debugPrint('提交表单: $values');

              await updateShowroomSample(id, values);
            } else {
              debugPrint('表单校验失败');
            }
          },
          child: const Text(
            '提交',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

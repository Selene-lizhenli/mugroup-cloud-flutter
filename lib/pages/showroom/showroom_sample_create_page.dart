import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/schema.dart';
import 'package:cloud/pages/widgets/dynamic_build_field.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

@RoutePage()
class ShowroomSampleCreatePage extends HookConsumerWidget {
  const ShowroomSampleCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final schemas = useState<List<Schema>?>(null);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    useEffect(() {
      loadSchema() async {
        final resp = await getSchema('showroom_samples');
        schemas.value = resp?.where((s) => s.hidden != true).toList();
      }

      loadSchema();
      return () {};
    }, []);

    if (schemas.value == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('样品创建')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
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

              await storeShowroomSample(values);
              EasyLoading.showSuccess('创建样品成功!');
              if (context.mounted) {
                Navigator.of(context).pop();
              }
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

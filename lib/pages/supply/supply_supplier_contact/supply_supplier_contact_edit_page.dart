import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/schema.dart';
import 'package:cloud/models/supply/contact.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/pages/widgets/dynamic_build_field.dart';
import 'package:cloud/services/schema.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierContactEditPage extends HookConsumerWidget {
  final int id;
  const SupplySupplierContactEditPage({super.key, @pathParam required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final schemas = useState<List<Schema>?>(null);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final supplierContact = useState<Contact?>(null);

    useEffect(() {
      loadSchema() async {
        final resp = await getSchema('supply_contacts');
        schemas.value = resp?.where((s) => s.hidden != true).toList();
      }

      loadSchema();
      return () {};
    }, []);

    useEffect(() {
      () async {
        final resp = await getSupplySupplierContact(id);
        supplierContact.value = resp;
      }();
      return null;
    }, [id]);

    if (schemas.value == null || supplierContact.value == null) {
      return const Scaffold(
        body: Center(child: MuProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('供应商联系人编辑')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            initialValue: supplierContact.value!.toJson(),
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

              await updateSupplySupplierContact(id, values);
              EasyLoading.showSuccess('编辑供应商联系人成功!');
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

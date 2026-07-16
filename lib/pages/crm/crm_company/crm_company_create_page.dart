import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/crm/crm_company/widgets/crm_company_form.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmCompanyCreatePage extends HookConsumerWidget {
  const CrmCompanyCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("新建客户"),
        backgroundColor: colorScheme.surface,
      ),
      body: CrmCompanyForm(
        initial: null,
        showUpload: true,
        onSubmit: (data) async {
          await storeCrmCompany(data);
          EasyLoading.showSuccess("创建成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

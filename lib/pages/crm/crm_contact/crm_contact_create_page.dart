import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/crm/crm_contact/widgets/crm_contact_form.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmContactCreatePage extends HookConsumerWidget {
  final int? companyId;
  const CrmContactCreatePage({super.key, this.companyId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("新建客户联系人")),
      body: CrmCotactForm(
        initial: null,
        onSubmit: (data) async {
          await storeCrmContact({...data, 'company_id': companyId});
          EasyLoading.showSuccess("创建成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

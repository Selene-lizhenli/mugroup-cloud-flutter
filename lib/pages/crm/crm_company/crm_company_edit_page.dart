import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/pages/crm/crm_company/widgets/crm_company_form.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmCompanyEditPage extends HookConsumerWidget {
  final int id;
  const CrmCompanyEditPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = useState<Company?>(null);
    final isLoading = useState(true);

    Future loadCompany() async {
      try {
        final data = await showCrmCompany(1);
        company.value = data;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadCompany();
      return null;
    }, []);

    if (isLoading.value) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (company.value == null) {
      return const Scaffold(
        body: Center(child: Text("客户不存在")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("编辑客户")),
      body: CrmCompanyForm(
        initial: company.value,
        onSubmit: (data) async {
          await updateCrmCompany(id, data);
          EasyLoading.showSuccess("保存成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/crm/company.dart';
import 'package:cloud/pages/crm/crm_company/widgets/crm_company_form.dart';
import 'package:cloud/pages/crm/crm_contact/crm_contact_page.dart';
import 'package:cloud/services/crm.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmCompanyEditPage extends HookConsumerWidget {
  final int id;
  const CrmCompanyEditPage({super.key, @pathParam required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = useState<Company?>(null);
    final isLoading = useState(true);
    final tab = useState(0);

    Future loadCompany() async {
      try {
        final data = await showCrmCompany(id);
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
      appBar: AppBar(title: const Text('客户编辑')),
      body: Column(
        children: [
          CustomSlidingSegmentedControl<int>(
            initialValue: tab.value,
            children: const {
              0: Text("基本信息"),
              1: Text("联系人信息"),
            },
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            thumbDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            onValueChanged: (v) => tab.value = v,
          ),
          Expanded(
            child: IndexedStack(
              index: tab.value,
              children: [
                /// 基本资料
                CrmCompanyForm(
                  initial: company.value,
                  onSubmit: (data) async {
                    await updateCrmCompany(id, data);
                    EasyLoading.showSuccess("保存成功");
                    if (context.mounted) {
                      Navigator.of(context).pop(true);
                    }
                  },
                ),

                CrmContactPage(companyId: id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

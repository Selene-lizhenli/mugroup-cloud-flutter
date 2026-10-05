import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/crm/contact.dart';
import 'package:cloud/pages/crm/crm_contact/widgets/crm_contact_form.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/crm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class CrmContactEditPage extends HookConsumerWidget {
  final int id;
  const CrmContactEditPage({super.key, required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = useState<Contact?>(null);
    final isLoading = useState(false);

    Future loadCotact() async {
      try {
        final data = await getCrmContact(id);
        contact.value = data;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadCotact();
      return null;
    }, []);

    if (isLoading.value) {
      return const Scaffold(
        body: Center(child: MuProgressIndicator()),
      );
    }

    if (contact.value == null) {
      return Scaffold(
        body: Skeleton(
            isLoading: true, skeleton: SkeletonListView(), child: Container()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("编辑客户联系人")),
      body: CrmCotactForm(
        initial: contact.value,
        onSubmit: (data) async {
          await updateCrmContact(id, data);
          EasyLoading.showSuccess("编辑成功");
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:cloud/l10n/l10n_extension.dart';
import 'package:cloud/models/sample/sample.dart';
import 'package:cloud/pages/showroom/widgets/showroom_sample_form.dart';
import 'package:cloud/pages/showroom/provider/showroom_sample_provider.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class ShowroomSampleEditPage extends HookConsumerWidget {
  final int id;
  const ShowroomSampleEditPage({super.key, @pathParam required this.id});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sample = useState<Sample?>(null);
    final showroomApi = ref.read(showroomSampleApiProvider);

    useEffect(() {
      () async {
        final resp = await showroomApi.getSample(id);
        sample.value = resp;
      }();
      return null;
    }, [id]);

    if (sample.value == null) {
      return const Scaffold(
        body: Center(child: MuProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: Text(l10n.showroomSampleEdit)),
      body: ShowroomSampleForm(
        initial: sample.value,
        onSubmit: (data) async {
          await updateShowroomSample(id, data);
          EasyLoading.showSuccess(l10n.showroomEditSuccess);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
          return true;
        },
      ),
    );
  }
}

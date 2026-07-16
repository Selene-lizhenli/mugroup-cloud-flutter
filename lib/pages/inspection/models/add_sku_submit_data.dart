import 'package:file_picker/file_picker.dart';

/// 添加 SKU 任务提交数据（手动 SKU 列表或上传表格）。
class AddSkuSubmitData {
  const AddSkuSubmitData._({
    required this.tabIndex,
    this.skuList,
    this.selectedFile,
    this.templateKey,
  });

  factory AddSkuSubmitData.manual(List<String> skuList) => AddSkuSubmitData._(
        tabIndex: 0,
        skuList: skuList,
      );

  factory AddSkuSubmitData.upload(
    PlatformFile selectedFile, {
    String? templateKey,
  }) =>
      AddSkuSubmitData._(
        tabIndex: 1,
        selectedFile: selectedFile,
        templateKey: templateKey,
      );

  final int tabIndex;
  final List<String>? skuList;
  final PlatformFile? selectedFile;
  final String? templateKey;
}

import 'package:cloud/app/app.dart';
import 'package:cloud/providers/app_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setting_provider.g.dart';

const _photoBackupToGalleryKey = 'photo_backup_to_gallery';
const _reportPerSkuKey = 'inspection_report_per_sku';

/// 未手动设置时，以下部门默认按 SKU 生成单个验货报告。
const _reportPerSkuDefaultDepartmentIds = {
  563,
  572,
  573,
  574,
  575,
  576,
  577,
  761,
  772,
};

bool _defaultReportPerSkuByDepartment() {
  final departmentId = authNotifier.user?.department?.id;
  if (departmentId == null) return false;
  return _reportPerSkuDefaultDepartmentIds.contains(departmentId);
}

/// 优先取本地设置；本地未设置时按用户部门 id 推断默认值。
bool resolveReportPerSku() {
  final prefs = app.prefs.getBool(_reportPerSkuKey);
  if (prefs != null) {
    return app.prefs.getBool(_reportPerSkuKey)!;
  }
  return _defaultReportPerSkuByDepartment();
}

/// 应用本地设置，后续新项在此扩展字段即可。
class AppSettings {
  const AppSettings({
    this.photoBackupToGallery = true,
  });

  /// 拍摄图片是否备份至手机相册。
  final bool photoBackupToGallery;

  /// 下载验货报告时，是否为每个 SKU 单独生成一份报告（否则多 SKU 合并为 zip）。
  bool get reportPerSku => resolveReportPerSku();

  AppSettings copyWith({bool? photoBackupToGallery}) {
    return AppSettings(
      photoBackupToGallery: photoBackupToGallery ?? this.photoBackupToGallery,
    );
  }

  static AppSettings load() {
    return AppSettings(
      photoBackupToGallery: app.prefs.getBool(_photoBackupToGalleryKey) ?? true,
    );
  }
}

@Riverpod(keepAlive: true)
class Setting extends _$Setting {
  @override
  AppSettings build() => AppSettings.load();

  void setPhotoBackupToGallery(bool enabled) {
    state = state.copyWith(photoBackupToGallery: enabled);
    app.prefs.setBool(_photoBackupToGalleryKey, enabled);
  }

  void setReportPerSku(bool enabled) {
    app.prefs.setBool(_reportPerSkuKey, enabled);
    state = AppSettings(
      photoBackupToGallery: state.photoBackupToGallery,
    );
  }
}

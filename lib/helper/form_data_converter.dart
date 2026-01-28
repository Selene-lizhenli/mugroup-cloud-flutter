import 'package:cloud/models/company_card_data.dart';

/// 智能识别命名后，智能识别的数据格式与表单格式拉齐
/// 将 CompanyCardData 对象转换为扁平化的 Map 格式，适用于 FormBuilder
Map<String, dynamic> convertCompanyCardDataToFormValues(CompanyCardData data) {
  final Map<String, dynamic> formValues = {
    'name': data.name,
    'address': data.address,
    'location': data.location,
    'industry': data.industry,
    'domain': data.domain,
    'email': data.email,
    'linkedin': data.linkedin,
    'whatsapp': data.whatsapp,
    'facebook': data.facebook,
  };

  if (data.contact != null) {
    final contact =  data.contact!;
    formValues['contact_name'] = contact.name;
    formValues['contact_phone'] = contact.phone;
    formValues['contact_mobile'] = contact.mobile;
    formValues['contact_position'] = contact.position;
  }
  return formValues;
}

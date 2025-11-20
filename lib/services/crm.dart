import 'package:cloud/http/api.dart';
import 'package:cloud/models/crm/company.dart';

Future<Company?> storeCrmCompany(Map<String, dynamic>? data) async {
  return api.post("api/tenant/crm/companies", data: data).then(
    (res) {
      if (res.data == null) {
        return null;
      }
      return Company.fromJson(res.data);
    },
  );
}

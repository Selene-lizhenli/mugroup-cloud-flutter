import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/supply/supplier.dart';
import 'package:cloud/pages/widgets/circular_progress_indicator.dart';
import 'package:cloud/services/supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SupplySupplierDetailInfoPage extends HookConsumerWidget {
  final int id;

  const SupplySupplierDetailInfoPage({
    super.key,
    @PathParam.inherit('id') required this.id,
  });

  bool _isValueEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) {
      return value.trim().isEmpty || value.toLowerCase() == 'null';
    }
    if (value is List) return value.isEmpty;
    return false;
  }

  /// 格式化显示文字
  String _formatValue(dynamic value, {String fallback = "暂无"}) {
    if (_isValueEmpty(value)) return fallback;
    if (value is List) return value.join(", ");
    return value.toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplier = useState<Supplier?>(null);
    final isLoading = useState(true);

    Future<void> loadSupplier() async {
      try {
        final resp = await getSupplier(id);
        supplier.value = resp;
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadSupplier();
      return null;
    }, []);

    if (isLoading.value) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: MuProgressIndicator()),
      );
    }

    final data = supplier.value;
    if (data == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(
            child: Text("未找到供应商数据", style: TextStyle(color: Colors.grey))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderCard(data),
            const SizedBox(height: 16),
            buildSectionCard(
              title: "基础信息",
              children: [
                buildIconInfoRow(
                    Icons.vpn_key_outlined, "供应商编号", data.supplierNo),
                buildIconInfoRow(
                    Icons.shop_outlined, "店铺档口信息", data.stallAddress),
                buildIconInfoRow(Icons.location_on_outlined, "地址", data.address),
              ],
            ),
            const SizedBox(height: 16),
            buildSectionCard(
              title: "经营能力与市场",
              children: [
                buildIconInfoRow(
                    Icons.category_outlined, "主营范围", data.businessScope),
                buildIconInfoRow(
                    Icons.trending_up_outlined, "累计出货总额", data.shippingAmount,
                    isMoney: true),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderCard(Supplier data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatValue(data.name, fallback: "未知供应商"),
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2129)),
          ),
          if (!_isValueEmpty(data.shortName)) ...[
            const SizedBox(height: 6),
            Text(
              data.shortName!,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              buildTag(
                data.isCore == true ? '核心供应商' : '普通供应商',
                data.isCore == true ? Colors.red : Colors.orange,
              ),
              if (data.canBill != null)
                buildTag(
                  data.canBill! ? '可开票' : '不可开票',
                  data.canBill! ? Colors.green : Colors.grey,
                ),
              if (!_isValueEmpty(data.province))
                buildTag('${data.province} ${data.city ?? ""}', Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSectionCard(
      {required String title, required List<Widget> children}) {
    final validChildren = children.where((w) => w is! SizedBox).toList();
    if (validChildren.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 4),
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2129)),
            ),
          ),
          ...validChildren,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget buildIconInfoRow(IconData icon, String label, dynamic value,
      {bool isMoney = false}) {
    if (_isValueEmpty(value)) return const SizedBox.shrink();

    final String text = _formatValue(value);

    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        EasyLoading.showToast("已复制: $label");
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 18, color: const Color(0xFF86909C)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF86909C))),
                  const SizedBox(height: 4),
                  Text(
                    isMoney ? '¥$text' : text,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1D2129),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 14),
              child:
                  Icon(Icons.copy_rounded, size: 14, color: Color(0xFFC9CDD4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTag(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.shade100),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12, color: color.shade700, fontWeight: FontWeight.w500),
      ),
    );
  }
}

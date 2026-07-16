import 'package:cloud/models/sample/category.dart';
import 'package:cloud/services/sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CategorySelect extends HookWidget {
  final String? label;
  final int? value;
  final ValueChanged<int?>? onChanged;

  const CategorySelect({
    super.key,
    this.label,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = useState<List<Category>>([]);
    final loading = useState(false);
    final fetched = useState(false);

    /// 初始化加载数据
    useEffect(() {
      () async {
        if (fetched.value) return;
        fetched.value = true;

        loading.value = true;
        final resp = await getAllShowroomCategories();
        categories.value = resp ?? [];
        loading.value = false;
      }();
      return null;
    }, []);

    /// 输入框触发节点
    Widget trigger = InkWell(
      onTap: () async {
        if (loading.value) return;

        final selectedId = await CategorySelectPopup.show(
          context,
          all: categories.value,
          selectedId: value,
        );

        if (selectedId != null) {
          onChanged?.call(selectedId);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value != null ? _pathOf(categories.value, value!) : "请选择分类",
                style: TextStyle(
                  fontSize: 15,
                  color: value == null ? Colors.grey : const Color(0xFF0F172A),
                ),
              ),
            ),
            const Icon(Icons.expand_more, color: Colors.grey),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              label!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
            ),
          ),
        trigger,
      ],
    );
  }

  String _pathOf(List<Category> all, int id) {
    final cat = all.firstWhere((c) => c.id == id,
        orElse: () => Category(id: id, name: "未命名"));
    return [...(cat.ancestors ?? []), cat]
        .map((e) => e.name ?? "")
        .where((e) => e.isNotEmpty)
        .join(" / ");
  }
}

class CategorySelectPopup extends HookWidget {
  final List<Category> all;
  final int? selectedId; // 只记录选中 id

  const CategorySelectPopup({
    super.key,
    required this.all,
    this.selectedId,
  });

  static Future<int?> show(
    BuildContext context, {
    required List<Category> all,
    int? selectedId,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width, // 底部抽屉宽度占满屏幕
      ),
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.85,
        child: CategorySelectPopup(
          all: all,
          selectedId: selectedId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyword = useState("");
    final scroll = useScrollController();

    /// 过滤
    List<Category> filtered = useMemoized(() {
      if (keyword.value.isEmpty) return all;

      return all.where((cat) {
        final path = _pathOf(cat).toLowerCase();
        return path.contains(keyword.value.toLowerCase());
      }).toList();
    }, [keyword.value, all]);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          _buildSearch(keyword),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text("无匹配结果", style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    controller: scroll,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final c = filtered[i];
                      return InkWell(
                        onTap: () => Navigator.pop(context, c.id), // 返回 id
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _pathOf(c),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                              if (selectedId == c.id)
                                const Icon(Icons.check, color: Colors.blue),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "选择产品分类",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(ValueNotifier<String> keyword) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "搜索分类",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (v) => keyword.value = v,
      ),
    );
  }

  String _pathOf(Category c) {
    return [...(c.ancestors ?? []), c]
        .map((e) => e.name ?? "")
        .where((x) => x.isNotEmpty)
        .join(" / ");
  }
}

import 'package:cloud/helper/helper.dart';
import 'package:cloud/models/sample/category.dart';
import 'package:cloud/services/sample.dart';
import 'package:cloud/services/wms.dart';
import 'package:cloud/pages/dashboard/widgets/showroom/chart_contet.dart';
import 'package:cloud/pages/dashboard/provider/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 统计结果：一级目录信息 + 该一级目录下累计数量
/// 需要在其他文件中使用，所以保持 public
class Level1CategoryStat {
  final int id;
  final String name;
  final int totalProductsCount;
  final Color color;

  Level1CategoryStat({
    required this.id,
    required this.name,
    required this.totalProductsCount,
    required this.color,
  });

  @override
  String toString() =>
      'Level1CategoryStat(id: $id, name: $name, total: $totalProductsCount)';
}

/// 样品间模块 - 圆饼图
class SampleRoomChart extends ConsumerStatefulWidget {
  final String moduleTitle; // 模块标题，如"样品间"

  const SampleRoomChart({
    super.key,
    this.moduleTitle = '样品间', // 默认值
  });

  @override
  ConsumerState<SampleRoomChart> createState() => _SampleRoomChartState();
}

class _SampleRoomChartState extends ConsumerState<SampleRoomChart> {
  List<Level1CategoryStat> _dimensionData = []; // 维度数据（从API获取）
  bool _isLoading = false; // 数据加载状态

  // 颜色列表，用于分配颜色
  static const List<Color> _colorPalette = [
    Color(0xFF4A90E2), // 蓝色
    Color(0xFF2E7D32), // 深绿色
    Color.fromARGB(255, 15, 76, 125), // 浅蓝色
    Color(0xFFFF9800), // 橙色
    Color(0xFFFFC107), // 黄色
    Color.fromARGB(255, 195, 89, 213), // 紫色
    Color.fromARGB(255, 160, 70, 109), //玫粉色
    Color(0xFF00BCD4), // 青色
  ];

  String? _lastLoadedDimension;

  @override
  void initState() {
    super.initState();
    // 初始化时强制将维度设置为「样品间」，并根据该维度加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const defaultDimension = '样品间';
      ref.read(dashboardStatsProvider.notifier).setSampleRoomDimension(defaultDimension);
      _lastLoadedDimension = defaultDimension;
      _loadDimensionData(defaultDimension);
    });
  }

 
  /// 将扁平 categories 归并到一级目录并统计每个一级目录下包含的总 productsCount 
  List<Level1CategoryStat> buildLevel1Stats(
    List<Category> categories, {
    int rootId = 1,
    bool includeRoot = false, // 是否把 Root 也当成一级目录输出
  }) {
    // 先建立 id -> Category 的索引，方便必要时补全名称（如果 ancestors 里只带了 id/name 也行）
    final byId = <int, Category>{};
    for (final c in categories) {
      byId[c.id] = c;
    }

    // 一级目录 id -> 累加的 productsCount
    final totals = <int, int>{};
    // 一级目录 id -> name（用于输出）
    final names = <int, String>{};

    int safeCount(Category c) => c.productsCount ?? 0;

    for (final c in categories) {
      // 可选：跳过 Root 自己
      if (!includeRoot && c.id == rootId) continue;

      final ancestors = c.ancestors ?? const [];

      // 情况 A：它就是一级目录（Root 的直接子类）
      // 1) parentId == rootId
      // 2) 或者 ancestors 只有 Root
      final isDirectChildOfRoot = (c.parentId == rootId) ||
          (ancestors.length == 1 && ancestors.first.id == rootId);

      final int level1Id;
      final String? level1Name;

      if (isDirectChildOfRoot) {
        level1Id = c.id;
        level1Name = c.name;
      } else {
        // 情况 B：更深层：找 ancestors 中 Root 后面的第一个节点
        // 例如 ancestors: [Root, Kitchen & Dining, Pots & Pans 的父...]
        // 那一级目录就是 Kitchen & Dining（index 1）
        final rootIndex = ancestors.indexWhere((a) => a.id == rootId);
        if (rootIndex != -1 && ancestors.length > rootIndex + 1) {
          final level1 = ancestors[rootIndex + 1];
          level1Id = level1.id;
          level1Name = level1.name;
        } else {
          // 实在找不到归属（数据不完整），就跳过或你也可以归到 Root
          continue;
        }
      }

      // 记录 name（如果 ancestors 里 name 为空，尝试从 byId 取）
      names[level1Id] = level1Name ?? byId[level1Id]?.name ?? 'Unknown($level1Id)';
      totals[level1Id] = (totals[level1Id] ?? 0) + safeCount(c);
    }

    // 输出 list
    final result = <Level1CategoryStat>[];
    totals.forEach((id, total) {
      result.add(Level1CategoryStat(
        id: id,
        name: names[id] ?? 'Unknown($id)',
        totalProductsCount: total,
        color: _colorPalette[id % _colorPalette.length],
      ));
    });
 
    // 按数量降序（你也可以按名称/ID 排序）
    result.sort((a, b) => b.totalProductsCount.compareTo(a.totalProductsCount));
    return result;
  }

  /// 根据维度加载数据
  Future<void> _loadDimensionData(String dimension) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (dimension == '产品目录') {
        // 加载产品目录数据（使用包含 count 的方法）
        final categoriesData = await getAllShowroomCategories();
        
        logger.d('categoriesData: $categoriesData');
        if (mounted) {
          setState(() {
            _isLoading = false;
            if (categoriesData != null && categoriesData.isNotEmpty) {
              _dimensionData = buildLevel1Stats(categoriesData, rootId: 1);
            } else {
              _dimensionData = [];
            }
          });
        }
      } else if (dimension == '样品间') {
        // 加载样品间数据
        final resp = await getWarehouses(); 
        if (mounted) {
          setState(() {
            _isLoading = false;
            final warehouses = resp.data;
            if (warehouses.isNotEmpty) {
              // 过滤掉 abandoned == true 的仓库
              final activeWarehouses = warehouses
                  .where((warehouse) => warehouse.abandoned != true)
                  .toList();
              
              _dimensionData = activeWarehouses.asMap().entries.map((entry) {
                final index = entry.key;
                final warehouse = entry.value;
                return Level1CategoryStat(
                  id: warehouse.id ?? index,
                  name: warehouse.name ?? '未命名样品间',
                  totalProductsCount: warehouse.sampleCount ?? 0,
                  color: _colorPalette[index % _colorPalette.length],
                );
              }).toList();
          
            } else {
              _dimensionData = [];
            }
          });
        }
      } else {
        // 未知维度，设置为空数据
        if (mounted) {
          setState(() {
            _isLoading = false;
            _dimensionData = [];
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _dimensionData = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听维度变化并重新加载数据
    ref.listen<String>(
      dashboardStatsProvider.select((state) => state.sampleRoomDimension),
      (previous, next) {
        if (previous != next && next != _lastLoadedDimension) {
          _lastLoadedDimension = next;
          _loadDimensionData(next);
        }
      },
    );

    // 使用从API获取的维度数据
    final sampleRoomData = _dimensionData;

    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.none, // 使用 ClipRect 在内部裁剪
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          // 根据数据状态显示内容
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (sampleRoomData.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  '暂无数据',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ),
            )
          else if (sampleRoomData.isNotEmpty)
            ChartContent(sampleRoomData: sampleRoomData),
        ],
      ),
    );
  }

}

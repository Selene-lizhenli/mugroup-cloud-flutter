import 'package:cloud/services/sample.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 样品间模块 - 圆饼图
class SampleRoomChart extends StatefulWidget {
  final String moduleTitle; // 模块标题，如"样品间"

  const SampleRoomChart({
    super.key,
    this.moduleTitle = '样品间', // 默认值
  });

  @override
  State<SampleRoomChart> createState() => _SampleRoomChartState();
}

class _SampleRoomChartState extends State<SampleRoomChart> {
  String _selectedDimension = '样品间'; // 当前选中的维度（用于后续扩展不同维度的数据展示）
  List<_SampleRoomItem> _productCatalogData = []; // 产品目录数据（从API获取）
  bool _isLoadingProductCatalog = false; // 产品目录数据加载状态
  int? _touchedIndex; // 当前点击的扇形索引

  // 颜色列表，用于分配颜色
  static const List<Color> _colorPalette = [
    Color(0xFF4A90E2), // 蓝色
    Color(0xFF2E7D32), // 深绿色
    Color(0xFF2196F3), // 浅蓝色
    Color(0xFFFF9800), // 橙色
    Color(0xFFFFC107), // 黄色
    Color(0xFF9C27B0), // 紫色
    Color(0xFFE91E63), // 粉色
    Color(0xFF00BCD4), // 青色
  ];

  @override
  void initState() {
    super.initState();
    // 初始化时如果是产品目录，加载数据
    if (_selectedDimension == '产品目录') {
      _loadProductCatalogData();
    }
  }

  /// 加载产品目录数据
  Future<void> _loadProductCatalogData() async {
    setState(() {
      _isLoadingProductCatalog = true;
    });

    try {
      final data = await getShowroomSampleTradeCountryStats();
      if (mounted) {
        setState(() {
          _isLoadingProductCatalog = false;
          if (data != null) {
            _productCatalogData = data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _SampleRoomItem(
                name: item.name,
                count: item.count,
                color: _colorPalette[index % _colorPalette.length],
              );
            }).toList();
          } else {
            _productCatalogData = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProductCatalog = false;
          _productCatalogData = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 根据选中的维度获取数据
    List<_SampleRoomItem> sampleRoomData;
    if (_selectedDimension == '产品目录') {
      // 使用从API获取的产品目录数据
      sampleRoomData = _productCatalogData;
    } else {
      // 使用默认的样品间数据
      sampleRoomData = [
        _SampleRoomItem(
          name: '义乌凯越大原样品间',
          count: 172462,
          color: const Color(0xFF4A90E2), // 蓝色
        ),
        _SampleRoomItem(
          name: '宏基大厦样品间',
          count: 45000,
          color: const Color(0xFF2E7D32), // 深绿色
        ),
        _SampleRoomItem(
          name: '宁波凯越大原样品间',
          count: 38000,
          color: const Color(0xFF2196F3), // 浅蓝色
        ),
        _SampleRoomItem(
          name: '澄海样品间',
          count: 25000,
          color: const Color(0xFFFF9800), // 橙色
        ),
        _SampleRoomItem(
          name: '其他样品间',
          count: 15000,
          color: const Color(0xFFFFC107), // 黄色
        ),
      ];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.none, // 允许内容超出padding边界
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // 根据数据状态显示内容
          if (_selectedDimension == '产品目录' && _isLoadingProductCatalog)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_selectedDimension == '产品目录' && sampleRoomData.isEmpty)
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
            _buildChartContent(sampleRoomData),
        ],
      ),
    );
  }

  /// 构建图表内容
  Widget _buildChartContent(List<_SampleRoomItem> sampleRoomData) {
    final total = sampleRoomData.fold<int>(0, (sum, item) => sum + item.count);
    final maxItem = sampleRoomData.reduce(
      (a, b) => a.count > b.count ? a : b,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 上方图例
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: sampleRoomData.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                      ),
                ),
              ],
            );
          }).toList(),
        ),
       
        // 下方圆饼图 - 增加容器尺寸以容纳badge
        Center(
          child: SizedBox(
            height: 260, // 从200增加到260，为badge留出空间
            width: 260, // 从200增加到260，为badge留出空间
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none, // 允许内容超出边界，避免裁剪
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    sections: sampleRoomData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isMaxItem = item.name == maxItem.name;
                      final isTouched = _touchedIndex == index;
                      return PieChartSectionData(
                        value: item.count.toDouble(),
                        title: '',
                        color: item.color,
                        radius: isTouched
                            ? 75 // 点击时稍微放大
                            : (isMaxItem ? 70 : 60),
                        badgeWidget: isMaxItem && _touchedIndex == null
                            ? _buildBadge(item, total)
                            : null,
                        badgePositionPercentageOffset: 1.3,
                      );
                    }).toList(),
                    pieTouchData: PieTouchData(
                      touchCallback: (PieTouchResponse? touchResponse) {
                        setState(() {
                          if (touchResponse == null ||
                              touchResponse.touchedSection == null) {
                            _touchedIndex = null;
                            return;
                          }
                          _touchedIndex = touchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 底部显示选中的数据信息
        // if (_touchedIndex != null && _touchedIndex! < sampleRoomData.length) ...[
        //   const SizedBox(height: 20),
        //   _buildSelectedInfo(sampleRoomData[_touchedIndex!], total),
        // ],
      ],
    );
  }

  /// 格式化数字（添加千分位）
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// 构建底部选中的信息显示
  Widget _buildSelectedInfo(_SampleRoomItem item, int total) {
    final percentage = (item.count / total * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 颜色指示器
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              // 名称
              Text(
                item.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
              ),
            ],
          ),
          // 数量和百分比
          Row(
            children: [
              Text(
                '共计${_formatNumber(item.count)}条',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(width: 16),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: item.color,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建标签（显示最大项的详细信息）
  Widget _buildBadge(_SampleRoomItem item, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '共计${_formatNumber(item.count)}条',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 样品间数据项
class _SampleRoomItem {
  final String name;
  final int count;
  final Color color;

  _SampleRoomItem({
    required this.name,
    required this.count,
    required this.color,
  });
}

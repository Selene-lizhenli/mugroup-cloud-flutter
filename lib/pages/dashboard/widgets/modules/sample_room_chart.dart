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
  int? _selectedIndex; // 当前选中的扇区索引

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
    
    // 如果当前选中的索引无效，重置为 null
    if (_selectedIndex != null && 
        (_selectedIndex! < 0 || _selectedIndex! >= sampleRoomData.length)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = null;
          });
        }
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.none, // 使用 ClipRect 在内部裁剪
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
    // 计算总数量
    final totalCount = sampleRoomData.fold<int>(0, (sum, item) => sum + item.count);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 上方图例
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: sampleRoomData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  // 确保索引有效
                  if (isSelected) {
                    _selectedIndex = null;
                  } else if (index >= 0 && index < sampleRoomData.length) {
                    _selectedIndex = index;
                  }
                });
              },
              child: Row(
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
                          color: isSelected
                              ? item.color
                              : Colors.grey.shade700,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // 圆饼图
        SizedBox(
          height: 250,
          width: double.infinity,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (pieTouchResponse) {
                  if (pieTouchResponse.touchedSection == null) {
                    setState(() {
                      _selectedIndex = null;
                    });
                    return;
                  }
                  final touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  // 确保索引在有效范围内
                  if (touchedIndex >= 0 && touchedIndex < sampleRoomData.length) {
                    setState(() {
                      _selectedIndex = touchedIndex;
                    });
                  } else {
                    setState(() {
                      _selectedIndex = null;
                    });
                  }
                },
              ),
              sectionsSpace: 2, // 扇区之间的间隔
              centerSpaceRadius: 40, // 中心空白半径
              sections: sampleRoomData.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final percentage = totalCount > 0
                    ? (item.count / totalCount * 100).toStringAsFixed(1)
                    : '0.0';
                final isSelected = _selectedIndex == index;
                
                return PieChartSectionData(
                  value: item.count.toDouble(),
                  color: item.color,
                  title: '${percentage}%',
                  radius: isSelected ? 60 : 50, // 选中时突出显示
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // 下方显示当前选中数据
        if (_selectedIndex != null && 
            _selectedIndex! >= 0 && 
            _selectedIndex! < sampleRoomData.length)
          Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: sampleRoomData[_selectedIndex!].color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${sampleRoomData[_selectedIndex!].name}：',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  _formatNumber(sampleRoomData[_selectedIndex!].count),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${((sampleRoomData[_selectedIndex!].count / totalCount) * 100).toStringAsFixed(1)}%)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
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

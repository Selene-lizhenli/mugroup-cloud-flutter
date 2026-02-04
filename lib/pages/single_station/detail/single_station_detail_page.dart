import 'package:auto_route/auto_route.dart';
import 'package:cloud/models/sample/quotation_sample.dart';
import 'package:cloud/models/single_station/single_station_item.dart';
import 'package:cloud/services/single_station.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SingleStationDetailPage extends StatefulWidget {
  const SingleStationDetailPage({
    super.key,
    required this.item,
  });

  final SingleStationItem? item;

  @override
  State<SingleStationDetailPage> createState() => _SingleStationDetailPageState();
}

class _SingleStationDetailPageState extends State<SingleStationDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text(item?.nameCn ?? item?.nameEn ?? '独立站详情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.router.maybePop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '基本信息'),
            Tab(text: '样品明细'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BasicInfoTab(item: item),
          _StationSamplesTab(stationItem: item, colorScheme: colorScheme),
        ],
      ),
    );
  }
}

class _BasicInfoTab extends StatelessWidget {
  const _BasicInfoTab({required this.item});

  final SingleStationItem? item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (item == null) {
      return Center(
        child: Text(
          '缺少站点信息',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    Widget row(String label, String? value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Text(
                (value == null || value.isEmpty) ? '—' : value,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      children: [
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                row('名称', item!.nameCn ?? item!.nameEn),
                row('主题', item!.theme),
                row('有效期', item!.expireTime),
                row('联系人', item!.contactPerson),
                row('邮箱', item!.email),
                row('地址', item!.address),
                row('站点链接', item!.stationUrl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StationSamplesTab extends StatefulWidget {
  const _StationSamplesTab({
    required this.stationItem,
    required this.colorScheme,
  });

  final SingleStationItem? stationItem;
  final ColorScheme colorScheme;

  @override
  State<_StationSamplesTab> createState() => _StationSamplesTabState();
}

class _StationSamplesTabState extends State<_StationSamplesTab> {
  late Future<List<QuotationSample>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<QuotationSample>> _load() async {
    final stationId = widget.stationItem?.id;
    if (stationId == null) return [];

    final resp = await getStationSamplesList({
      // 约定：后端常用 station_id；如需调整参数名可在此修改
      'station_id': stationId,
      'page': 1,
      'pageSize': 20,
    });
    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stationItem?.id == null) {
      return Center(
        child: Text(
          '缺少站点ID，无法加载样品明细',
          style: TextStyle(color: widget.colorScheme.onSurfaceVariant),
        ),
      );
    }

    return FutureBuilder<List<QuotationSample>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              '加载失败：${snapshot.error}',
              style: TextStyle(color: widget.colorScheme.error),
              textAlign: TextAlign.center,
            ),
          );
        }

        final list = snapshot.data ?? const [];
        if (list.isEmpty) {
          return Center(
            child: Text(
              '暂无样品明细',
              style: TextStyle(color: widget.colorScheme.onSurfaceVariant),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final s = list[index];
            final name = s.showroomSample?.nameCn ??
                s.showroomSample?.nameEn ??
                s.customerProductNo ??
                '—';
            return ListTile(
              tileColor:
                  widget.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(name),
              subtitle: Text(
                '数量: ${s.qty ?? '-'}   价格: ${s.price ?? '-'}',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

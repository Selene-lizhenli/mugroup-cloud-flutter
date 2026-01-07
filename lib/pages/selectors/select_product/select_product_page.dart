import 'package:auto_route/auto_route.dart';
import 'package:cloud/pages/quote/batch_import/widgets/product_list_sheet.dart';
import 'package:flutter/material.dart';

// TODO 待优化
@RoutePage()
class SelectProductPage extends StatelessWidget {
  const SelectProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProductListSheet(),
    );
  }
}


import 'package:flutter/material.dart';

class CustomEmptyContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Container());
  }
}

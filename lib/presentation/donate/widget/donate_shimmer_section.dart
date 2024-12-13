import 'package:expense_app/presentation/donate/donate_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DonateShimmerSection extends StatelessWidget {
  final DonateViewModel viewModel;

  DonateShimmerSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.primary,
            highlightColor: Theme.of(context).highlightColor,
            child: Card());
      }, childCount: 4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ReportShimmerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.primary,
          highlightColor: Theme.of(context).highlightColor,
          child: Container(
            height: Get.height * .03,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 6),
      itemCount: 30,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(top: 12),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.primary,
                    highlightColor: Theme.of(context).highlightColor,
                    child: Container(
                      width: Get.width * .3,
                      height: Get.height * .02,
                      color: Colors.white,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.primary,
                  highlightColor: Theme.of(context).highlightColor,
                  child: Container(
                    width: Get.width * .6,
                    height: Get.height * .02,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(12),
          sliver: SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.primary,
              highlightColor: Theme.of(context).highlightColor,
              child: Container(
                height: Get.height * .2,
                decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * .2),
          sliver: SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.primary,
              highlightColor: Theme.of(context).highlightColor,
              child: Container(
                height: Get.height * .02,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(12),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.primary,
                  highlightColor: Theme.of(context).highlightColor,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    width: double.infinity,
                    height: Get.height * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                );
              },
              childCount: 10,
            ),
          ),
        ),
      ],
    );
  }
}

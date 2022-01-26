import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';

class ShimmerHelper {
  buildBasicShimmer(
      {double height = double.infinity, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: MyTheme.shimmer_base,
      highlightColor: MyTheme.shimmer_highlighted,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  Widget buildListShimmer(
      {item_count = 10, item_height = 100.0, bool sliverItem = false}) {
    if (sliverItem) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, left: 16.0, right: 16.0, bottom: 16.0),
              child: ShimmerHelper().buildBasicShimmer(height: item_height),
            );
          },
        ),
      );
    } else {
      return ListView.builder(
        itemCount: item_count,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: ShimmerHelper().buildBasicShimmer(height: item_height),
          );
        },
      );
    }
  }

  Widget buildProductGridShimmer(
      {scontroller, item_count = 10, bool sliverItem = false}) {
    if (sliverItem) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.618,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Shimmer.fromColors(
              baseColor: MyTheme.shimmer_base,
              highlightColor: MyTheme.shimmer_highlighted,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            );
          },
          childCount: item_count,
        ),
      );
    } else {
      return GridView.builder(
        itemCount: item_count,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: MyTheme.shimmer_base,
              highlightColor: MyTheme.shimmer_highlighted,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  buildSquareGridShimmer({scontroller, item_count = 10}) {
    return GridView.builder(
      itemCount: item_count,
      controller: scontroller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1),
      padding: EdgeInsets.all(8),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: MyTheme.shimmer_base,
            highlightColor: MyTheme.shimmer_highlighted,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        );
      },
    );
  }
}

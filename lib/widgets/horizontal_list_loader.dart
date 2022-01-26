import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:flutter/material.dart';

class HorizontalListLoader extends StatelessWidget {
  final bool sliverItem;
  const HorizontalListLoader({
    Key key,
    this.sliverItem = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return sliverItem
        ? SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: _size.height * 0.02,
                horizontal: _size.width * 0.05,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ShimmerHelper().buildBasicShimmer(
                        height: 80.0,
                        // width: (MediaQuery.of(context).size.width - 32) / 3,
                      ),
                    ),
                  ),
                  SizedBox.square(
                    dimension: _size.width * 0.05,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ShimmerHelper().buildBasicShimmer(
                        height: 80.0,
                        // width: (MediaQuery.of(context).size.width - 32) / 3,
                      ),
                    ),
                  ),
                  SizedBox.square(
                    dimension: _size.width * 0.05,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: ShimmerHelper().buildBasicShimmer(
                        height: 80.0,
                        // width: (MediaQuery.of(context).size.width - 32) / 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
              vertical: _size.height * 0.02,
              horizontal: _size.width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: ShimmerHelper().buildBasicShimmer(
                      height: 80.0,
                      // width: (MediaQuery.of(context).size.width - 32) / 3,
                    ),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * 0.05,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: ShimmerHelper().buildBasicShimmer(
                      height: 80.0,
                      // width: (MediaQuery.of(context).size.width - 32) / 3,
                    ),
                  ),
                ),
                SizedBox.square(
                  dimension: _size.width * 0.05,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: ShimmerHelper().buildBasicShimmer(
                      height: 80.0,
                      // width: (MediaQuery.of(context).size.width - 32) / 3,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

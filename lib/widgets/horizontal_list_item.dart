import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/widgets/components/brand_card.dart';
import 'package:active_ecommerce_flutter/widgets/components/category_card.dart';
import 'package:active_ecommerce_flutter/widgets/components/product_card.dart';
import 'package:flutter/material.dart';

class HorizontalListItems extends StatelessWidget {
  final List<Category> categoryItems;
  final List<Product> productItems;
  final List<Brand> brandItems;
  final ShapeBorder brandCardShape;
  final bool sliverItem;
  final ValueChanged onPressed;
  const HorizontalListItems({
    Key key,
    this.categoryItems,
    this.productItems,
    this.brandItems,
    this.brandCardShape,
    this.sliverItem = true,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return sliverItem
        ? SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: _size.width * 0.04,
            ),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: productItems != null
                    ? _size.height * 0.25
                    : categoryItems != null
                        ? 150
                        : 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  cacheExtent: 120,
                  itemCount: categoryItems?.length ??
                      productItems?.length ??
                      brandItems?.length ??
                      0,
                  separatorBuilder: (__, _) => SizedBox(
                    width: _size.width * 0.02,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (categoryItems != null) {
                      return CategoryCard(
                        category: categoryItems[index],
                        onPressed: (Category value) => onPressed(value),
                        imageFlex:
                            (categoryItems[index].name ?? '').contains('(')
                                ? 5
                                : 4,
                        textFlex:
                            (categoryItems[index].name ?? '').contains('(')
                                ? 2
                                : 1,
                      );
                    } else if (productItems != null) {
                      return ProductCard(
                        product: productItems[index],
                        onPressed: (Product value) => onPressed(value),
                      );
                    } else if (brandItems != null) {
                      return BrandCard(
                        brand: brandItems[index],
                        cardShape: brandCardShape,
                        imageFlex: (brandItems[index].name ?? '').contains('(')
                            ? 5
                            : 4,
                        textFlex: (brandItems[index].name ?? '').contains('(')
                            ? 2
                            : 1,
                        onPressed: (Brand value) => onPressed(value),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          )
        : SizedBox(
            height: productItems != null ? _size.height * 0.25 : 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              cacheExtent: 120,
              itemCount: categoryItems?.length ?? productItems?.length ?? 0,
              separatorBuilder: (__, _) => SizedBox(
                width: _size.width * 0.02,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (categoryItems != null) {
                  return CategoryCard(
                    category: categoryItems[index],
                    onPressed: (Category value) => onPressed(value),
                    imageFlex:
                        (categoryItems[index].name ?? '').contains('(') ? 5 : 4,
                    textFlex:
                        (categoryItems[index].name ?? '').contains('(') ? 2 : 1,
                  );
                } else if (productItems != null) {
                  return ProductCard(
                    product: productItems[index],
                    onPressed: (Product value) => onPressed(value),
                  );
                } else if (brandItems != null) {
                  return BrandCard(
                    brand: brandItems[index],
                    cardShape: brandCardShape,
                    imageFlex:
                        (brandItems[index].name ?? '').contains('(') ? 5 : 4,
                    textFlex:
                        (brandItems[index].name ?? '').contains('(') ? 2 : 1,
                    onPressed: (Brand value) => onPressed(value),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          );
  }
}

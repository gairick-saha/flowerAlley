import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/widgets/components/brand_card.dart';
import 'package:active_ecommerce_flutter/widgets/components/category_card.dart';
import 'package:active_ecommerce_flutter/widgets/components/product_card.dart';
import 'package:flutter/widgets.dart';

class GridListItems {
  final List<Category> categoryItems;
  final List<Product> productItems;
  final List<Brand> brandItems;
  final ValueChanged onPressed;

  const GridListItems({
    this.categoryItems = const [],
    this.productItems = const [],
    this.brandItems = const [],
    @required this.onPressed,
  });

  SliverChildBuilderDelegate buildCategory() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return CategoryCard(
          category: categoryItems[index],
          onPressed: onPressed,
        );
      },
      childCount: categoryItems.length,
    );
  }

  SliverChildBuilderDelegate buildProduct() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return ProductCard(
          product: productItems[index],
          onPressed: onPressed,
        );
      },
      childCount: productItems.length,
    );
  }

  SliverChildBuilderDelegate buildBrand() {
    return SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return BrandCard(
          brand: brandItems[index],
          onPressed: onPressed,
          imageFlex: 4,
          textFlex: 1,
        );
      },
      childCount: brandItems.length,
    );
  }
}

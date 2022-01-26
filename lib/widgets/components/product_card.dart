import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onPressed;

  const ProductCard({
    Key key,
    @required this.product,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onPressed(product),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).disabledColor.withOpacity(0.3),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: double.maxFinite,
          width: _size.width * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                // flex: product.has_discount &&
                //         product.stroked_price != null &&
                //         (product.stroked_price ?? '').isNotEmpty
                //     ? 10
                //     : 8,
                flex: 9,
                child: SizedBox(
                  width: double.maxFinite,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                      bottom: Radius.zero,
                    ),
                    child: Hero(
                      tag: 'productImage${product.id}',
                      child: product.thumbnail_image != null &&
                              (product.thumbnail_image ?? '').isEmpty
                          ? FadeInImage(
                              placeholder:
                                  AssetImage('assets/placeholder.jpeg'),
                              image: AssetImage('assets/placeholder.jpeg'),
                              fit: BoxFit.fill,
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.jpeg',
                              image: AppConfig.BASE_PATH +
                                  (product.thumbnail_image ?? ''),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: product.has_discount &&
                        product.stroked_price != null &&
                        (product.stroked_price ?? '').isNotEmpty
                    ? 6
                    : 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _size.width * 0.03,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        product.name ?? '',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      Visibility(
                        visible: product.main_price != null &&
                            (product.main_price ?? '').isNotEmpty,
                        child: Text(
                          product.main_price,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: MyTheme.accent_color,
                                    fontFamily: GoogleFonts.mulish().fontFamily,
                                  ),
                        ),
                      ),
                      Visibility(
                        visible: product.has_discount &&
                            product.stroked_price != null &&
                            (product.stroked_price ?? '').isNotEmpty,
                        child: Text(
                          product.stroked_price ?? '',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).disabledColor,
                                    decoration: TextDecoration.lineThrough,
                                    fontFamily: GoogleFonts.mulish().fontFamily,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

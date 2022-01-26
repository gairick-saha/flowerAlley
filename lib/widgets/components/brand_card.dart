import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  final Brand brand;
  final ValueChanged<Brand> onPressed;
  final ShapeBorder cardShape;
  final int imageFlex;
  final int textFlex;

  const BrandCard({
    Key key,
    @required this.brand,
    @required this.onPressed,
    this.cardShape,
    this.imageFlex = 5,
    this.textFlex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(brand),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          side: cardShape != null
              ? BorderSide.none
              : BorderSide(
                  color: Theme.of(context).disabledColor.withOpacity(0.3),
                  width: 1.0,
                ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        child: SizedBox(
          height: double.maxFinite,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: imageFlex,
                child: Hero(
                  tag: 'brandIcon${brand.name}',
                  child: cardShape != null
                      ? Card(
                          clipBehavior: Clip.hardEdge,
                          shape: cardShape ??
                              RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.3),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                          elevation: cardShape != null ? 3.0 : 0.0,
                          child: brand.logo != null &&
                                  (brand.logo ?? '').isEmpty
                              ? FadeInImage(
                                  placeholder:
                                      AssetImage('assets/placeholder.jpeg'),
                                  image: AssetImage('assets/placeholder.jpeg'),
                                  fit: BoxFit.fill,
                                )
                              : FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.jpeg',
                                  image: AppConfig.BASE_PATH + brand.logo,
                                  fit: BoxFit.fill,
                                ),
                        )
                      : ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                            bottom: Radius.zero,
                          ),
                          child: brand.logo != null &&
                                  (brand.logo ?? '').isEmpty
                              ? FadeInImage(
                                  placeholder:
                                      AssetImage('assets/placeholder.jpeg'),
                                  image: AssetImage('assets/placeholder.jpeg'),
                                  fit: BoxFit.fill,
                                )
                              : FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.jpeg',
                                  image: AppConfig.BASE_PATH + brand.logo,
                                  fit: BoxFit.fill,
                                ),
                        ),
                ),
              ),
              Expanded(
                flex: textFlex,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.005,
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: (brand.name ?? '').split('(').first,
                            style:
                                Theme.of(context).textTheme.subtitle2?.copyWith(
                                      fontSize: 12,
                                    ),
                          ),
                          TextSpan(
                            text: (brand.name ?? '').contains('(') ? '\n' : '',
                            style:
                                Theme.of(context).textTheme.subtitle2?.copyWith(
                                      fontSize: 12,
                                    ),
                          ),
                          TextSpan(
                            text: (brand.name ?? '').contains('(')
                                ? (brand.name ?? '')
                                    .split('(')
                                    .last
                                    .replaceAll(')', '')
                                : '',
                            style:
                                Theme.of(context).textTheme.subtitle2?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ),
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

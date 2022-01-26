import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/sub_menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final ValueChanged<Category> onPressed;
  final int imageFlex;
  final int textFlex;
  final bool isGridItem;
  const CategoryCard({
    Key key,
    @required this.category,
    @required this.onPressed,
    this.imageFlex = 5,
    this.textFlex = 1,
    this.isGridItem = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (isGridItem) {
      return GestureDetector(
        onTap: () => onPressed(category),
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
                  flex: imageFlex,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                        bottom: Radius.zero,
                      ),
                      child: Hero(
                        tag: 'categoryImage${category.id}',
                        child: category.banner != null &&
                                (category.banner ?? '').isEmpty
                            ? FadeInImage(
                                placeholder:
                                    AssetImage('assets/placeholder.jpeg'),
                                image: AssetImage('assets/placeholder.jpeg'),
                                fit: BoxFit.fill,
                              )
                            : FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.jpeg',
                                image: AppConfig.BASE_PATH + category.banner,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: textFlex,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: _size.height * 0.005,
                      horizontal: _size.width * 0.03,
                    ),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: (category.name ?? '').split('(').first,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    fontSize: 12,
                                  ),
                            ),
                            TextSpan(
                              text: (category.name ?? '').contains('(')
                                  ? '\n'
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    fontSize: 12,
                                  ),
                            ),
                            TextSpan(
                              text: (category.name ?? '').contains('(')
                                  ? (category.name ?? '')
                                      .split('(')
                                      .last
                                      .replaceAll(')', '')
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
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
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: _size.height * 0.01,
        ),
        child: ListTile(
          tileColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: MyTheme.light_grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: _size.height * 0.01,
            horizontal: _size.width * 0.01,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Hero(
              tag: 'categoryImage${category.id}',
              child: category.banner != null && (category.banner ?? '').isEmpty
                  ? FadeInImage(
                      placeholder: AssetImage('assets/placeholder.jpeg'),
                      image: AssetImage('assets/placeholder.jpeg'),
                      fit: BoxFit.fill,
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.jpeg',
                      image: AppConfig.BASE_PATH + category.banner,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          title: Text(
            (category.name ?? '').split('(').first,
            textScaleFactor: 1,
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: MyTheme.font_grey,
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(
              top: Get.height * 0.01,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: category.number_of_children > 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SubMenu(
                              categoryItem: category,
                              type: 'sub_categories',
                            );
                          }));
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.02,
                          vertical: Get.height * 0.005,
                        ),
                        height: 10,
                        color:
                            Theme.of(context).buttonTheme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          AppLocalizations.of(context)
                              .category_list_screen_view_subcategories,
                          textScaleFactor: Get.textScaleFactor,
                          style: Theme.of(context).textTheme.button?.copyWith(
                                // fontSize: 10,
                                color: Theme.of(context).primaryColor,
                                // decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SubMenu(
                        categoryItem: category,
                        type: 'category_products',
                      );
                    }));
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.02,
                    vertical: Get.height * 0.005,
                  ),
                  height: 10,
                  color: Theme.of(context).buttonTheme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    AppLocalizations.of(context)
                        .category_list_screen_view_products,
                    textScaleFactor: Get.textScaleFactor,
                    style: Theme.of(context).textTheme.button?.copyWith(
                          // fontSize: 10,
                          color: Theme.of(context).primaryColor,
                          // decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ],
            ),
          ),

          // RichText(
          //   textScaleFactor: 1,
          //   textAlign: TextAlign.left,
          //   overflow: TextOverflow.ellipsis,
          //   maxLines: 1,
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text: AppLocalizations.of(context)
          //             .category_list_screen_view_subcategories,
          //         style: Theme.of(context).textTheme.subtitle2?.copyWith(
          //               fontSize: 10,
          //               color: category.number_of_children > 0
          //                   ? MyTheme.medium_grey
          //                   : MyTheme.light_grey,
          //               decoration: TextDecoration.underline,
          //             ),
          //       ),
          //       TextSpan(
          //         text: " | ",
          //         style: TextStyle(
          //           color: MyTheme.medium_grey,
          //         ),
          //       ),
          //       TextSpan(
          //         text: AppLocalizations.of(context)
          //             .category_list_screen_view_products,
          //         style: Theme.of(context).textTheme.subtitle2?.copyWith(
          //               fontSize: 10,
          //               color: category.number_of_children > 0
          //                   ? MyTheme.medium_grey
          //                   : MyTheme.light_grey,
          //               decoration: TextDecoration.underline,
          //             ),
          //       ),
          //     ],
          //   ),
          // ),
          onTap: () => onPressed(category),
        ),
      );
    }
  }
}

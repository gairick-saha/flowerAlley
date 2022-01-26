import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/screens/dashboard/controllers/dashboard_controller.dart';
import 'package:active_ecommerce_flutter/screens/sub_menu_list.dart';
import 'package:active_ecommerce_flutter/widgets/components/category_card.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryList extends StatefulWidget {
  CategoryList({
    Key key,
    this.parent_category_id = 0,
    this.parent_category_name = "",
    this.is_base_category = false,
    this.is_top_category = false,
  }) : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> _allCategoryList = [];
  List<Category> _filteredCategoryList = [];
  bool _isCategoryInitial = false;
  TextEditingController _searchController = TextEditingController();

  void _resetAndSearchData(String query) async {
    setState(() {
      _isCategoryInitial = true;
      _filteredCategoryList.clear();
    });

    await Future.delayed(Duration(milliseconds: 600), () {
      Get.find<DashboardController>().fetchCartData();
      if (query.isEmpty) {
        _filteredCategoryList.clear();
        _filteredCategoryList.addAll(_allCategoryList);
        _isCategoryInitial = false;
        setState(() {});
      } else {
        _filteredCategoryList.clear();
        final List<Category> _filteredData = _allCategoryList
            .where((Category element) =>
                (element.name.toLowerCase()).contains(query.toLowerCase()))
            .toList();
        _filteredCategoryList.addAll(_filteredData);
        _isCategoryInitial = false;
        setState(() {});
      }
    });
  }

  Future<void> _onRefresh() async {
    reset();
    _fetchAllCategories();
  }

  reset() {
    _allCategoryList.clear();
    _filteredCategoryList.clear();
    _isCategoryInitial = true;
    setState(() {});
  }

  @override
  void initState() {
    _isCategoryInitial = true;
    _fetchAllCategories();
    super.initState();
  }

  _fetchAllCategories() async {
    if (widget.is_top_category) {
      var categoryResponse = await CategoryRepository().getTopCategories();
      _allCategoryList.addAll(categoryResponse.categories);
      _filteredCategoryList.addAll(_allCategoryList);
      _isCategoryInitial = false;
      setState(() {});
    } else {
      var categoryResponse = await CategoryRepository().getAllCategories();
      _allCategoryList.addAll(categoryResponse.categories);
      _filteredCategoryList.addAll(_allCategoryList);
      _isCategoryInitial = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        // body: Stack(children: [
        //   CustomScrollView(
        //     slivers: [
        //       SliverList(
        //           delegate: SliverChildListDelegate([
        //         buildCategoryList(),
        //         Container(
        //           height: widget.is_base_category ? 60 : 90,
        //         )
        //       ]))
        //     ],
        //   ),
        //   Align(
        //     alignment: Alignment.bottomCenter,
        //     child: widget.is_base_category || widget.is_top_category
        //         ? Container(
        //             height: 0,
        //           )
        //         : buildBottomContainer(),
        //   )
        // ])
        body: RefreshIndicator(
          color: MyTheme.accent_color,
          backgroundColor: Colors.white,
          displacement: 0,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverVisibility(
                visible: _isCategoryInitial && _filteredCategoryList.isEmpty,
                sliver: SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.05,
                    MediaQuery.of(context).size.height * 0.01,
                    MediaQuery.of(context).size.width * 0.05,
                    kBottomNavigationBarHeight -
                        MediaQuery.of(context).size.height * 0.02,
                  ),
                  sliver: ShimmerHelper().buildListShimmer(sliverItem: true),
                ),
              ),
              SliverVisibility(
                visible:
                    !_isCategoryInitial && _filteredCategoryList.isNotEmpty,
                sliver: SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.05,
                    MediaQuery.of(context).size.height * 0.01,
                    MediaQuery.of(context).size.width * 0.05,
                    kBottomNavigationBarHeight -
                        MediaQuery.of(context).size.height * 0.02,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return CategoryCard(
                          isGridItem: false,
                          category: _filteredCategoryList[index],
                          onPressed: (_category) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SubMenu(
                                categoryItem: _category,
                                type: 'sub_categories',
                              );
                            }));
                          },
                        );
                      },
                      childCount: _filteredCategoryList.length,
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: widget.is_base_category
          ? GestureDetector(
              onTap: () {
                Get.find<DashboardController>()
                    .scaffoldKey
                    .currentState
                    ?.openDrawer();
              },
              child: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 0.0),
                  child: Container(
                    child: Image.asset(
                      'assets/hamburger.png',
                      height: 16,
                      color: MyTheme.dark_grey,
                    ),
                  ),
                ),
              ),
            )
          : Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      // title: Text(
      //   getAppBarTitle(),
      //   style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      // ),
      title: Container(
        height: kToolbarHeight +
            MediaQuery.of(context).padding.top -
            (MediaQuery.of(context).viewPadding.top > 40 ? 16.0 : 16.0),
        child: Padding(
          padding: app_language_rtl.$
              ? const EdgeInsets.only(top: 14.0, bottom: 14, left: 12)
              : const EdgeInsets.only(top: 14.0, bottom: 14, right: 12),
          child: TextField(
            controller: _searchController,
            onTap: () {},
            onChanged: _resetAndSearchData,
            onSubmitted: _resetAndSearchData,
            autofocus: false,
            decoration: InputDecoration(
              hintText:
                  '${AppLocalizations.of(context).home_screen_search} in: Categories',
              hintStyle:
                  TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(16.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(16.0),
                ),
              ),
              contentPadding: EdgeInsets.all(0.0),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: MyTheme.textfield_grey,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = widget.parent_category_name == ""
        ? (widget.is_top_category
            ? AppLocalizations.of(context).category_list_screen_top_categories
            : AppLocalizations.of(context).category_list_screen_categories)
        : widget.parent_category_name;

    return name;
  }

  // buildCategoryList() {
  //   var future = widget.is_top_category
  //       ? CategoryRepository().getTopCategories()
  //       : CategoryRepository().getAllCategories();
  //   return FutureBuilder(
  //       future: future,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           //snapshot.hasError
  //           print("category list error");
  //           print(snapshot.error.toString());
  //           return Container(
  //             height: 10,
  //           );
  //         } else if (snapshot.hasData) {
  //           //snapshot.hasData
  //           var categoryResponse = snapshot.data;
  //           return SingleChildScrollView(
  //             child: ListView.builder(
  //               itemCount: categoryResponse.categories.length,
  //               scrollDirection: Axis.vertical,
  //               physics: NeverScrollableScrollPhysics(),
  //               shrinkWrap: true,
  //               itemBuilder: (context, index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
  //                   child: buildCategoryItemCard(categoryResponse, index),
  //                 );
  //               },
  //             ),
  //           );
  //         } else {
  //           return SingleChildScrollView(
  //             child: ListView.builder(
  //               itemCount: 10,
  //               scrollDirection: Axis.vertical,
  //               physics: NeverScrollableScrollPhysics(),
  //               shrinkWrap: true,
  //               itemBuilder: (context, index) {
  //                 return Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
  //                   child: Row(
  //                     children: [
  //                       Shimmer.fromColors(
  //                         baseColor: MyTheme.shimmer_base,
  //                         highlightColor: MyTheme.shimmer_highlighted,
  //                         child: Container(
  //                           height: 60,
  //                           width: 60,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                                 left: 16.0, bottom: 8.0),
  //                             child: Shimmer.fromColors(
  //                               baseColor: MyTheme.shimmer_base,
  //                               highlightColor: MyTheme.shimmer_highlighted,
  //                               child: Container(
  //                                 height: 20,
  //                                 width: MediaQuery.of(context).size.width * .7,
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 16.0),
  //                             child: Shimmer.fromColors(
  //                               baseColor: MyTheme.shimmer_base,
  //                               highlightColor: MyTheme.shimmer_highlighted,
  //                               child: Container(
  //                                 height: 20,
  //                                 width: MediaQuery.of(context).size.width * .5,
  //                                 color: Colors.white,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             ),
  //           );
  //         }
  //       });
  // }

  // Card buildCategoryItemCard(categoryResponse, index) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
  //       borderRadius: BorderRadius.circular(16.0),
  //     ),
  //     elevation: 0.0,
  //     child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
  //       Container(
  //         width: 80,
  //         height: 80,
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.horizontal(
  //               left: Radius.circular(16), right: Radius.zero),
  //           child: categoryResponse.categories[index].banner == null ||
  //                   categoryResponse.categories[index].banner == ''
  //               ? FadeInImage(
  //                   placeholder: AssetImage('assets/placeholder.jpeg'),
  //                   image: AssetImage('assets/placeholder.jpeg'),
  //                 )
  //               : FadeInImage.assetNetwork(
  //                   placeholder: 'assets/placeholder.jpeg',
  //                   image: AppConfig.BASE_PATH +
  //                       categoryResponse.categories[index].banner,
  //                   fit: BoxFit.cover,
  //                 ),
  //         ),
  //       ),
  //       Container(
  //         height: 80,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.fromLTRB(16, 8, 8, 0),
  //               child: Text(
  //                 categoryResponse.categories[index].name,
  //                 textAlign: TextAlign.left,
  //                 overflow: TextOverflow.ellipsis,
  //                 maxLines: 1,
  //                 style: TextStyle(
  //                     color: MyTheme.font_grey,
  //                     fontSize: 14,
  //                     height: 1.6,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.fromLTRB(32, 8, 8, 4),
  //               child: Row(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       if (categoryResponse
  //                               .categories[index].number_of_children >
  //                           0) {
  //                         Navigator.push(context,
  //                             MaterialPageRoute(builder: (context) {
  //                           return CategoryList(
  //                             parent_category_id:
  //                                 categoryResponse.categories[index].id,
  //                             parent_category_name:
  //                                 categoryResponse.categories[index].name,
  //                           );
  //                         }));
  //                       } else {
  //                         ToastComponent.showDialog(
  //                             AppLocalizations.of(context)
  //                                 .category_list_screen_no_subcategories,
  //                             context,
  //                             gravity: Toast.CENTER,
  //                             duration: Toast.LENGTH_LONG);
  //                       }
  //                     },
  //                     child: Text(
  //                       AppLocalizations.of(context)
  //                           .category_list_screen_view_subcategories,
  //                       textAlign: TextAlign.left,
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 1,
  //                       style: TextStyle(
  //                           color: categoryResponse
  //                                       .categories[index].number_of_children >
  //                                   0
  //                               ? MyTheme.medium_grey
  //                               : MyTheme.light_grey,
  //                           decoration: TextDecoration.underline),
  //                     ),
  //                   ),
  //                   Text(
  //                     " | ",
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                       color: MyTheme.medium_grey,
  //                     ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.push(context,
  //                           MaterialPageRoute(builder: (context) {
  //                         return CategoryProducts(
  //                           category_id: categoryResponse.categories[index].id,
  //                           category_name:
  //                               categoryResponse.categories[index].name,
  //                         );
  //                       }));
  //                     },
  //                     child: Text(
  //                       AppLocalizations.of(context)
  //                           .category_list_screen_view_products,
  //                       textAlign: TextAlign.left,
  //                       overflow: TextOverflow.ellipsis,
  //                       maxLines: 1,
  //                       style: TextStyle(
  //                           color: MyTheme.medium_grey,
  //                           decoration: TextDecoration.underline),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  // Container buildBottomContainer() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //     ),

  //     height: widget.is_base_category ? 0 : 80,
  //     //color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.only(top: 8.0),
  //             child: Container(
  //               width: (MediaQuery.of(context).size.width - 32),
  //               height: 40,
  //               child: FlatButton(
  //                 minWidth: MediaQuery.of(context).size.width,
  //                 //height: 50,
  //                 color: MyTheme.accent_color,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius:
  //                         const BorderRadius.all(Radius.circular(8.0))),
  //                 child: Text(
  //                   AppLocalizations.of(context)
  //                           .category_list_screen_all_products_of +
  //                       " " +
  //                       widget.parent_category_name,
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w600),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (context) {
  //                     return CategoryProducts(
  //                       category_id: widget.parent_category_id,
  //                       category_name: widget.parent_category_name,
  //                     );
  //                   }));
  //                 },
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

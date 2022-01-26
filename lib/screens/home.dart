import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/brand_repository.dart';
import 'package:active_ecommerce_flutter/screens/dashboard/controllers/dashboard_controller.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/screens/sub_menu_list.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/top_selling_products.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/widgets/components/content_title.dart';
import 'package:active_ecommerce_flutter/widgets/components/search_box.dart';
import 'package:active_ecommerce_flutter/widgets/horizontal_list_item.dart';
import 'package:active_ecommerce_flutter/widgets/horizontal_list_loader.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:active_ecommerce_flutter/repositories/sliders_repository.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.show_back_button = false, go_back = true})
      : super(key: key);

  final String title;
  bool show_back_button;
  bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _current_slider = 0;
  ScrollController _featuredProductScrollController;
  ScrollController _mainScrollController = ScrollController();

  AnimationController pirated_logo_controller;
  Animation pirated_logo_animation;

  var _carouselImageList = [];
  List<Category> _featuredCategoryList = [];
  List<Brand> _topBrandsList = [];
  final Map<Category, List<Product>> _homeCategoryProductList =
      <Category, List<Product>>{};
  List<Product> _featuredProductList = [];
  final List<Category> _homeCategoryList = <Category>[];
  bool _isProductInitial = true;
  bool _isCategoryInitial = true;
  bool _isCarouselInitial = true;
  bool _isTopBrandsInitial = true;
  bool _isHomeCategoryInitial = true;
  int _totalProductData = 0;
  int _productPage = 1;
  bool _showProductLoadingContainer = false;

  @override
  void initState() {
    super.initState();

    if (AppConfig.purchase_code == "") {
      initPiratedAnimation();
    }

    fetchAll();
    Get.find<DashboardController>().fetchCartData();

    _mainScrollController.addListener(() {
      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchFeaturedProducts();
      }
    });
  }

  fetchAll() {
    fetchCarouselImages();
    fetchTopBrands();
    fetchFeaturedCategories();
    fetchFeaturedProducts();
    fetchHomeCategories();
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders.forEach((slider) {
      _carouselImageList.add(slider.photo);
    });
    _isCarouselInitial = false;
    setState(() {});
  }

  fetchTopBrands() async {
    var brandResponse = await BrandRepository().getTopBrands();

    _topBrandsList.addAll(brandResponse);
    _isTopBrandsInitial = false;
    setState(() {});
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();

    _featuredCategoryList.addAll(categoryResponse.categories);
    _isCategoryInitial = false;
    setState(() {});
  }

  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: _productPage,
    );

    _featuredProductList.addAll(productResponse.products);
    _isProductInitial = false;
    _totalProductData = productResponse.meta.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchHomeCategories() async {
    var categoryResponse = await CategoryRepository().getHomeCategories();
    _homeCategoryList.addAll(categoryResponse);

    for (var _category in _homeCategoryList) {
      if (_category.links.products != null) {
        await _fetchHomeCategoryProducts(category: _category)
            .then((List<Product> _response) {
          _homeCategoryProductList[_category] = _response;
          _isHomeCategoryInitial = false;
          setState(() {});
        });
      }
    }
  }

  Future<List<Product>> _fetchHomeCategoryProducts({
    @required Category category,
  }) async {
    _homeCategoryProductList[category] = [];
    final _homeCategoryProductsPath = category.links.products;
    return await ProductRepository()
        .getHomeCategoryProducts(
      url: _homeCategoryProductsPath,
    )
        .then(
      (List<Product> _response) {
        return _response;
      },
    );
  }

  reset() {
    _carouselImageList.clear();
    _featuredCategoryList.clear();
    _homeCategoryList.clear();
    _topBrandsList.clear();
    _isCarouselInitial = true;
    _isTopBrandsInitial = true;
    _isHomeCategoryInitial = true;
    _isCategoryInitial = true;

    setState(() {});

    resetProductList();
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  resetProductList() {
    _featuredProductList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  initPiratedAnimation() {
    pirated_logo_controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    pirated_logo_animation = Tween(begin: 40.0, end: 60.0).animate(
        CurvedAnimation(
            curve: Curves.bounceOut, parent: pirated_logo_controller));

    pirated_logo_controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller.repeat();
      }
    });

    pirated_logo_controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    pirated_logo_controller?.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () async {
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(statusBarHeight, context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,
            displacement: 0,
            child: CustomScrollView(
              slivers: [
                ..._buildHomeCarousel(context),
                // SliverPadding(
                //   padding: const EdgeInsets.fromLTRB(
                //     8.0,
                //     16.0,
                //     8.0,
                //     0.0,
                //   ),
                //   sliver: SliverToBoxAdapter(
                //     child: buildHomeMenuRow(context),
                //   ),
                // ),

                ..._buildFeaturedCategoriesRow(),
                ..._buildTopBrandsRow(),
                ..._buildFeaturedProductsRow(),
                _buildHomeCategoriesProductList(),

                SliverVisibility(
                  visible: _showProductLoadingContainer,
                  sliver: SliverToBoxAdapter(
                    child: buildProductLoadingContainer(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHomeCarousel(BuildContext context) {
    return [
      SliverVisibility(
        visible: _isCarouselInitial && _carouselImageList.isEmpty,
        sliver: SliverPadding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.height * 0.01,
            MediaQuery.of(context).size.width * 0.05,
            0.0,
          ),
          sliver: SliverToBoxAdapter(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              child: Shimmer.fromColors(
                baseColor: MyTheme.shimmer_base,
                highlightColor: MyTheme.shimmer_highlighted,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      SliverVisibility(
        visible: !_isCarouselInitial && _carouselImageList.isNotEmpty,
        sliver: SliverPadding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.05,
            MediaQuery.of(context).size.height * 0.01,
            MediaQuery.of(context).size.width * 0.05,
            0.0,
          ),
          sliver: SliverToBoxAdapter(
            child: CarouselSlider(
              options: CarouselOptions(
                  aspectRatio: 2.67,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.easeInCubic,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current_slider = index;
                    });
                  }),
              items: _carouselImageList.map((i) {
                return i == null
                    ? const SizedBox.shrink()
                    : Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/placeholder_rectangle.png',
                                    image: AppConfig.BASE_PATH + i,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _carouselImageList.map((url) {
                                    int index = _carouselImageList.indexOf(url);
                                    return Container(
                                      width: 7.0,
                                      height: 7.0,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _current_slider == index
                                            ? Theme.of(context)
                                                .scaffoldBackgroundColor
                                            : const Color.fromRGBO(
                                                112, 112, 112, .3),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        },
                      );
              }).toList(),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildTopBrandsRow() {
    return [
      SliverVisibility(
        visible: !_isTopBrandsInitial && _topBrandsList.isNotEmpty,
        sliver: ContentTitle(
          title: 'Top Brands',
          topSpacing: MediaQuery.of(context).size.height * 0.02,
          bottomSpacing: MediaQuery.of(context).size.height * 0.01,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SubMenu(
                type: 'all_brands',
              );
            }));
          },
        ),
      ),
      SliverVisibility(
        visible: _isTopBrandsInitial && _topBrandsList.isEmpty,
        sliver: const HorizontalListLoader(),
      ),
      SliverVisibility(
        visible: !_isTopBrandsInitial && _topBrandsList.isNotEmpty,
        sliver: SliverPadding(
          padding: EdgeInsets.only(
            bottom: _featuredProductList.isNotEmpty
                ? 0
                : kBottomNavigationBarHeight +
                    MediaQuery.of(context).size.height * 0.05,
          ),
          sliver: HorizontalListItems(
            brandItems: _topBrandsList,
            brandCardShape: const CircleBorder(),
            onPressed: (_brand) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SubMenu(
                  brandItem: _brand,
                  type: 'brand_products',
                );
              }));
            },
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildFeaturedCategoriesRow() {
    return [
      // SliverVisibility(
      //   visible: !_isCategoryInitial && _featuredCategoryList.isNotEmpty,
      //   sliver: ContentTitle(
      //     title: 'Featured Categories',
      //     topSpacing: MediaQuery.of(context).size.height * 0.02,
      //     bottomSpacing: MediaQuery.of(context).size.height * 0.01,
      //   ),
      // ),
      SliverVisibility(
        visible: _isCategoryInitial && _featuredCategoryList.isEmpty,
        sliver: SliverPadding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
          ),
          sliver: const HorizontalListLoader(),
        ),
      ),
      SliverVisibility(
        visible: !_isCategoryInitial && _featuredCategoryList.isNotEmpty,
        sliver: SliverPadding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02,
            bottom: _featuredCategoryList.isNotEmpty
                ? 0
                : kBottomNavigationBarHeight +
                    MediaQuery.of(context).size.height * 0.05,
          ),
          sliver: HorizontalListItems(
            categoryItems: _featuredCategoryList,
            onPressed: (_category) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SubMenu(
                  categoryItem: _category,
                  type: 'category_products',
                );
              }));
            },
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildFeaturedProductsRow() {
    return [
      SliverVisibility(
        visible: !_isProductInitial && _featuredProductList.isNotEmpty,
        sliver: ContentTitle(
          title: 'Featured Products',
          topSpacing: MediaQuery.of(context).size.height * 0.02,
          bottomSpacing: MediaQuery.of(context).size.height * 0.01,
        ),
      ),
      SliverVisibility(
        visible: _isProductInitial && _featuredProductList.isEmpty,
        sliver: const HorizontalListLoader(),
      ),
      SliverVisibility(
        visible: !_isProductInitial && _featuredProductList.isNotEmpty,
        sliver: SliverPadding(
          padding: EdgeInsets.only(
            bottom: _homeCategoryProductList.isNotEmpty
                ? 0
                : kBottomNavigationBarHeight +
                    MediaQuery.of(context).size.height * 0.05,
          ),
          sliver: HorizontalListItems(
            productItems: _featuredProductList,
            onPressed: (_product) {
              Get.find<DashboardController>().showFloatingButton(false);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProductDetails(
                  id: _product.id,
                );
              }));
            },
          ),
        ),
      ),
    ];
  }

  Widget _buildHomeCategoriesProductList() {
    return SliverVisibility(
      visible: !_isHomeCategoryInitial &&
          _homeCategoryProductList.entries.isNotEmpty,
      sliver: SliverPadding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          // bottom: controller.homeCategoryProductList.entries.last ?
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: _homeCategoryProductList.entries.length - 1 != index
                      ? 0
                      : kBottomNavigationBarHeight +
                          MediaQuery.of(context).size.height * 0.05,
                  // bottom: 0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentTitle(
                      title:
                          _homeCategoryProductList.keys.toList()[index].name ??
                              '',
                      topSpacing: MediaQuery.of(context).size.height * 0.03,
                      bottomSpacing: MediaQuery.of(context).size.height * 0.01,
                      isSliverItem: false,
                      onPressed: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return SubMenu(
                        //     categoryItem:
                        //         _homeCategoryProductList.keys.toList()[index],
                        //     type: 'sub_categories',
                        //   );
                        // }));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SubMenu(
                            categoryItem:
                                _homeCategoryProductList.keys.toList()[index],
                            type: 'category_products',
                          );
                        }));
                      },
                    ),
                    Visibility(
                      visible: _homeCategoryProductList.containsKey(
                              _homeCategoryProductList.keys.toList()[index])
                          ? (_homeCategoryProductList[_homeCategoryProductList
                                      .keys
                                      .toList()[index]] ??
                                  [])
                              .isEmpty
                          : false,
                      // visible: _isHomeCategoryProductsLoading.value,
                      child: const HorizontalListLoader(
                        sliverItem: false,
                      ),
                    ),
                    Visibility(
                      visible: (_homeCategoryProductList[
                                  _homeCategoryProductList.keys
                                      .toList()[index]] ??
                              [])
                          .isNotEmpty,
                      child: HorizontalListItems(
                        productItems:
                            _homeCategoryProductList.values.toList()[index],
                        sliverItem: false,
                        onPressed: (_product) {
                          Get.find<DashboardController>()
                              .showFloatingButton(false);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProductDetails(
                              id: _product.id,
                            );
                          }));
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: _homeCategoryProductList.entries.length,
          ),
        ),
      ),
    );
  }

  Widget buildHomeMenuRow(BuildContext context) {
    Widget _buildNavButton({
      @required String title,
      @required String icon,
      @required VoidCallback onPressed,
    }) {
      return GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width / 5 - 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                shape: const CircleBorder(),
                borderOnForeground: true,
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).disabledColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: SizedBox.square(
                    dimension: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        icon,
                        scale: 1,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button?.copyWith(
                        color: const Color.fromRGBO(132, 132, 132, 1),
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildNavButton(
          title: AppLocalizations.of(context).home_screen_top_categories,
          icon: "assets/top_categories.png",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CategoryList(
                is_top_category: true,
              );
            }));
          },
        ),
        _buildNavButton(
          title: AppLocalizations.of(context).home_screen_brands,
          icon: "assets/brands.png",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Filter(
                selected_filter: "brands",
              );
            }));
          },
        ),
        _buildNavButton(
          title: AppLocalizations.of(context).home_screen_top_sellers,
          icon: "assets/top_sellers.png",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TopSellingProducts();
            }));
          },
        ),
        _buildNavButton(
          title: AppLocalizations.of(context).home_screen_todays_deal,
          icon: "assets/todays_deal.png",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TodaysDealProducts();
            }));
          },
        ),
        _buildNavButton(
          title: AppLocalizations.of(context).home_screen_flash_deal,
          icon: "assets/flash_deal.png",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FlashDealList();
            }));
          },
        ),
      ],
    );
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Get.find<DashboardController>()
              .scaffoldKey
              .currentState
              ?.openDrawer();
        },
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                    icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                    onPressed: () {
                      if (!widget.go_back) {
                        return;
                      }
                      return Navigator.of(context).pop();
                    }),
              )
            : Builder(
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
      ),
      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery.of(context).viewPadding.top > 40 ? 16.0 : 16.0),
        child: Container(
          child: Padding(
              padding: app_language_rtl.$
                  ? const EdgeInsets.only(top: 14.0, bottom: 14, left: 12)
                  : const EdgeInsets.only(top: 14.0, bottom: 14, right: 12),
              child: SearchBox()),
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        InkWell(
          onTap: () {
            ToastComponent.showDialog(
                AppLocalizations.of(context).common_coming_soon, context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          },
          child: Visibility(
            visible: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
              child: Image.asset(
                'assets/bell.png',
                height: 16,
                color: MyTheme.dark_grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalProductData == _featuredProductList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }
}

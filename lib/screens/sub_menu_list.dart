import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/data_model/category_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/brand_repository.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/screens/dashboard/controllers/dashboard_controller.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/widgets/grid_list_items.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class SubMenu extends StatefulWidget {
  SubMenu({
    Key key,
    this.categoryItem,
    this.productItem,
    this.brandItem,
    @required this.type,
  }) : super(key: key);

  final Category categoryItem;
  final Product productItem;
  final Brand brandItem;
  final String type;

  @override
  _SubMenuState createState() => _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
  TextEditingController _searchController = TextEditingController();

  List<Category> _categoryList = [];
  List<Product> _productList = [];
  List<Brand> _brandList = [];
  List<Brand> _filteredBrandList = [];

  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int _totalData = 0;
  bool _showLoadingContainer = false;
  String _appBarTitle = "";

  void _resetAndSearchData(String query) async {
    setState(() {
      _isInitial = true;
      _filteredBrandList.clear();
    });

    await Future.delayed(Duration(milliseconds: 600), () {
      if (query.isEmpty) {
        _filteredBrandList.clear();
        _filteredBrandList.addAll(_brandList);
        _isInitial = false;
        setState(() {});
      } else {
        _filteredBrandList.clear();
        final List<Brand> _filteredData = _brandList
            .where((Brand element) =>
                (element.name.toLowerCase()).startsWith(query.toLowerCase()))
            .toList();
        _filteredBrandList.addAll(_filteredData);
        _isInitial = false;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    if (widget.type == "category_products") {
      _appBarTitle = widget.categoryItem.name;
      var productResponse = await ProductRepository().getCategoryProducts(
        id: widget.categoryItem.id,
        page: _page,
        name: _searchKey,
      );
      _productList.addAll(productResponse.products);
      _totalData = productResponse.meta.total;
      _isInitial = false;
      _showLoadingContainer = false;
      setState(() {});
    }
    if (widget.type == "brand_products") {
      _appBarTitle = widget.brandItem.name;
      var productResponse = await ProductRepository().getBrandProducts(
        id: widget.brandItem.id,
        page: _page,
        name: _searchKey,
      );
      _productList.addAll(productResponse.products);
      _totalData = productResponse.meta.total;
      _isInitial = false;
      _showLoadingContainer = false;
      setState(() {});
    }
    if (widget.type == "sub_categories") {
      _appBarTitle = widget.categoryItem.name;
      var categoryResponse = await CategoryRepository().getSubCategories(
        widget.categoryItem.id,
      );
      _categoryList.addAll(categoryResponse);
      _totalData = _categoryList.length;
      _isInitial = false;
      _showLoadingContainer = false;
      setState(() {});
    }
    if (widget.type == "all_brands") {
      _appBarTitle = 'Brands';
      var brandResponse = await BrandRepository().getBrands(
        page: _page,
      );

      _brandList.addAll(brandResponse.brands);
      _filteredBrandList.addAll(_brandList);
      _totalData = brandResponse.meta.total;
      _isInitial = false;
      _showLoadingContainer = false;
      setState(() {});
    }
  }

  reset() {
    _categoryList.clear();
    _productList.clear();
    _brandList.clear();
    _filteredBrandList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildGridList(),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _productList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 75,
      /*bottom: PreferredSize(
          child: Container(
            color: MyTheme.textfield_grey,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(4.0)),*/
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(top: 14.0, bottom: 14, left: 12)
            : const EdgeInsets.only(top: 14.0, bottom: 14, right: 12),
        child: TextField(
          controller: _searchController,
          onChanged: widget.type == 'all_brands'
              ? _resetAndSearchData
              : (txt) {
                  _searchKey = txt;
                  reset();
                  fetchData();
                },
          onSubmitted: widget.type == 'all_brands'
              ? _resetAndSearchData
              : (txt) {
                  _searchKey = txt;
                  reset();
                  fetchData();
                },
          autofocus: false,
          decoration: InputDecoration(
            hintText:
                '${AppLocalizations.of(context).home_screen_search} from: ' +
                    _appBarTitle,
            hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
              borderRadius: const BorderRadius.all(
                const Radius.circular(16.0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
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
      elevation: 0.0,
      titleSpacing: 0,
      // actions: <Widget>[
      //   Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      //     child: IconButton(
      //       icon: Icon(Icons.search, color: MyTheme.dark_grey),
      //       onPressed: () {
      //         _searchKey = _searchController.text.toString();
      //         reset();
      //         fetchData();
      //       },
      //     ),
      //   ),
      // ],
    );
  }

  buildGridList() {
    return RefreshIndicator(
      color: MyTheme.accent_color,
      backgroundColor: Colors.white,
      displacement: 0,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverVisibility(
            visible: _isInitial &&
                (_productList.length == 0 ||
                    _categoryList.length == 0 ||
                    _brandList.length == 0),
            sliver: SliverPadding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.01,
                MediaQuery.of(context).size.width * 0.05,
                kBottomNavigationBarHeight +
                    MediaQuery.of(context).size.height * 0.04,
              ),
              sliver: ShimmerHelper().buildProductGridShimmer(sliverItem: true),
            ),
          ),
          SliverVisibility(
            visible: !_isInitial && _categoryList.isNotEmpty,
            sliver: SliverPadding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.01,
                MediaQuery.of(context).size.width * 0.05,
                kBottomNavigationBarHeight +
                    MediaQuery.of(context).size.height * 0.04,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.618,
                ),
                delegate: GridListItems(
                  categoryItems: _categoryList,
                  onPressed: (_category) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SubMenu(
                        categoryItem: _category,
                        type: 'category_products',
                      );
                    }));
                  },
                ).buildCategory(),
              ),
            ),
          ),
          SliverVisibility(
            visible: !_isInitial && _productList.isNotEmpty,
            sliver: SliverPadding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.01,
                MediaQuery.of(context).size.width * 0.05,
                kBottomNavigationBarHeight +
                    MediaQuery.of(context).size.height * 0.04,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.618,
                ),
                delegate: GridListItems(
                  productItems: _productList,
                  onPressed: (_product) {
                    Get.find<DashboardController>().showFloatingButton(false);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetails(
                        id: _product.id,
                      );
                    }));
                  },
                ).buildProduct(),
              ),
            ),
          ),
          SliverVisibility(
            visible: !_isInitial && _filteredBrandList.isNotEmpty,
            sliver: SliverPadding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.01,
                MediaQuery.of(context).size.width * 0.05,
                kBottomNavigationBarHeight +
                    MediaQuery.of(context).size.height * 0.04,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.618,
                ),
                delegate: GridListItems(
                  brandItems: _filteredBrandList,
                  onPressed: (_brand) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SubMenu(
                        brandItem: _brand,
                        type: 'brand_products',
                      );
                    }));
                  },
                ).buildBrand(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: buildLoadingContainer(),
            ),
          ),
        ],
      ),
    );
  }
}

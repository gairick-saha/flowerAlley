import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/dashboard/model/dashboard_model.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

part 'dashboard_routes.dart';

class DashboardNavRoutes {
  static final GetPage notFound = GetPage(
    name: _Paths.NOT_FOUND,
    page: () => Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page not found'),
      ),
    ),
  );

  static final List<DashboardNavModel> routes = <DashboardNavModel>[
    DashboardNavModel(
      title: "Home",
      icon: IconlyLight.home,
      page: GetPage(
        name: Routes.HOME,
        page: () => Home(),
      ),
    ),
    DashboardNavModel(
      title: "Categories",
      icon: IconlyLight.category,
      page: GetPage(
        name: Routes.CATEGORIES,
        page: () => CategoryList(
          is_base_category: true,
          is_top_category: false,
        ),
      ),
    ),
    DashboardNavModel(
      title: "Cart",
      icon: IconlyLight.buy,
      page: GetPage(
        name: Routes.CART,
        page: () => Cart(has_bottomnav: true),
      ),
    ),
    DashboardNavModel(
      title: "Profile",
      icon: IconlyLight.profile,
      page: GetPage(
        name: Routes.PROFILE,
        page: () => Profile(),
      ),
    ),
  ];
}

class PredictPage {
  final RouteSettings settings;
  final Map<String, GetPage<dynamic>> routes;

  const PredictPage({
    @required this.settings,
    @required this.routes,
  });

  static final Map<String, GetPage> _mappedRoutes = {};

  void _addRoutes() {
    for (var _routeItem in routes.entries) {
      _mappedRoutes[_routeItem.key] = _routeItem.value;
      if (_routeItem.value.children.isNotEmpty) {
        _addFirstChildrens(_routeItem.value.children);
      }
    }
  }

  void _addFirstChildrens(List<GetPage> childrens) {
    for (var page in childrens) {
      _mappedRoutes[page.name] = page;
      if (page.children.isNotEmpty) {
        _addSecondChildrens(page.children);
      }
    }
  }

  void _addSecondChildrens(List<GetPage> childrens) {
    for (var page in childrens) {
      _mappedRoutes[page.name] = page;
      if (page.children.isNotEmpty) {
        _addFirstChildrens(page.children);
      }
    }
  }

  GetPageRoute getPage() {
    final String _uri = Uri.encodeFull(settings.name ?? '');

    if (_uri.trim() != '/') {
      _addRoutes();
      final GetPage page = _mappedRoutes[_uri];

      if (_uri.trim() != '/' && page != null) {
        if (page.middlewares != null) {
          print(page.middlewares);
        }

        return GetPageRoute(
          routeName: page.name,
          settings: settings,
          page: page.page,
          binding: page.binding,
          middlewares: page.middlewares,
          transition: page.transition,
          curve: page.curve,
          transitionDuration:
              page.transitionDuration ?? Get.defaultDialogTransitionDuration,
        );
      } else {
        return _showError();
      }
    } else {
      return _showError();
    }
  }

  GetPageRoute _showError() {
    return GetPageRoute(
      routeName: Routes.NOT_FOUND,
      settings: settings,
      page: DashboardNavRoutes.notFound.page,
      binding: DashboardNavRoutes.notFound.binding,
      middlewares: DashboardNavRoutes.notFound.middlewares,
      transition: DashboardNavRoutes.notFound.transition,
      curve: DashboardNavRoutes.notFound.curve,
      transitionDuration: DashboardNavRoutes.notFound.transitionDuration ??
          Get.defaultDialogTransitionDuration,
    );
  }
}

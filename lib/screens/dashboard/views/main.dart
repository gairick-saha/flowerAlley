import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/dashboard/controllers/dashboard_controller.dart';
import 'package:active_ecommerce_flutter/screens/dashboard/routes/dashboard_pages.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/widgets/bottom_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final DashboardController _dashboardController =
      Get.put<DashboardController>(DashboardController());
  // var _children = [
  //   Home(),
  //   CategoryList(
  //     is_base_category: true,
  //     is_top_category: false,
  //   ),
  //   Cart(has_bottomnav: true),
  //   Profile()
  // ];
  var _dashboardRoutes = [
    Routes.HOME,
    Routes.CATEGORIES,
    Routes.CART,
    Routes.PROFILE,
  ];

  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _dashboardController.fetchCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _dashboardController.handleDeviceBackButton,
      child: Obx(
        () => Scaffold(
          extendBody: true,
          key: _dashboardController.scaffoldKey,
          drawer: MainDrawer(),
          body: Navigator(
            key: _dashboardController.menuKey,
            initialRoute: _dashboardController.initialRoute,
            observers: [
              GetObserver(_dashboardController.processRouting, Get.routing)
            ],
            onGenerateRoute: _dashboardController.onGenerateRoute,
            reportsRouteUpdateToEngine: true,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Visibility(
            visible: _dashboardController.showFloatingButton.value
                ? MediaQuery.of(context).viewInsets.bottom == 0.0
                : false,
            child: FloatingActionButton(
              backgroundColor: MyTheme.soft_accent_color,
              onPressed: () {
                _dashboardController.showFloatingButton(false);
                _dashboardController.menuKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Filter(
                        selected_filter: "sellers",
                      );
                    },
                  ),
                );
              },
              tooltip: "start FAB",
              child: SizedBox.square(
                dimension: 40,
                child: Image.asset(
                  'assets/logo_transparent.png',
                ),
              ),
              elevation: 0.0,
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            onTap: _dashboardController.changeTab,
            currentNavIndex: _dashboardController.currentNavIndex.value,
            showFloatingButton: _dashboardController.showFloatingButton.value,
            cartCount: _dashboardController.totalCartItems.value,
            items: [
              BottomNavBarItem(
                title: "Home",
                icon: IconlyLight.home,
              ),
              BottomNavBarItem(
                title: "Categories",
                icon: IconlyLight.category,
              ),
              BottomNavBarItem(
                title: "Cart",
                icon: IconlyLight.buy,
              ),
              BottomNavBarItem(
                title: "Profile",
                icon: IconlyLight.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

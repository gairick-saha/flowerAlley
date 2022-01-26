import 'package:active_ecommerce_flutter/data_model/cart_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/dashboard/model/dashboard_model.dart';
import 'package:active_ecommerce_flutter/screens/dashboard/routes/dashboard_pages.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final List<DashboardNavModel> navItems = DashboardNavRoutes.routes;

  final RxBool showFloatingButton = true.obs;

  final RxInt currentNavIndex = 0.obs;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<NavigatorState> menuKey = Get.nestedKey(1);

  String initialRoute = Routes.HOME;

  GetPageRoute onGenerateRoute(RouteSettings settings) {
    return PredictPage(
      routes: DashboardNavModel.routes,
      settings: settings,
    ).getPage();
  }

  void processRouting(Routing route) {
    String url = route.route?.settings?.name ?? '';
    Get.routing.current = url;
    Get.log("Cerrent menu : $url");
  }

  RxList _cartList = [].obs;
  RxInt totalCartItems = 0.obs;

  Future<void> fetchCartData() async {
    await CartRepository()
        .getCartResponseList(user_id.$)
        .then((List cartResponseList) {
      if (cartResponseList != null && cartResponseList.length > 0) {
        _cartList.clear();
        _cartList.addAll(cartResponseList);

        if (_cartList.isNotEmpty) {
          for (var _item in _cartList) {
            if (_item.cart_items.length > 0) {
              totalCartItems(_item.cart_items.length);
            }
          }
        }
      }
    });
  }

  void changeTab(int index) {
    if (is_logged_in.$ == true) {
      currentNavIndex(index);
      Get.offNamed(
        navItems[currentNavIndex.value].page.name,
        id: 1,
      );
    } else {
      if (index == 2 || index == 3) {
        Get.to(() => Login());
      } else {
        currentNavIndex(index);
        Get.offNamed(
          navItems[currentNavIndex.value].page.name,
          id: 1,
        );
      }
    }
  }

  void handleBackPressed() {
    Get.back(id: 1);
  }

  Future<bool> handleDeviceBackButton() async {
    bool sholdBack = false;
    if (currentNavIndex.value == 0) {
      if (Get.currentRoute != Routes.HOME) {
        handleBackPressed();
      } else {
        sholdBack = true;
      }
    } else {
      handleBackPressed();
    }
    return sholdBack;
  }
}

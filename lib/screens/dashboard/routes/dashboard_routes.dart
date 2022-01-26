part of 'dashboard_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();

  static const NOT_FOUND = _Paths.NOT_FOUND;
  static const HOME = _Paths.HOME;
  static const CART = _Paths.CART;
  static const PROFILE = _Paths.PROFILE;
  static const CATEGORIES = _Paths.CATEGORIES;

  static const TOP_SELLERS = HOME + _Paths.TOP_SELLERS;
  static const TOP_CATEGORIES = HOME + _Paths.TOP_CATEGORIES;
  static const TOP_BRANDS = HOME + _Paths.TOP_BRANDS;
  static const TOP_DEALS = HOME + _Paths.TOP_DEALS;
  static const FLASH_DEALS = HOME + _Paths.FLASH_DEALS;

  static const _SUB_MENU = _Paths.SUB_MENU;
  // ignore: non_constant_identifier_names
  static String SUB_MENU(String _fromRoute) => '$_fromRoute$_SUB_MENU';

  static const _PRODUCT_DETAILS = _Paths.PRODUCT_DETAILS;
  // ignore: non_constant_identifier_names
  static PRODUCT_DETAILS(String fromRoute) => '$fromRoute$_PRODUCT_DETAILS';
}

abstract class _Paths {
  static const NOT_FOUND = '/not-found';
  static const HOME = '/home';
  static const CART = '/cart';
  static const PROFILE = '/profile';
  static const CATEGORIES = '/categories';
  static const TOP_SELLERS = '/top-sellers';
  static const TOP_CATEGORIES = '/top-categories';
  static const TOP_BRANDS = '/top-brands';
  static const TOP_DEALS = '/top-deals';
  static const FLASH_DEALS = '/flash-deals';
  static const SUB_MENU = '/sub-menu';
  static const PRODUCT_DETAILS = '/product_details';
}

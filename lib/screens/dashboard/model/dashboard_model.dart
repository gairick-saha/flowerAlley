import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DashboardNavModel {
  static final Map<String, GetPage> routes = {};
  final String title;
  final IconData icon;
  final GetPage page;

  DashboardNavModel({
    @required this.title,
    @required this.icon,
    @required this.page,
  }) {
    routes[page.name] = page;
  }
}

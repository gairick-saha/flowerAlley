import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class BottomNavBarItem {
  final String title;
  final IconData icon;

  BottomNavBarItem({
    @required this.title,
    @required this.icon,
  });
}

class BottomNavBar extends StatelessWidget {
  final int currentNavIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavBarItem> items;
  final bool showFloatingButton;
  final int cartCount;

  const BottomNavBar({
    Key key,
    this.currentNavIndex = 0,
    this.onTap,
    this.items = const [],
    this.showFloatingButton = false,
    this.cartCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: showFloatingButton
          ? const CircularNotchedRectangle()
          : BottomAppBarTheme.of(context).shape,
      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: showFloatingButton
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavBarItem(
              context,
              icon: items[0].icon,
              label: items[0].title,
              color: currentNavIndex == 0
                  ? Theme.of(context).indicatorColor
                  : Theme.of(context).disabledColor,
              onPressed: () {
                onTap(0);
              },
            ),
            _buildNavBarItem(
              context,
              icon: items[1].icon,
              label: items[1].title,
              color: currentNavIndex == 1
                  ? Theme.of(context).indicatorColor
                  : Theme.of(context).disabledColor,
              onPressed: () {
                onTap(1);
              },
            ),
            Visibility(
              visible: showFloatingButton,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            _buildNavBarItem(
              context,
              icon: items[2].icon,
              label: items[2].title,
              color: currentNavIndex == 2
                  ? Theme.of(context).indicatorColor
                  : Theme.of(context).disabledColor,
              onPressed: () {
                onTap(2);
              },
              showBadge: true,
            ),
            _buildNavBarItem(
              context,
              icon: items[3].icon,
              label: items[3].title,
              color: currentNavIndex == 3
                  ? Theme.of(context).indicatorColor
                  : Theme.of(context).disabledColor,
              onPressed: () {
                onTap(3);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(
    BuildContext context, {
    @required IconData icon,
    @required VoidCallback onPressed,
    String label,
    @required Color color,
    bool showBadge = false,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      disabledElevation: 0,
      highlightElevation: 0,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      disabledColor: Colors.transparent,
      highlightColor: Colors.transparent,
      colorBrightness: Theme.of(context).brightness,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            showBadge && cartCount != 0
                ? Badge(
                    badgeContent: Text(
                      '$cartCount',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    animationType: BadgeAnimationType.scale,
                    animationDuration: kThemeAnimationDuration,
                    child: Icon(
                      icon,
                      size: 24,
                      color: color,
                    ),
                  )
                : Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
            Text(
              label ?? '',
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

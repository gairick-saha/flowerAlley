import 'package:flutter/material.dart';

class ContentTitle extends StatelessWidget {
  final String title;
  final double topSpacing;
  final double bottomSpacing;
  final bool centerTitle;
  final bool isSliverItem;
  final VoidCallback onPressed;

  const ContentTitle({
    Key key,
    @required this.title,
    @required this.topSpacing,
    @required this.bottomSpacing,
    this.centerTitle = false,
    this.isSliverItem = true,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return isSliverItem
        ? SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: _size.width * 0.05,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: centerTitle
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: topSpacing,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Visibility(
                        visible: onPressed != null,
                        child: GestureDetector(
                          onTap: onPressed,
                          child: Text(
                            'View All',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: bottomSpacing,
                  ),
                ],
              ),
            ),
          )
        : Column(
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: topSpacing,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Visibility(
                    visible: onPressed != null,
                    child: GestureDetector(
                      onTap: onPressed,
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.button?.copyWith(
                              color: Theme.of(context).disabledColor,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: bottomSpacing,
              ),
            ],
          );
  }
}

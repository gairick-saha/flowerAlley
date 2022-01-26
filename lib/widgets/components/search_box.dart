import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Filter();
      })),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: MyTheme.textfield_grey,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.search,
                color: MyTheme.textfield_grey,
                size: 20,
              ),
              SizedBox.square(
                dimension: 5.0,
              ),
              Text(
                AppLocalizations.of(context).home_screen_search,
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 12.0,
                  color: MyTheme.textfield_grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

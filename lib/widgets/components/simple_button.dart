import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const SimpleButton({
    Key key,
    @required this.buttonText,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).buttonTheme.colorScheme?.primary,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
      ),
      height: MediaQuery.of(context).size.height * 0.056,
      minWidth: double.maxFinite,
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.button?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

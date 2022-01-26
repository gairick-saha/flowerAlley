import 'package:flutter/material.dart';
import 'package:progress_loading_button/progress_loading_button.dart';

class AnimatedSubmitButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color color;
  const AnimatedSubmitButton({
    Key key,
    @required this.buttonText,
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingButton(
        defaultWidget: Text(
          buttonText,
          style: Theme.of(context).textTheme.button?.copyWith(
                fontSize: 16,
                color: Theme.of(context).secondaryHeaderColor,
              ),
        ),
        loadingWidget: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        color: onPressed == null
            ? Theme.of(context).disabledColor
            : color ?? Theme.of(context).primaryColor,
        type: LoadingButtonType.Raised,
        height: MediaQuery.of(context).size.height * 0.056,
        onPressed: onPressed,
      ),
    );
  }
}

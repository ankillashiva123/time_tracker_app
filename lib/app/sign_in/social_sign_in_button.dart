import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/custom_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    String assetName,
    String text,
    Color color,
    Color textColor,
    double height,
    VoidCallback onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              Opacity(opacity: 0.0, child: Image.asset(assetName)),
            ],
          ),
          color: color,
          height: height,
          onPressed: onPressed,
        );
}

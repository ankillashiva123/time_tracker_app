import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/custom_widgets/custom_raised_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    String text,
    Color color,
    Color textColor,
    double height,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          height: height,
          onPressed: onPressed,
        );
}

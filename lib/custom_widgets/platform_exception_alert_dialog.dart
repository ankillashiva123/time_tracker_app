import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_alert_dialog.dart';
import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatFormAlertDialog {
  PlatformExceptionAlertDialog({@required String title, @required FirebaseException exception
  }) : super(
    title: title,
    content: exception.message,
    defaultActionText: 'OK',
  );
  static String _message(FirebaseAuthException exception) {
    return exception.message;
  }
  static Map<String,String> _errors = {

};
}
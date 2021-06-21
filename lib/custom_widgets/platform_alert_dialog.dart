import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_widjets.dart';

class PlatFormAlertDialog extends PlatformWidjets {
  PlatFormAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;
  Future<bool> show(BuildContext context) async {
    return Platform.isIOS ? await showCupertinoDialog<bool>(context: context, builder: (content) => this)
     : await showDialog<bool>(context: context, builder: (content) => this);
  }
  @override
  Widget buildCupertinoWidjet(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget builtMaterialWidjet(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions:_buildActions(context),
    );
  }
  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if(cancelActionText != null) {
      actions.add(
        PlatformAlertDialogueAction(
          child: Text(cancelActionText),
          onPressed : () => Navigator.of(context).pop(false),
        ),
      );
    }

    actions.add(
      PlatformAlertDialogueAction(
        child: Text(defaultActionText),
        onPressed : () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}
class PlatformAlertDialogueAction extends PlatformWidjets {
  PlatformAlertDialogueAction({ this.child, this.onPressed });
  final Widget child;
  final VoidCallback onPressed;
  @override
  Widget buildCupertinoWidjet(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,

    );
  }

  @override
  Widget builtMaterialWidjet(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,

    );
  }
}

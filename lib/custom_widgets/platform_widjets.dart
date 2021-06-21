
import 'dart:io';

import 'package:flutter/material.dart';
abstract class PlatformWidjets extends StatelessWidget {
  Widget buildCupertinoWidjet(BuildContext context);
  Widget builtMaterialWidjet(BuildContext context);
  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS) {
  return buildCupertinoWidjet(context);

    } else {
      return builtMaterialWidjet(context);
    }
  }
}

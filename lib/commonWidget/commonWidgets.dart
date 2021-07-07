import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui' as ui;

class CommonWidgets{

customToast(String toastMessage,Color toastColor){

  Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: toastColor,
      textColor: Colors.white,
      fontSize: 16.0);

}

Widget backdropFilterExample(BuildContext context, Widget child) {
  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      child,
      BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 2.0,
          sigmaY: 2.0,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ],
  );
}

}

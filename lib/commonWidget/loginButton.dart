import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String butonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const LoginButton(
      {Key key,
      @required this.butonText,
      this.buttonColor: Colors.pink,
      this.textColor: Colors.white,
      this.radius: 17,
      this.yukseklik: 45,
      this.buttonIcon,
      this.onPressed})
      : assert(butonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      child: SizedBox(
        height: yukseklik,
        child: RaisedButton(
          color: buttonColor,
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buttonIcon != null
                  ? Opacity(opacity: 0, child: buttonIcon)
                  : Container(),
              Text(
                butonText,
                style: TextStyle(fontSize: 20, color: textColor),
              ),
              buttonIcon != null ? buttonIcon : Container(),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}

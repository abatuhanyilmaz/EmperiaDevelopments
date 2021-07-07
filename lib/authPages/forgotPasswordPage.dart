import 'package:empire_developments/commonWidget/commonWidgets.dart';
import 'package:empire_developments/commonWidget/loginButton.dart';
import 'package:empire_developments/services/firebaseAuthServices.dart';
import 'package:empire_developments/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _email;
  bool _enabled = false;
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  CommonWidgets commonWidgets=CommonWidgets();
  AuthServices authServices=AuthServices();
  ConstantColors constantColors=ConstantColors();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 23.0, left: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 28,
                    color: constantColors.primaryBlueColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              alignment: Alignment.topLeft,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Şifremi Unuttum",
                style: TextStyle(fontSize: 25, color: constantColors.primaryBlueColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  showCursor: false,
                  validator: validateEmail,
                  onTap: () {
                    setState(() {
                      _enabled = true;
                    });
                  },
                  onSaved: (String girilenEmail) {
                    _email = girilenEmail;
                  },


                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: constantColors.primaryBlueColor,width: 1.2),
                        borderRadius: BorderRadius.circular(30)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(30)),
                    //

                    prefixIcon: Icon(
                      Icons.mail,
                      color:
                      _enabled == true ? Colors.red : Colors.black87,
                      size: 26,
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100.0, right: 100, top: 10),
              child: LoginButton(
                butonText: "Şifreyi Sıfırla",

                buttonColor: constantColors.primaryBlueColor,
                radius: 20,
                onPressed: () {
                  _formSubmit();
                  setState(() {
                    _validate = true;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _formSubmit() async {
    _formKey.currentState.save();
    print("email :" + _email);
    try {
      var sonuc = await authServices.forgotpassword(
        _email,
      );
      if (sonuc == true) {
        print("şifre sıfırlama emaili gonderildi");

        commonWidgets.customToast("Şifre sıfırlama e-postası ${_email} adresine gönderildi", Colors.greenAccent[700]);


      }
    }  catch (e) {
print("widget sifre unuttum hata $e");

    }
  }

  String validateEmail(String _email) {
    if ((_email.length == 0)) {
      return "Bu alan boş olamaz";
    } else if ((!_email.contains('@'))) {
      return "Geçersiz Email Adresi";
    }

    return null;
  }
}
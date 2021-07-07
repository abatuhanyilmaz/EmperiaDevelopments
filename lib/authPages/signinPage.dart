import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:empire_developments/commonWidget/commonWidgets.dart';
import 'package:empire_developments/commonWidget/loginButton.dart';
import 'package:empire_developments/model/userModel.dart';
import 'package:empire_developments/services/firebaseAuthServices.dart';
import 'package:empire_developments/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import 'forgotPasswordPage.dart';

enum FormType { Register, Login }

class SigninPage extends StatefulWidget {
 var  formTypeWidget;
 SigninPage({this.formTypeWidget});
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  var _formType ;


  final _formKey = GlobalKey<FormState>();
  String _email, _sifre;
  String _buttonText, _linkText;
  bool _obscure = true;

  bool _validate = false;

  double height, width;
  ConstantColors constantColors = ConstantColors();
  CommonWidgets commonWidgets = CommonWidgets();
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formType=widget.formTypeWidget=="true"?FormType.Login:FormType.Register;



  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _buttonText = _formType == FormType.Login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.Login
        ? "Yeni Hesap Oluşturun"
        : "Hesabın var mı ? Giriş Yap";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            child: commonWidgets.backdropFilterExample(
                context,
                Image(
                  image: AssetImage("assets/signinback.jpeg"),
                  fit: BoxFit.cover,
                )),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  autovalidate: _validate,
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 4, left: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Image(
                            image: AssetImage("assets/logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),

                        Container(
                            child: Text(
                          "Hoş geldiniz.",
                          style: TextStyle(
                              fontSize: 29,
                              color: Colors.black87,
                              fontFamily: 'Muli',fontWeight: FontWeight.w500),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 8, top: 25),
                          child: TextFormField(
                            validator: validateEmail,
                            onSaved: (String email) {
                              _email = email;
                            },

                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: Colors.white70,
                              filled: true,
                              hintText: "Email",

                              hintStyle: TextStyle(color: Colors.black87),
                              prefixIcon: Icon(CupertinoIcons.mail),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: constantColors.primaryBlueColor,
                                      width: 2.2)),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.redAccent[700],
                                    width: 2.2,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.redAccent[700],
                                fontWeight: FontWeight.w600,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.5, 0.1),
                                    blurRadius: 2.0,
                                    color: Colors.white,
                                  ),
                                  Shadow(
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 3.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.2,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onSaved: (String password) {
                              _sifre = password;
                            },
                            obscureText: _obscure,
                            validator: validatePassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                CupertinoIcons.padlock,
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700],
                                  fontWeight: FontWeight.w600,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(0.5, 0.1),
                                      blurRadius: 2.0,
                                      color: Colors.white,
                                    ),
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 3.0,
                                      color: Colors.white,
                                    ),
                                  ]),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.redAccent[700],
                                      width: 2.2,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(20)),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscure = !_obscure;
                                  });
                                },
                                child: Icon(
                                  !_obscure
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                  color: !_obscure
                                      ? Colors.blueAccent[700]
                                      : Colors.grey[800],
                                  size: 26,
                                ),
                              ),
                              hintText: "Şifre",
                              hintStyle: TextStyle(color: Colors.black87),
                              fillColor: Colors.white70,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: constantColors.primaryBlueColor,
                                      width: 2.2)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2.2,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                "Şifremi Unuttum",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0.5, 0.1),
                                    blurRadius: 2.0,
                                    color: Colors.white,
                                  ),
                                  Shadow(
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 2.5,
                                    color: Colors.white,
                                  ),
                                ]),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(PageTransition(
                                  child: ForgotPasswordPage(),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 180),
                                  reverseDuration: Duration(milliseconds: 250),
                                ));
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, top: 5, bottom: 10),
                          child: LoginButton(
                            butonText: _buttonText,
                            buttonColor: Colors.tealAccent[700],
                            radius: 20,
                            onPressed: () {
                              _formSubmit();
                              setState(() {
                                _validate = true;
                              });
                            },
                          ),
                        ),
                        FlatButton(
                          onPressed: () => degistir(),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: Text(
                            _linkText,
                            style: TextStyle(fontSize: 19, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void degistir() {
    setState(() {
      _formType =
          _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  Future<void> _formSubmit() async {
    _formKey.currentState.save();

    if (_formType == FormType.Register) {

      try {
        bool girisBasarilmi = await authServices.register(_email, _sifre);

        if (girisBasarilmi) {
          User currentuser =  authServices.currentUserTwo();

          Users user =await  getUser(currentuser.uid);

          // Navigator.of(context).pushReplacement(PageTransition(
          //   child: CustomerConfigirationDetailPage(height: height,),
          //   type: PageTransitionType.rightToLeft,
          //   duration: Duration(milliseconds: 180),
          //   reverseDuration: Duration(milliseconds: 200),
          // ));

          print(" kayıt olma işlem başarılı");
        }
      } catch (e) {
        debugPrint("Widget oturum acama  hata " + e.code.toString());
      }
    } else {
      try {
        bool girisBasarilimi = await authServices.signIn(_email, _sifre);
        if (girisBasarilimi) {
          User currentUser =  authServices.currentUserTwo();
          Users user =await  getUser(currentUser.uid);
          print("gelen user :$user");

          // Navigator.of(context).pushReplacement(
          //   PageTransition(
          //     child: CustomerConfigirationDetailPage(height: height,),
          //     type: PageTransitionType.rightToLeft,
          //     duration: Duration(milliseconds: 180),
          //     reverseDuration: Duration(milliseconds: 200),
          //   ),
          // );
        }
      } catch (e) {
        print("giris yaparken hata oluştu $e");
      }
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

  String validatePassword(String _sifre) {
    if ((_sifre.length < 6)) {
      return "En az 6 karakter olmalı";
    }

    return null;
  }

  Future<Users> getUser(String uid) async {
  DocumentSnapshot snapshot= await  FirebaseFirestore.instance.collection("users").doc(uid).get();
    Users users =Users.fromMap(snapshot.data());
  return users;

  }
}

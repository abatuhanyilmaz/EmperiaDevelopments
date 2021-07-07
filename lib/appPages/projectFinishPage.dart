import 'package:empire_developments/authPages/signinPage.dart';
import 'package:empire_developments/commonWidget/commonWidgets.dart';
import 'package:empire_developments/services/firebaseAuthServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ProjectFinishPage extends StatefulWidget {
  @override
  _ProjectFinishPageState createState() => _ProjectFinishPageState();
}

class _ProjectFinishPageState extends State<ProjectFinishPage> {
  AuthServices authServices = AuthServices();

  CommonWidgets commonWidgets = CommonWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(backgroundColor: Colors.transparent, actions: [
      //   IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () async {
      //         var cikisYapidliMi = await authServices.signOut();
      //         if (cikisYapidliMi) {
      //           Navigator.of(context).pushReplacement(PageTransition(
      //             child: SigninPage(
      //               formTypeWidget: FormType.Login,
      //             ),
      //             type: PageTransitionType.leftToRight,
      //             duration: Duration(milliseconds: 180),
      //             reverseDuration: Duration(milliseconds: 200),
      //           ));
      //         } else {}
      //       }),
      // ]),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              commonWidgets.backdropFilterExample(
                  context,
                  Image.asset(
                    "assets/finish.jpg",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
,
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: IconButton(
                            icon: Icon(Icons.logout,color: Colors.white,),
                            onPressed: () async {
                              var cikisYapidliMi = await authServices.signOut();
                              if (cikisYapidliMi) {
                                Navigator.of(context).pushReplacement(PageTransition(
                                  child: SigninPage(
                                    formTypeWidget: FormType.Login,
                                  ),
                                  type: PageTransitionType.leftToRight,
                                  duration: Duration(milliseconds: 180),
                                  reverseDuration: Duration(milliseconds: 200),
                                ));
                              } else {}
                            }),
                      ),],
                  ),
                ),
              ),
              Align(

                child: Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: Container(
                    child: Text(
                      "Yeni eviniz hayırlı olsun! Seçtiğiniz ürünlerle yuvanızı hazırlıyoruz.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.5, 0.1),
                              blurRadius: 2.0,
                              color: Colors.black87,
                            ),
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 3.0,
                              color: Colors.black87,
                            ),
                          ]),
                    ),
                  ),
                ),
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

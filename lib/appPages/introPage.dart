import 'package:empire_developments/authPages/signinPage.dart';
import 'package:empire_developments/commonWidget/commonWidgets.dart';
import 'package:empire_developments/commonWidget/loginButton.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:page_transition/page_transition.dart';
enum FormType { Register, Login }

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<PageViewModel> pages = [];
  CommonWidgets commonWidgets = CommonWidgets();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      PageViewModel(
        pageBackground: commonWidgets.backdropFilterExample(
            context,
            Container(
              child: Image.asset(
                "assets/signinbackground.jpg",
                fit: BoxFit.cover,
              ),
              height: MediaQuery.of(context).size.height,
            )),

        // iconImageAssetPath: 'assets/air-hostess.png',
        body: const Text(
          "Emperia Developments'ın dijital atılımı Güzel Evim uygulamasına hoş geldiniz.",
          style: TextStyle(shadows: <Shadow>[
            Shadow(
              offset: Offset(0.5, 0.1),
              blurRadius: 2.0,
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(0.5, 0.5),
              blurRadius: 3.0,
              color: Colors.black,
            ),
          ], color: Colors.white),
        ),
        title: const Text(
          'Hoş geldiniz.',
          style: TextStyle(fontSize: 40),
        ),
        titleTextStyle:
            const TextStyle(fontFamily: 'MyFont', color: Colors.white),
        bodyTextStyle:
            const TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset(
          'assets/signinbackground.jpg',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
      ),
      PageViewModel(
        body: const Text(
          'Yeni evinizi tasarlamaya hazır mısınız?',
        ),
        pageBackground: commonWidgets.backdropFilterExample(
          context,
          Container(
            child: Image.asset(
              "assets/formbackgroundtwo.jpg",
              fit: BoxFit.cover,
            ),
            height: MediaQuery.of(context).size.height,
          ),
        ),
        // title: const Text('Hotels'),
        mainImage: Image.asset(
          'assets/formbackgroundtwo.jpg',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        titleTextStyle:
            const TextStyle(fontFamily: 'Muli', color: Colors.white),
        bodyTextStyle: const TextStyle(fontFamily: 'Muli', color: Colors.white),
      ),
      PageViewModel(
        pageBackground: commonWidgets.backdropFilterExample(
          context,
          Container(
            child: Image.asset(
              "assets/formbackground.jpg",
              fit: BoxFit.cover,
            ),
            height: MediaQuery.of(context).size.height,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 50.0, right: 50, top: 30, bottom: 5),
              child: LoginButton(
                yukseklik: 40.0,
                butonText: "Giriş Yap",
                buttonColor: Colors.tealAccent[700],
                radius: 20,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: SigninPage(formTypeWidget:"true"),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 220),
                      reverseDuration: Duration(milliseconds: 250),
                    ),
                  );

                },
              ),
            )
          ,  FlatButton(
              onPressed: (){

                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: SigninPage(formTypeWidget:"false"),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 220),
                    reverseDuration: Duration(milliseconds: 250),
                  ),
                );
              },
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
              child: Text(
                "Kayıt Ol",
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
            )

          ],
        ),
        mainImage: Image.asset(
          'assets/formbackground.jpg',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        titleTextStyle:
            const TextStyle(fontFamily: 'MyFont', color: Colors.white),
        bodyTextStyle:
            const TextStyle(fontFamily: 'MyFont', color: Colors.white),
      ),
    ];
    return Scaffold(
      body: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showBackButton: true,
          backText: Text("GERİ"),
          skipText: Text("ATLA"),
          doneText: SizedBox(),
          onTapDoneButton: () {
            // Use Navigator.pushReplacement if you want to dispose the latest route
            // so the user will not be able to slide back to the Intro Views.
            // Navigator.push(
            //   context,
            //   PageTransition(
            //     child: SigninPage(),
            //     type: PageTransitionType.rightToLeft,
            //     duration: Duration(milliseconds: 220),
            //     reverseDuration: Duration(milliseconds: 250),
            //   ),
            // );
          },
          pageButtonTextStyles: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

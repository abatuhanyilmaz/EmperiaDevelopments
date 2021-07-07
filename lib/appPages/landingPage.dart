import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_developments/appPages/customerConfigDetailPage.dart';
import 'package:empire_developments/authPages/signinPage.dart';
import 'package:empire_developments/model/userModel.dart';
import 'package:empire_developments/services/firebaseAuthServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'homePage.dart';
import 'introPage.dart';
//Oturum açma durumuna göre sayfa yönlendirme

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AuthServices authServices = AuthServices();
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    print("current user çağırıldı");
  }

  Future<Users> getUser(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      Users users = Users.fromMap(snapshot.data());

      return users;
    } catch (e) {
      print("get user error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Text("Hata Oluştu ${snapshot.error}"),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              FirebaseAuth.instance.authStateChanges().listen((User user) {
                if (user == null) {
                  _navigatorKey.currentState.pushReplacement(PageTransition(
                    child: IntroPage(),


                    //SigninPage(),
                    type: PageTransitionType.leftToRight,
                    duration: Duration(milliseconds: 180),
                    reverseDuration: Duration(milliseconds: 200),
                  ));
                } else {
                  _navigatorKey.currentState.pushReplacement(PageTransition(
                    child: CustomerConfigirationDetailPage(
                      height: heightAta(),fromArrwoBack: false,
                    ),
                    type: PageTransitionType.leftToRight,
                    duration: Duration(milliseconds: 180),
                    reverseDuration: Duration(milliseconds: 200),
                  ));
                }
              });
//               StreamBuilder(
//                 stream: FirebaseAuth.instance.authStateChanges(),
//                 builder: (BuildContext context, snapshotStream) {
//           if
//           // (snapshot.connectionState ==
//           //             ConnectionState.done)
//           //
//           (snapshotStream.hasData)
//
//           {
//             print("snpashot da data var");
//                     User user = snapshotStream.data;
//
//                     if (user == null) {
//                       print("user null signine girdi");
//                       return SigninPage();
//                     } else {
//
//                       print("user var customer page e girdi");
//
//                     return    CustomerConfigirationDetailPage(
//                         height: heightAta(),
//                       );
// //                       return StreamBuilder(
// //                           stream: future(user),
// //                           builder: (context,  snapUser) {
// //                             if (snapUser.hasData) {
// // DocumentSnapshot documentSnapshot;
// // documentSnapshot=snapUser.data;
// //                               Users users =
// //                                   Users.fromMap(documentSnapshot.data());
// //                               print(users.customerName);
// //                               if (users != null) {
// //                              if(users.userWritedInfo==true){
// //                               return HomePage(users);
// //                              }else{
// //                                return CustomerConfigirationDetailPage(
// //                                  height: heightAta(),
// //                                  user: users,
// //                                );
// //                              }
// //                               }
// //                             }else{
// //                               print("data yok");
// //                             }
// //
// //                               // return Container(
// //                               //     color: Colors.white,
// //                               //     child: Column(
// //                               //       mainAxisAlignment: MainAxisAlignment.center,
// //                               //       children: [
// //                               //         Image(image: AssetImage("assets/logo.png")),
// //                               //         CircularProgressIndicator(),
// //                               //       ],
// //                               //     ));
// //                             }
// //                           );
//
//                     }
//                   }else{
//             print("data yok");
//             print(snapshotStream);
//           }
//
//                   return Container(
//                                   color: Colors.redAccent,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Image(image: AssetImage("assets/logo.png")),
//                                       CircularProgressIndicator(),
//                                     ],
//                                   ));
//                 });
            }

            return Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage("assets/logo.png")),
                    CircularProgressIndicator(),
                  ],
                ));
          }),
    );
  }

  heightAta() {
    return MediaQuery.of(context).size.height;
  }

  future(user) {
    try {
      Stream<DocumentSnapshot> stream;
      stream = FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .snapshots();
      return stream;
    } catch (e) {
      print(e);
    }
  }
}

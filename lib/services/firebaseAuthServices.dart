import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_developments/commonWidget/commonWidgets.dart';
import 'package:empire_developments/model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Auth işlemlerinin yapıldığı services

class AuthServices {
  CommonWidgets commonWidgets = CommonWidgets();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print("oturum acmada  sorun cıktı $e }");
      if (e != null) {
        print("error code :" + e.code.toString());
        commonWidgets.customToast(
            Hatalar.goster(e.code) == null
                ? "Problem Çıktı"
                : Hatalar.goster(e.code),
            Colors.redAccent);
      } else {
        print("my hata null auth services");
      }

      return false;
    }
  }

  Future register(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = FirebaseAuth.instance.currentUser;
      var deger = await userCreateFireStore(user);
      if (deger) {
        print("data firestore a kaydedildi");
      } else {
        print("firestore a yazılırken hata cıktı");
      }
      return true;
    } catch (e) {
      if (e != null) {
        print("error code : ${e.code}");
        commonWidgets.customToast(
            Hatalar.goster(e.code) == null
                ? "Problem Çıktı"
                : Hatalar.goster(e.code),
            Colors.redAccent);
      } else {
        print("my hata null auth services");
      }

      return false;
    }
  }

  currentUser() {
    User gelenUser;

    _firebaseAuth.authStateChanges().listen((user) {
      if (user == null) {
        gelenUser = user;
      } else {
        print('User is  in!');
        gelenUser = user;
        print("gelen user elseten $gelenUser");
      }
    });
    print("returnden once gleen user $gelenUser");
    return gelenUser;
  }

  currentUserTwo()  {
    User gelenUser =  _firebaseAuth.currentUser;
    return gelenUser;
  }

  forgotpassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      if (e != null) {
        print("error code : ${e.code}");
        commonWidgets.customToast(
            Hatalar.goster(e.code) == null
                ? "Problem Çıktı"
                : Hatalar.goster(e.code),
            Colors.redAccent);
      } else {
        print("hata null auth services");
        return false;
      }
    }
  }
  signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      print("error cıktı $e");
      return false;
    }
  }

  userCreateFireStore(User user) async {
    print("user create firestore");
    DocumentSnapshot _okunanUser = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    if (_okunanUser.data() == null) {
      Users users = Users(email: user.email, userID: user.uid);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(users.toMap());

      await FirebaseFirestore.instance
          .collection("item_count")
          .doc("users_count")
          .update({'count': FieldValue.increment(1)});
      return true;
    } else {
      print("oyle bir kullanıcı var o yüzden oluşturulamadı");
      return false;
    }
  }
}

class Hatalar {
  static String goster(String errorCode) {
    switch (errorCode) {
      case 'ERROR_INVALID_EMAIL':
        return "Geçersiz mail adresi";
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Bu mail adresi zaten kullanımda.";

      case 'weak-password':
        return "Güçsüz Şifre";

      case 'user-not-found':
        return "Böyle bir mail adresi kayıtlı değil";

      case 'invalid-email':
        return "Geçersiz mail adresi";
      case 'email-already-in-use':
        return "Bu mail adresi zaten kullanımda";

      case 'ERROR_USER_NOT_FOUND':
        return "  Böyle bir mail adresi kayıtlı değil";

      case 'ERROR_NETWORK_REQUEST_FAILED':
        return "İnternetiniz yok lütfen internet bağlantınızı kontrol edin !!";
      case 'network-request-failed':
        return "İnternetiniz yok lütfen internet bağlantınızı kontrol edin !!";

      case 'ERROR_WRONG_PASSWORD':
        return "Şifre veya email hatalı kontrol edin";
      case 'wrong-password':
        return "Şifre veya email hatalı kontrol edin";
      case 'wrong-email':
        return "email veya şifre hatalı kontrol edin";
      case 'ERROR_USER_DISABLED':
        return "Uygulamadan banlandınız !!.Muhtemelen yanlış birşeyler yaptınız (küfür,hakaret,sözlü taciz ,alay)";
      case 'user-disabled':
        return "Uygulamadan banlandınız !!.Muhtemelen yanlış birşeyler yaptınız";

      case 'ERROR_TOO_MANY_REQUESTS':
        return 'Olağandışı etkinlik nedeniyle(fazla hatalı deneme) bu cihazdan gelen tüm istekleri engelledik. Daha sonra tekrar deneyin.';

      case 'too-many-requests':
        return 'Olağandışı etkinlik nedeniyle(fazla hatalı deneme) bu cihazdan gelen tüm istekleri engelledik. Daha sonra tekrar deneyin.';
    }
  }
}

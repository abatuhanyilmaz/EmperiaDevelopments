import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_developments/commonWidget/commonWidgets.dart';
import 'package:empire_developments/commonWidget/loginButton.dart';
import 'package:empire_developments/model/categoryModel.dart';
import 'package:empire_developments/model/kidsModel.dart';
import 'package:empire_developments/model/userModel.dart';
import 'package:empire_developments/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'customerQuestionDetail.dart';
import 'homePage.dart';

class CustomerConfigirationDetailPage extends StatefulWidget {
  final height;
  bool fromArrwoBack;

//  final Category category;

  CustomerConfigirationDetailPage({this.height, this.fromArrwoBack
      //  this.category
      });

  @override
  _CustomerConfigirationDetailPage createState() =>
      _CustomerConfigirationDetailPage();
}

class _CustomerConfigirationDetailPage
    extends State<CustomerConfigirationDetailPage> {
  // Kids kids = Kids();

  TextEditingController dogumTarihiController = TextEditingController();
  TextEditingController adSoyadController = TextEditingController();
  TextEditingController meslekController = TextEditingController();
  TextEditingController konutController = TextEditingController();
  TextEditingController esAdsoyadController = TextEditingController();
  TextEditingController cocukSayisiController = TextEditingController();
  TextEditingController cocukAdController1 = TextEditingController();
  TextEditingController cocukAdController2 = TextEditingController();
  TextEditingController cocukAdController3 = TextEditingController();
  TextEditingController cocukAdController4 = TextEditingController();
  TextEditingController cocukAdController5 = TextEditingController();
  TextEditingController cocukAdController6 = TextEditingController();
  TextEditingController cocukAdController7 = TextEditingController();
  TextEditingController cocukYasController1 = TextEditingController();
  TextEditingController cocukYasController2 = TextEditingController();
  TextEditingController cocukYasController3 = TextEditingController();
  TextEditingController cocukYasController4 = TextEditingController();
  TextEditingController cocukYasController5 = TextEditingController();
  TextEditingController cocukYasController6 = TextEditingController();
  TextEditingController cocukYasController7 = TextEditingController();
  Set set = Set();

  List<Set> setList = [];
  CommonWidgets commonWidgets = CommonWidgets();
  ConstantColors constantColors = ConstantColors();
  bool cocukVar = true;
  bool autoValidate = false;
  String radioButtonItem = 'EVLİ';
  String radioButtonCocukItem = 'EVET';
  int id = 1;
  int idcocuk = 3;
  String konutNumarasi;
  int cocukSayisi;
  String cocukAdSoyad1;
  String cocukAdSoyad2;
  String cocukAdSoyad3;
  String cocukAdSoyad4;
  String cocukAdSoyad5;
  String cocukAdSoyad6;
  String cocukAdSoyad7;
  double height, width;
  final _formKey = GlobalKey<FormState>();
  String adSoyad;
  String esAdSoyad;
  String meslek;
  String selfDatetime;
  String cocukYas1;
  String cocukYas2;
  String cocukYas3;
  String cocukYas4;
  String cocukYas5;
  String cocukYas6;
  String cocukYas7;
  double containerHeight;
  User currentFirebaseuser;
  Users oturumAcanUser;

  Future<Users> getUser() async {
    try {
      currentFirebaseuser = FirebaseAuth.instance.currentUser;
      print("current firebaeuser ${currentFirebaseuser}");

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentFirebaseuser.uid)
          .get();

      oturumAcanUser = Users.fromMap(snapshot.data());

      if (oturumAcanUser.userWritedInfo == true) {
        print(oturumAcanUser.customerMedeniHal);
        print("have kid" + oturumAcanUser.haveKid);
        adSoyadController.text = oturumAcanUser.customerName;
        dogumTarihiController.text = oturumAcanUser.customerDateOfBirth;
        meslekController.text = oturumAcanUser.customerJob;
        radioButtonItem = oturumAcanUser.customerMedeniHal;
        id = oturumAcanUser.customerMedeniHal == "EVLİ" ? 1 : 2;

        radioButtonCocukItem = oturumAcanUser.haveKid.length == 0
            ? "HAYIR"
            : oturumAcanUser.haveKid == "EVET"
                ? "EVET"
                : "HAYIR";
        konutNumarasi = oturumAcanUser.konutNumara;
        konutController.text = oturumAcanUser.konutNumara;
        cocukVar = oturumAcanUser.haveKid == "EVET" ? true : false;
        idcocuk = oturumAcanUser.haveKid == "EVET" ? 3 : 4;
        esAdsoyadController.text = oturumAcanUser.customerWifeName;
        cocukSayisiController.text = oturumAcanUser.kidsList.length.toString();
        cocukSayisi = oturumAcanUser.kidsList.length;

        Set tekSet = Set();
        for (int i = 0; i < oturumAcanUser.kidsList.length; i++) {
          tekSet = Set.fromMap(oturumAcanUser.kidsList[i]);
          setList.add(tekSet);
        }
        for (int i = 0; i < cocukSayisi; i++) {
          containerHeight += eklenecekSayiAta();
        }

        cocukSayisinaGoreTextFormFieldTextAta();
        setState(() {});

        if (widget.fromArrwoBack == false) {
          await awaitAndGoToNewQuestionPage();
        }
      } else {}
    } catch (e) {
      print("get user error $e");
    }
  }

  @override
  void initState() {
    // TODO: implement
    //  i
    // nitState

    super.initState();
    print("initstate çalışıt");

    containerHeight = widget.height;
    getUserBekle();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose çalıştı");
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SafeArea(
                child: Stack(
                  children: [
                    Container(
                      height:
                          cocukVar == false ? widget.height : containerHeight,
                      child: commonWidgets.backdropFilterExample(
                          context,
                          Image(
                            image: AssetImage("assets/formback.jpeg"),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            autovalidate: autoValidate,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, right: 4, left: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8, top: 5),
                                    child: TextFormField(
                                      validator: adSoyadValidator,
                                      controller: adSoyadController,
                                      onSaved: (String gelenAdSoyad) {
                                        adSoyad = gelenAdSoyad;
                                      },
                                      decoration: InputDecoration(
                                        fillColor: Colors.white70,
                                        filled: true,
                                        hintText: "Ad Soyad",
                                        hintStyle:
                                            TextStyle(color: Colors.black87),
                                        prefixIcon: Icon(
                                          CupertinoIcons.person,
                                          color: Colors.black87,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide(
                                                color: constantColors
                                                    .primaryBlueColor,
                                                width: 2.2)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 8, top: 5),
                                    child: TextFormField(
                                      controller: dogumTarihiController,
                                      validator: validateDogumTarihi,
                                      onSaved: (g) {
                                        selfDatetime = g;
                                      },
                                      onTap: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime(1900, 1, 1),
                                            maxTime: DateTime(2021, 12, 30),
                                            onChanged: (date) {
                                          //  print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
                                            selfDatetime =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(date);
                                            dogumTarihiController.text =
                                                selfDatetime;
                                          });
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.tr);
                                      },
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide(
                                                color: constantColors
                                                    .primaryBlueColor,
                                                width: 2.2)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        fillColor: Colors.white70,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        hintText: "Doğum Tarihi",

                                        hintStyle:
                                            TextStyle(color: Colors.black87),
                                        prefixIcon: Icon(
                                          CupertinoIcons.calendar,
                                          size: 28,
                                          color: Colors.black87,
                                        ),
                                        //enabled: false,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      onSaved: (String gelenMeslek) {
                                        meslek = gelenMeslek;
                                      },
                                      validator: meslekValidator,
                                      controller: meslekController,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            "assets/portfolio.png",
                                            height: 15,
                                            width: 15,
                                          ),
                                        ),
                                        hintText: "Meslek",
                                        hintStyle:
                                            TextStyle(color: Colors.black87),
                                        fillColor: Colors.white70,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide(
                                                color: constantColors
                                                    .primaryBlueColor,
                                                width: 2.2)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      onSaved: (String geleneKonutNo) {
                                        konutNumarasi = geleneKonutNo;
                                      },
                                      validator: konutValidator,
                                      controller: konutController,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.home_work_outlined,
                                            color: Colors.black87,
                                            size: 28,
                                          ),
                                        ),
                                        hintText:
                                            "Kaç numaralı konutu satın aldınız?",
                                        hintStyle:
                                            TextStyle(color: Colors.black87),
                                        fillColor: Colors.white70,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            borderSide: BorderSide(
                                                color: constantColors
                                                    .primaryBlueColor,
                                                width: 2.2)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                  ),
                                  radioGroupsMedeniDurum(),
                                  radioButtonItem == "EVLİ"
                                      ? evliConfigiration()
                                      : bekarConfigiration(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0,
                                        right: 50,
                                        top: 0,
                                        bottom: 5),
                                    child: LoginButton(
                                      butonText: "DEVAM",
                                      buttonColor: Colors.tealAccent[700],
                                      radius: 20,
                                      yukseklik: 50,
                                      buttonIcon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        var dataKaydedildiMi =
                                            await _formSubmit();
                                        setState(() {
                                          autoValidate = true;
                                        });

                                        if (dataKaydedildiMi == true) {
                                          Navigator.of(context).push(
                                              PageTransition(
                                                  child:
                                                      HomePage(oturumAcanUser),
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  reverseDuration: Duration(
                                                      milliseconds: 250)));
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _formSubmit() async {
    _formKey.currentState.save();
    if (oturumAcanUser == null) {
      await getUserBekle();
    }

    if (radioButtonItem == "BEKAR") {
      if (adSoyad != null &&
          adSoyad.length != 0 &&
          selfDatetime != null &&
          selfDatetime.length != 0 &&
          meslek != null &&
          meslek.length != 0) {
        try {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(oturumAcanUser.userID)
              .update({
            "customerName": adSoyad,
            "konutNumara": konutNumarasi,
            "customerDateOfBirth": selfDatetime,
            "customerJob": meslek,
            "customerMedeniHal": radioButtonItem,
            "customerWifeName": "",
            "userWritedInfo": true,
            "haveKid":"HAYIR",
            "kidsList": [],

          });
          return true;
        } catch (e) {
          print("bekar hata : $e");
        }
      } else {
        commonWidgets.customToast("Boş alanlar mevcut !", Colors.redAccent);
      }
    } else {
      if (radioButtonCocukItem == "EVET") {
        print("girilen alan");

        if (adSoyad != null &&
            adSoyad.length != 0 &&
            selfDatetime != null &&
            selfDatetime.length != 0 &&
            meslek != null &&
            meslek.length != 0 &&
            esAdSoyad != null &&
            esAdSoyad.length != 0 &&
            cocukSayisi != null &&
            cocukSayisi.toString().length != 0) {
          try {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(oturumAcanUser.userID)
                .update({
              "customerName": adSoyad,
              "customerDateOfBirth": selfDatetime,
              "customerJob": meslek,
              "konutNumara": konutNumarasi,
              "customerMedeniHal": radioButtonItem,
              "customerWifeName": esAdSoyad,
              "haveKid": radioButtonCocukItem,
              "kidsList": cocukEkle(),
              "userWritedInfo": true,
            });
            return true;
          } catch (e) {
            print("evli ve çocuğu var hata :$e");
          }
        } else {
          commonWidgets.customToast("Boş alanlar mevcut !", Colors.redAccent);
        }
      } else {
        if (adSoyad != null &&
            adSoyad.length != 0 &&
            selfDatetime != null &&
            selfDatetime.length != 0 &&
            meslek != null &&
            meslek.length != 0 &&
            esAdSoyad != null &&
            esAdSoyad.length != 0) {
          try {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(oturumAcanUser.userID)
                .update({
              "customerName": adSoyad,
              "customerDateOfBirth": selfDatetime,
              "customerJob": meslek,
              "konutNumara": konutNumarasi,
              "customerMedeniHal": radioButtonItem,
              "customerWifeName": esAdSoyad,
              "haveKid": radioButtonCocukItem,
              "kidsList": [],
              "userWritedInfo": true,
            });
            return true;
          } catch (e) {
            print("evli cocugu yok hata : $e");
          }
        } else {
          commonWidgets.customToast("Boş alanlar mevcut!", Colors.redAccent);
        }
      }
    }
  }

  radioGroupsMedeniDurum() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 18, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, right: 4),
                  child: Text(
                    'Medeni Haliniz  : $radioButtonItem ',
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Image.asset(
                  "assets/$radioButtonItem.png",
                  height: 30,
                  width: 30,
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8, top: 4),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: 1,
                  groupValue: id,
                  onChanged: (val) {
                    setState(() {
                      radioButtonItem = 'EVLİ';
                      id = 1;
                      cocukVar = true;
                      print("radiobutton item:" + radioButtonItem);
                    });
                  },
                  activeColor: Colors.tealAccent[700],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/EVLİ.png",
                      height: 30,
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '  EVLİ',
                        style: new TextStyle(fontSize: 17.0),
                      ),
                    )
                  ],
                ),
                Radio(
                  value: 2,
                  groupValue: id,
                  onChanged: (val) {
                    setState(() {
                      radioButtonItem = 'BEKAR';
                      id = 2;

                      cocukVar = false;
                    });
                  },
                  activeColor: Colors.tealAccent[700],
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/BEKAR.png",
                      height: 30,
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        ' BEKAR',
                        style: new TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 2, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  evliConfigiration() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: esAdSoyadValidator,
            controller: esAdsoyadController,
            onSaved: (String gelenAdSoyad) {
              esAdSoyad = gelenAdSoyad;
            },
            decoration: InputDecoration(
              fillColor: Colors.white70,
              filled: true,
              hintText: "Eş Ad Soyad",
              hintStyle: TextStyle(color: Colors.black87),
              prefixIcon: Icon(
                CupertinoIcons.person,
                color: Colors.black87,
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                      color: constantColors.primaryBlueColor, width: 2.2)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.2,
                  ),
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          radioGroupsCocukVarMi(),
          radioButtonCocukItem == "EVET" ? cocukSayiChoose() : SizedBox(),
        ],
      ),
    );
  }

  bekarConfigiration() {
    return SizedBox();
  }

  radioGroupsCocukVarMi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Çocuğunuz var mı? : $radioButtonCocukItem  ',
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Image.asset(
                  "assets/$radioButtonCocukItem.png",
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 2, left: 2, top: 4),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Radio(
                  value: 3,
                  groupValue: idcocuk,
                  onChanged: (val) {
                    setState(() {
                      radioButtonCocukItem = 'EVET';
                      idcocuk = 3;
                      cocukVar = true;
                    });
                  },
                  activeColor: Colors.tealAccent[700],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/EVET.png",
                      height: 27,
                      width: 27,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '  EVET',
                        style: new TextStyle(fontSize: 17.0),
                      ),
                    )
                  ],
                ),
                Radio(
                  value: 4,
                  groupValue: idcocuk,
                  onChanged: (val) {
                    setState(() {
                      radioButtonCocukItem = 'HAYIR';
                      idcocuk = 4;
                      setList = [];
                      cocukVar = false;
                    });
                  },
                  activeColor: Colors.tealAccent[700],
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/HAYIR.png",
                      height: 30,
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        ' HAYIR',
                        style: new TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 2, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  cocukSayiChoose() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          TextFormField(
            onSaved: (String gelenCocukSayisi) {
              if (gelenCocukSayisi != null && gelenCocukSayisi.length > 0) {
                cocukSayisi = int.parse(gelenCocukSayisi);
              }
            },
            controller: cocukSayisiController,
            onChanged: (String onChangedValue) {
              if (onChangedValue.isNotEmpty) {
                cocukSayisi = int.parse(onChangedValue);

                if (cocukSayisi < 8 && cocukSayisi != 0) {
                  for (int i = 0; i < cocukSayisi; i++) {
                    containerHeight += eklenecekSayiAta();
                  }
                  setState(() {});
                  print("container height : $containerHeight");
                }
                print("onchanged cocuk sayısı $onChangedValue");
              } else {
                containerHeight = widget.height;
                cocukSayisi = 0;
                setState(() {});
              }
            },
            validator: validateCocukSayisi,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    CupertinoIcons.number,
                    color: Colors.black87,
                  )),
              hintText: "Çocuk Sayısı",
              hintStyle: TextStyle(color: Colors.black87),
              fillColor: Colors.white70,
              filled: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                      color: constantColors.primaryBlueColor, width: 2.2)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.2,
                  ),
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          cocukSayisinaGoreConfigureEt(),
        ],
      ),
    );
  }

  String validateCocukSayisi(String _cocukSayi) {
    if ((_cocukSayi.length == 0)) {
      return "Bu alan boş olamaz";
    } else if (int.parse(_cocukSayi) >= 8) {
      return "En fazla 7 çocuk";
    }

    return null;
  }

  String validateDogumTarihi(String _dogumTarihi) {
    if ((selfDatetime.length == 0)) {
      return "Bu alan boş olamaz";
    }

    return null;
  }

  String meslekValidator(String meslek) {
    if ((meslek.length == 0)) {
      return "Bu alan boş olamaz";
    }

    return null;
  }

  String konutValidator(String konut) {
    if ((konut.length == 0)) {
      return "Bu alan boş olamaz";
    }

    return null;
  }

  String adSoyadValidator(String _adsoyad) {
    if ((_adsoyad.length == 0)) {
      return "Bu alan boş olamaz";
    }

    return null;
  }

  String esAdSoyadValidator(String _adsoyad) {
    if ((_adsoyad.length == 0)) {
      return "Bu alan boş olamaz";
    }

    return null;
  }

  String customTextFormFieldValidator(String _adsoyad) {
    if ((_adsoyad.length == 0)) {
      return "Bu alan boş olamaz";
    }

    return null;
  }

  customTextFormField(
      String paramCocukAdSoyad,
      int cocukCount,
      String paramCocukYas,
      TextEditingController cocukAdController,
      TextEditingController cocukYasController) {
    Widget textFormFieldAdSoyad = TextFormField(
      onSaved: (String gelenCocukAdSoyad) {
        paramCocukAdSoyad = gelenCocukAdSoyad;

        set.kidsName = gelenCocukAdSoyad;
      },
      controller: cocukAdController,
      validator: customTextFormFieldValidator,
      decoration: InputDecoration(
        prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              " ${cocukCount.toString()}.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        hintText: "Çocuk Ad Soyad",
        hintStyle: TextStyle(color: Colors.black87),
        fillColor: Colors.white70,
        filled: true,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:
                BorderSide(color: constantColors.primaryBlueColor, width: 2.2)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.2,
            ),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
    Widget textFormFieldYas = TextFormField(
      keyboardType: TextInputType.number,
      validator: customTextFormFieldValidator,
      onSaved: (String gelenCocukYas) {
        paramCocukYas = gelenCocukYas;
        set.kidsDateOfBirth = gelenCocukYas.toString();
      },
      controller: cocukYasController,
      decoration: InputDecoration(
        prefixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              " ${cocukCount.toString()}.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        hintText: "Çocuk Yaş",
        hintStyle: TextStyle(color: Colors.black87),
        fillColor: Colors.white70,
        filled: true,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide:
                BorderSide(color: constantColors.primaryBlueColor, width: 2.2)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.2,
            ),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
    setList.add(set);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4),
      child: Column(
        children: [
          textFormFieldAdSoyad,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: textFormFieldYas,
          )
        ],
      ),
    );
  }

  cocukSayisinaGoreConfigureEt() {
    if (cocukSayisi != null) {
      if (cocukSayisi > 0) {
        switch (cocukSayisi) {
          case 1:
            return Column(
              children: [
                customTextFormField(cocukAdSoyad1, 1, cocukYas1,
                    cocukAdController1, cocukYasController1),
              ],
            );
          case 2:
            return Column(
              children: [
                customTextFormField(cocukAdSoyad1, 1, cocukYas1,
                    cocukAdController1, cocukYasController1),
                customTextFormField(cocukAdSoyad2, 2, cocukYas2,
                    cocukAdController2, cocukYasController2),
              ],
            );
          case 3:
            return Column(
              children: [
                customTextFormField(cocukAdSoyad1, 1, cocukYas1,
                    cocukAdController1, cocukYasController1),
                customTextFormField(cocukAdSoyad2, 2, cocukYas2,
                    cocukAdController2, cocukYasController2),
                customTextFormField(cocukAdSoyad3, 3, cocukYas3,
                    cocukAdController3, cocukYasController3),
              ],
            );
          case 4:
            return Column(
              children: [
                customTextFormField(cocukAdSoyad1, 1, cocukYas1,
                    cocukAdController1, cocukYasController1),
                customTextFormField(cocukAdSoyad2, 2, cocukYas2,
                    cocukAdController2, cocukYasController2),
                customTextFormField(cocukAdSoyad3, 3, cocukYas3,
                    cocukAdController3, cocukYasController3),
                customTextFormField(cocukAdSoyad4, 4, cocukYas4,
                    cocukAdController4, cocukYasController4),
              ],
            );
          case 5:
            return Column(
              children: [
                customTextFormField(cocukAdSoyad1, 1, cocukYas1,
                    cocukAdController1, cocukYasController1),
                customTextFormField(cocukAdSoyad2, 2, cocukYas2,
                    cocukAdController2, cocukYasController2),
                customTextFormField(cocukAdSoyad3, 3, cocukYas3,
                    cocukAdController3, cocukYasController3),
                customTextFormField(cocukAdSoyad4, 4, cocukYas4,
                    cocukAdController4, cocukYasController4),
                customTextFormField(cocukAdSoyad5, 5, cocukYas5,
                    cocukAdController5, cocukYasController5),
              ],
            );
          case 6:
            return Column(
              children: [
                customTextFormField(cocukAdSoyad1, 1, cocukYas1,
                    cocukAdController1, cocukYasController1),
                customTextFormField(cocukAdSoyad2, 2, cocukYas2,
                    cocukAdController2, cocukYasController2),
                customTextFormField(cocukAdSoyad3, 3, cocukYas3,
                    cocukAdController3, cocukYasController3),
                customTextFormField(cocukAdSoyad4, 4, cocukYas4,
                    cocukAdController4, cocukYasController4),
                customTextFormField(cocukAdSoyad5, 5, cocukYas5,
                    cocukAdController5, cocukYasController5),
                customTextFormField(cocukAdSoyad6, 6, cocukYas6,
                    cocukAdController6, cocukYasController6),
              ],
            );
          case 7:
            return Column(
              children: [
                customTextFormField(cocukAdSoyad1, 1, cocukYas1,
                    cocukAdController1, cocukYasController1),
                customTextFormField(cocukAdSoyad2, 2, cocukYas2,
                    cocukAdController2, cocukYasController2),
                customTextFormField(cocukAdSoyad3, 3, cocukYas3,
                    cocukAdController3, cocukYasController3),
                customTextFormField(cocukAdSoyad4, 4, cocukYas4,
                    cocukAdController4, cocukYasController4),
                customTextFormField(cocukAdSoyad5, 5, cocukYas5,
                    cocukAdController5, cocukYasController5),
                customTextFormField(cocukAdSoyad6, 6, cocukYas6,
                    cocukAdController6, cocukYasController6),
                customTextFormField(cocukAdSoyad7, 7, cocukYas7,
                    cocukAdController7, cocukYasController7),
              ],
            );
          default:
            return SizedBox();
        }
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }

  num eklenecekSayiAta() {
    double height = widget.height;
    print(height);
    if (height >= 400 && height <= 600) {
      return 190.0;
    } else if (height >= 601 && height <= 800) {
      //checked
      return 167;
    } else if (height >= 801 && height <= 1000) {
//checked
      return 135;
    } else if (height >= 1001 && height <= 1200) {
      return 105;
    } else if (height >= 1201 && height <= 1400) {
      //checked
      return 90;
    } else if (height >= 1401 && height <= 1600) {
      return 45;
    } else if (height >= 1601 && height <= 1800) {
      return 5;
    } else if (height >= 1801 && height <= 2000) {
      return 1;
    }
  }

  cocukEkle() {
    for (int i = 0; i < setList.length; i++) {
      print(setList[i].toMap());
      return FieldValue.arrayUnion([setList[i].toMap()]);
    }
  }

  cocukSayisinaGoreTextFormFieldTextAta() {
    switch (cocukSayisi) {
      case 1:
        return cocukControllerAta(1);
      case 2:
        return cocukControllerAta(2);
      case 3:
        return cocukControllerAta(3);
      case 4:
        return cocukControllerAta(4);
      case 5:
        return cocukControllerAta(5);
      case 6:
        return cocukControllerAta(6);
      case 7:
        return cocukControllerAta(7);
    }
  }

  cocukControllerAta(int cocukSayisi) {
    if (cocukSayisi == 1) {
      cocukAdController1.text = oturumAcanUser.kidsList[0]['kidsName'];
      cocukYasController1.text = oturumAcanUser.kidsList[0]['kidsDateOfBirth'];
    } else if (cocukSayisi == 2) {
      cocukAdController1.text = oturumAcanUser.kidsList[0]['kidsName'];
      cocukYasController1.text = oturumAcanUser.kidsList[0]['kidsDateOfBirth'];
      cocukAdController2.text = oturumAcanUser.kidsList[1]['kidsName'];
      cocukYasController2.text = oturumAcanUser.kidsList[1]['kidsDateOfBirth'];
    } else if (cocukSayisi == 3) {
      cocukAdController1.text = oturumAcanUser.kidsList[0]['kidsName'];
      cocukYasController1.text = oturumAcanUser.kidsList[0]['kidsDateOfBirth'];
      cocukAdController2.text = oturumAcanUser.kidsList[1]['kidsName'];
      cocukYasController2.text = oturumAcanUser.kidsList[1]['kidsDateOfBirth'];
      cocukAdController3.text = oturumAcanUser.kidsList[2]['kidsName'];
      cocukYasController3.text = oturumAcanUser.kidsList[2]['kidsDateOfBirth'];
    } else if (cocukSayisi == 4) {
      cocukAdController1.text = oturumAcanUser.kidsList[0]['kidsName'];
      cocukYasController1.text = oturumAcanUser.kidsList[0]['kidsDateOfBirth'];
      cocukAdController2.text = oturumAcanUser.kidsList[1]['kidsName'];
      cocukYasController2.text = oturumAcanUser.kidsList[1]['kidsDateOfBirth'];
      cocukAdController3.text = oturumAcanUser.kidsList[2]['kidsName'];
      cocukYasController3.text = oturumAcanUser.kidsList[2]['kidsDateOfBirth'];
      cocukAdController4.text = oturumAcanUser.kidsList[3]['kidsName'];
      cocukYasController4.text = oturumAcanUser.kidsList[3]['kidsDateOfBirth'];
    } else if (cocukSayisi == 5) {
      cocukAdController1.text = oturumAcanUser.kidsList[0]['kidsName'];
      cocukYasController1.text = oturumAcanUser.kidsList[0]['kidsDateOfBirth'];
      cocukAdController2.text = oturumAcanUser.kidsList[1]['kidsName'];
      cocukYasController2.text = oturumAcanUser.kidsList[1]['kidsDateOfBirth'];
      cocukAdController3.text = oturumAcanUser.kidsList[2]['kidsName'];
      cocukYasController3.text = oturumAcanUser.kidsList[2]['kidsDateOfBirth'];
      cocukAdController4.text = oturumAcanUser.kidsList[3]['kidsName'];
      cocukYasController4.text = oturumAcanUser.kidsList[3]['kidsDateOfBirth'];
      cocukAdController5.text = oturumAcanUser.kidsList[4]['kidsName'];
      cocukYasController5.text = oturumAcanUser.kidsList[4]['kidsDateOfBirth'];
    } else if (cocukSayisi == 6) {
      cocukAdController1.text = oturumAcanUser.kidsList[0]['kidsName'];
      cocukYasController1.text = oturumAcanUser.kidsList[0]['kidsDateOfBirth'];
      cocukAdController2.text = oturumAcanUser.kidsList[1]['kidsName'];
      cocukYasController2.text = oturumAcanUser.kidsList[1]['kidsDateOfBirth'];
      cocukAdController3.text = oturumAcanUser.kidsList[2]['kidsName'];
      cocukYasController3.text = oturumAcanUser.kidsList[2]['kidsDateOfBirth'];
      cocukAdController4.text = oturumAcanUser.kidsList[3]['kidsName'];
      cocukYasController4.text = oturumAcanUser.kidsList[3]['kidsDateOfBirth'];
      cocukAdController5.text = oturumAcanUser.kidsList[4]['kidsName'];
      cocukYasController5.text = oturumAcanUser.kidsList[4]['kidsDateOfBirth'];
      cocukAdController6.text = oturumAcanUser.kidsList[5]['kidsName'];
      cocukYasController6.text = oturumAcanUser.kidsList[5]['kidsDateOfBirth'];
    } else if (cocukSayisi == 7) {
      cocukAdController1.text = oturumAcanUser.kidsList[0]['kidsName'];
      cocukYasController1.text = oturumAcanUser.kidsList[0]['kidsDateOfBirth'];
      cocukAdController2.text = oturumAcanUser.kidsList[1]['kidsName'];
      cocukYasController2.text = oturumAcanUser.kidsList[1]['kidsDateOfBirth'];
      cocukAdController3.text = oturumAcanUser.kidsList[2]['kidsName'];
      cocukYasController3.text = oturumAcanUser.kidsList[2]['kidsDateOfBirth'];
      cocukAdController4.text = oturumAcanUser.kidsList[3]['kidsName'];
      cocukYasController4.text = oturumAcanUser.kidsList[3]['kidsDateOfBirth'];
      cocukAdController5.text = oturumAcanUser.kidsList[4]['kidsName'];
      cocukYasController5.text = oturumAcanUser.kidsList[4]['kidsDateOfBirth'];
      cocukAdController6.text = oturumAcanUser.kidsList[5]['kidsName'];
      cocukYasController6.text = oturumAcanUser.kidsList[5]['kidsDateOfBirth'];
      cocukAdController7.text = oturumAcanUser.kidsList[6]['kidsName'];
      cocukYasController7.text = oturumAcanUser.kidsList[6]['kidsDateOfBirth'];
    }
  }

  awaitAndGoToNewQuestionPage() async {
    print("home page e gitme çalıştı");
    await Future.delayed(Duration(milliseconds: 2000));

    commonWidgets.customToast(
        "Bilgiler daha önce girildi proje sayfasına yönlendiriliyorsunuz...",
        Colors.teal);
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.of(context).pushReplacement(PageTransition(
        child: HomePage(oturumAcanUser),
        type: PageTransitionType.rightToLeft,
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 250)));
  }

  getUserBekle() async {
    print("get user bekle çalıştı");
    await getUser();
  }
}

class Set {
  String kidsName;
  String kidsDateOfBirth;

  Set({this.kidsName, this.kidsDateOfBirth});

  Map<String, dynamic> toMap() =>
      {"kidsName": this.kidsName, "kidsDateOfBirth": this.kidsDateOfBirth};

  Set.fromMap(Map<String, dynamic> map)
      : kidsName = map['kidsName'],
        kidsDateOfBirth = map['kidsDateOfBirth'];
}

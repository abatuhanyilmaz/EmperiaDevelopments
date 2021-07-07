import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_developments/appPages/customerQuestionDetail.dart';
import 'package:empire_developments/authPages/signinPage.dart';
import 'package:empire_developments/commonWidget/commonWidgets.dart';
import 'package:empire_developments/commonWidget/loginButton.dart';
import 'package:empire_developments/model/categoryModel.dart';
import 'package:empire_developments/model/userModel.dart';
import 'package:empire_developments/services/firebaseAuthServices.dart';
import 'package:empire_developments/utils/color.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'anahtarTeslimYapildiPage.dart';
import 'customerConfigDetailPage.dart';

class HomePage extends StatefulWidget {
  final Users user;

  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthServices authServices=AuthServices();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  final String collectionName = 'categories';
  double width, height;
  List<DocumentSnapshot> _snap = [];
  ConstantColors constantColors = ConstantColors();

  String projectImageUrl = "";

  List<Category> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CommonWidgets commonWidgets = CommonWidgets();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          .orderBy('timestamp', descending: true)
          .startAfter([_lastVisible['timestamp']])
          .limit(10)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Category.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
      // commonWidgets.customToast(
      //     'Daha Fazla Proje Bulunmuyor!', Colors.grey[800]);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Güzel Evim"),
        backgroundColor: constantColors.primaryKapaliColor,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(PageTransition(
              child: CustomerConfigirationDetailPage(
                height: height,
                fromArrwoBack: true,
              ),
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 180),
              reverseDuration: Duration(milliseconds: 200),
            ));
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
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
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8),
                child: Text(
                  "Hangi projemizden alım yaptınız?",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 2.0, right: 2, top: 8, bottom: 8),
                  child: RefreshIndicator(
                    child: ListView.builder(
                      controller: controller,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _data.length + 1,
                      itemBuilder: (_, int index) {
                        if (index < _data.length) {
                          return Column(
                            children: [
                              dataList(_data[index]),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        }
                        return Center(
                          child: new Opacity(
                            opacity: _isLoading ? 1.0 : 0.0,
                            child: new SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: new CircularProgressIndicator()),
                          ),
                        );
                      },
                    ),
                    onRefresh: () async {
                      refreshData();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  refreshData() {
    setState(() {
      _data.clear();
      _snap.clear();
      _lastVisible = null;
    });
    _getData();
  }



  Widget dataList(Category d) {
    return InkWell(
      onTap: () {
        if (d.anahtarTeslimMi == true) {
          Navigator.of(context).push(
            PageTransition(
                child: AnahtarTeslimYapildiPage(
                  projectImageUrl: d.thumbnailUrl,
                  projectName: d.name,
                ),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 300),
                reverseDuration: Duration(milliseconds: 250)),
          );
        } else {
          Navigator.of(context).push(
            PageTransition(
                child: CustomerQuestionDetail(
                  user: widget.user,
                  category: d,
                ),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 300),
                reverseDuration: Duration(milliseconds: 250)),
          );
        }
      },
      child: Stack(
        children: [
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 350,
              // margin: EdgeInsets.only(right: 5, left: 5, bottom: 5),
              //padding: EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
              width: width,

              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ExtendedImage.network(
                    d.thumbnailUrl,
                    fit: BoxFit.cover,
                    cache: true,
                  )),
            ),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.only(top: 295),
              child: Container(
                width: width - 28,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.025),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "  " + d.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}

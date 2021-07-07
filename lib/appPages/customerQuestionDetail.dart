import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire_developments/appPages/projectFinishPage.dart';
import 'package:empire_developments/commonWidget/commonWidgets.dart';
import 'package:empire_developments/model/categoryModel.dart';
import 'package:empire_developments/model/questionModel.dart';
import 'package:empire_developments/model/userModel.dart';
import 'package:empire_developments/utils/color.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'homePage.dart';

class CustomerQuestionDetail extends StatefulWidget {
  final Category category;
  final Users user;

  CustomerQuestionDetail({Key key, this.category, this.user}) : super(key: key);

  @override
  _CustomerQuestionDetailState createState() => _CustomerQuestionDetailState();
}

class _CustomerQuestionDetailState extends State<CustomerQuestionDetail> {
  CommonWidgets commonWidgets = CommonWidgets();
  ConstantColors constantColors = ConstantColors();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<Question> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String collectionName = 'contents';
  String _sortBy;
  bool _descending;
  String _orderBy;
  double height;
  double cardHeight = 255;
  int selectedIndex;
  bool haveData;
  int selectedQuestionIndex;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _sortBy = null;
    _orderBy = 'timestamp';
    _descending = true;
    if (this.mounted) {
      _getData();
    }

  }

  Future<Null> _getData() async {
    QuerySnapshot data;

    if (_sortBy == null) {
      if (_lastVisible == null)
        data = await firestore
            .collection(collectionName)
            .where('category', isEqualTo: widget.category.name)
            .orderBy(_orderBy, descending: _descending)
            .limit(10)
            .get();
      else
        data = await firestore
            .collection(collectionName)
            .where('category', isEqualTo: widget.category.name)
            .orderBy(_orderBy, descending: _descending)
            .startAfter([_lastVisible[_orderBy]])
            .limit(10)
            .get();
    } else {
      if (_lastVisible == null)
        data = await firestore
            .collection(collectionName)
            .where('category', isEqualTo: widget.category.name)
            .orderBy(_orderBy, descending: _descending)
            .limit(10)
            .get();
      else
        data = await firestore
            .collection(collectionName)
            .where('category', isEqualTo: widget.category.name)
            .orderBy(_orderBy, descending: _descending)
            .startAfter([_lastVisible[_orderBy]])
            .limit(10)
            .get();
    }

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Question.fromFirestore(e)).toList();

          _data.sort((a, b) => a.subCategoryName.compareTo(b.subCategoryName));
          //
          // for (int i = 0; i < dataLength-1; i++) {
          //   if (i < dataLength -2) {
          //     print( "data contorlleri" );
          //     print( _data[i].subCategoryName );
          //     print( _data[i + 1].subCategoryName );
          //
          //     if (_data[i].subCategoryName == _data[i + 1].subCategoryName) {
          //       for (int j = 2; j < dataLength+1 ; j++) {
          //         if (j < dataLength) {
          //           _data[i + j-1 ].subCategoryName = "";
          //
          //
          //
          //         }
          //       }
          //     }
          //   }
          // }

          if (_data.length > 0) {
            haveData = true;
          } else {
            haveData = false;
          }
        });
      }
    } else {
      setState(() => _isLoading = false);
      // commonWidgets.customToast(
      //     'Daha Fazla Konfigürasyon Bulunmuyor!', Colors.grey[800]);
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  reloadData() {
    setState(() {
      _isLoading = true;
      _snap.clear();
      _data.clear();
      _lastVisible = null;
      if (_data.length > 0) {
        haveData = true;
      } else {
        haveData = false;
      }
    });
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                          color: Colors.black87,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 28,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: TextButton(
                          onPressed: () {
                            ratinDialog();
                            // Navigator.of(context).pushReplacement(PageTransition(
                            //   child: HomePage(widget.user),
                            //   type: PageTransitionType.leftToRight,
                            //   duration: Duration(milliseconds: 180),
                            //   reverseDuration: Duration(milliseconds: 200),
                            // ));
                          },
                          child: Text(
                            "Seçimleri Kaydet",
                            style: TextStyle(
                                color: constantColors.primaryKapaliColor,
                                fontSize: 19),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      child: FutureBuilder(
                        future: future(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return durumaGoreDataAta();
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),

                      /*                              L
*/

                      onRefresh: () async {
                        reloadData();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataList(Question d, int topIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 6, right: 6),
      child: Card(
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            //   padding: EdgeInsets.only(top: 5, right: 15, bottom: 15, left: 5),
            margin: EdgeInsets.all(4),
            height: 410,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        color: constantColors.primaryKapaliColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        d.category,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
                Text(
                  d.title,
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 7,
                ),
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: d.questionImageList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  selectedIndex = index;
                                  selectedQuestionIndex = topIndex;
                                  setState(() {});
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 6.0, left: 6),
                                          child: Container(
                                            child: Card(
                                              shadowColor: selectedIndex ==
                                                          index &&
                                                      topIndex ==
                                                          selectedQuestionIndex
                                                  ? Colors.greenAccent[700]
                                                  : Colors.black87,
                                              shape: RoundedRectangleBorder(
                                                  side: selectedIndex ==
                                                              index &&
                                                          topIndex ==
                                                              selectedQuestionIndex
                                                      ? BorderSide(
                                                          color: Colors
                                                              .greenAccent[700],
                                                          width: 1)
                                                      : BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              elevation: selectedIndex ==
                                                          index &&
                                                      topIndex ==
                                                          selectedQuestionIndex
                                                  ? 11
                                                  : 3,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: ExtendedImage.network(
                                                  d.questionImageList[index],
                                                  height: 200,
                                                  width: 200,
                                                  fit: BoxFit.cover,
                                                  cache: false,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Container(
                                      //     height: 200,
                                      //     width: 200,
                                      //     child: Card(
                                      //       shadowColor: selectedIndex == index &&
                                      //           topIndex ==
                                      //               selectedQuestionIndex
                                      //           ? Colors.greenAccent[700]
                                      //           : Colors.black87,
                                      //       shape: RoundedRectangleBorder(
                                      //           side: selectedIndex == index &&
                                      //               topIndex ==
                                      //                   selectedQuestionIndex
                                      //               ? BorderSide(
                                      //               color: Colors
                                      //                   .greenAccent[700],
                                      //               width: 1)
                                      //               : BorderSide(
                                      //               color: Colors.transparent,
                                      //               width: 0),
                                      //           borderRadius:
                                      //           BorderRadius.circular(10)),
                                      //       elevation: selectedIndex == index &&
                                      //           topIndex ==
                                      //               selectedQuestionIndex
                                      //           ? 11
                                      //           : 3,
                                      //       child: ClipRRect(
                                      //         borderRadius:
                                      //         BorderRadius.circular(10),
                                      //         child: ExtendedImage.network(
                                      //           d.questionImageList[index],
                                      //           height: 20,
                                      //           width: 20,
                                      //           fit: BoxFit.cover,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      StreamBuilder(
                                          stream: streamAta(d),
                                          builder: (context, snapshot) {
                                            // Question questionChoosed =
                                            // Question.fromFirestore(
                                            //     documentSnapshot);
                                            if (snapshot.hasData) {
                                              var data = snapshot.data.docs;
                                              // print(data['title']);
                                              // print("data var");
                                              String choosedImage =
                                                  choosedImageAta(
                                                data,
                                                d,
                                              );
                                              if (choosedImage != null &&
                                                  d.questionImageList
                                                      .contains(choosedImage)) {
                                                int chosIndex = d
                                                    .questionImageList
                                                    .indexOf(choosedImage);

                                                return index == chosIndex
                                                    ? Icon(
                                                        Icons.done,
                                                        color: Colors
                                                            .blueAccent[700],
                                                        size: 30,
                                                      )
                                                    : SizedBox(
                                                        height: 30,
                                                        width: 50,
                                                      );
                                              } else {
                                                return SizedBox(
                                                  height: 30,
                                                  width: 50,
                                                );
                                              }
                                            } else {
                                              return SizedBox(
                                                height: 30,
                                                width: 50,
                                              );
                                            }
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.access_time,
                                  size: 22, color: Colors.blueAccent),
                              SizedBox(width: 7),
                              Text(
                                d.date,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          Opacity(
                            opacity:
                                selectedQuestionIndex == topIndex ? 1 : 0.3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: TextButton(
                                  style: buttonStyle(
                                      Colors.purpleAccent),
                                  child: Text(
                                    "Seç",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () async {
                                    if (selectedQuestionIndex == topIndex) {
                                      var gelenDeger = await secimAta();
                                      if (gelenDeger == true) {
                                        commonWidgets.customToast(
                                            "Seçiminiz Kaydedildi",
                                            Colors.greenAccent[700]);
                                      } else {
                                        commonWidgets.customToast(
                                            "Sorun Oluştu",
                                            Colors.redAccent[700]);
                                      }
                                    } else {
                                      print("başka indexte");
                                    }
                                  }),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  secimAta() async {

    try {
      await FirebaseFirestore.instance
          .collection("usersConfigiration")
          .doc(
              "${widget.user.userID}-${_data[selectedQuestionIndex].contentsID}")
          .set({
        "title": _data[selectedQuestionIndex].title,
        "chosedImage":
            _data[selectedQuestionIndex].questionImageList[selectedIndex],
        "category": _data[selectedQuestionIndex].category,
        "contentTimeStamp": _data[selectedQuestionIndex].timestamp,
        "contentId": _data[selectedQuestionIndex].contentsID,
        "contentDate": _data[selectedQuestionIndex].date,
        "choesedUserID": widget.user.userID,
      });
      return true;
    } catch (e) {
      print("seçilen kartelayı dbye eklerken hata cıkıt :$e");
      return false;
    }
  }

  durumaGoreDataAta() {
    if (_data.length > 0) {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 60),
        controller: controller,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _data.length + 1,
        itemBuilder: (_, int index) {
          if (index < _data.length) {
            return Column(
              children: [
                altKategoriNameAta(
                  index,
                ),
                dataList(_data[index], index),
              ],
            );
          } else {
            print("index kücük degik data boyundan");
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
      );
    } else {
      return Center(
        child: Container(
          child: Center(
              child: Text(
            " ",
            textAlign: TextAlign.center,
            style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.black87,
                fontSize: 19),
          )),
        ),
      );
    }
  }

  ratinDialog() {
    final _dialog = RatingDialog(
      // your app's name?
      title: 'Memnuniyet Anketi',
      // encourage your user to leave a high rating?
      message: "Emperia Developments'tan memnun kaldınız mı?",
      // your app's logo?
      image: Image.asset("assets/logo.png"),
      initialRating: 5,
      submitButton: 'Gönder',
      onCancelled: () => print('cancelled'),
      commentHint: "Görüşlerinizi yazın",
      onSubmitted: (response) async {
        print('rating: ${response.rating}, comment: ${response.comment}');

        // TODO: add your own logic

        var gelenDeger = await feddbackUserInfoUpdate(response);
        if (gelenDeger == true) {
          Navigator.of(context).push(PageTransition(
            child: ProjectFinishPage(),
            type: PageTransitionType.leftToRight,
            duration: Duration(milliseconds: 180),
            reverseDuration: Duration(milliseconds: 200),
          ));
        }
      },
    );

    showDialog(
      context: context,
      builder: (context) => _dialog,
    );

    // showDialog(
    //     context: context,
    //     barrierDismissible: true, // set to false if you want to force a rating
    //     builder: (context) {
    //       return RatingDialog(
    //         icon: const FlutterLogo(
    //             size: 100,
    //             colors: Colors.red), // set your own image/icon widget
    //         title: "The Rating Dialog",
    //         description:
    //         "Tap a star to set your rating. Add more description here if you want.",
    //         submitButton: "SUBMIT",
    //         alternativeButton: "Contact us instead?", // optional
    //         positiveComment: "We are so happy to hear :)", // optional
    //         negativeComment: "We're sad to hear :(", // optional
    //         accentColor: Colors.red, // optional
    //         onSubmitPressed: (int rating) {
    //           print("onSubmitPressed: rating = $rating");
    //           // TODO: open the app's page on Google Play / Apple App Store
    //         },
    //         onAlternativePressed: () {
    //           print("onAlternativePressed: do something");
    //           // TODO: maybe you want the user to contact you instead of rating a bad review
    //         },
    //       );
    //     });
  }

  future() async {
    await Future.delayed(Duration(milliseconds: 1500));
    return _data;
  }

  feddbackUserInfoUpdate(RatingDialogResponse response) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.userID)
          .update({
        "userRatedCount": response.rating.toString(),
        "userFeedBack": response.comment,
      });
      return true;
    } catch (e) {
      print("feddback sırasında hata oluştu $e");
      return true;
    }
  }

  streamAta(Question d) {
    try {
      var document = FirebaseFirestore.instance
          .collection("usersConfigiration")
          .where(
            "choesedUserID",
            isEqualTo: widget.user.userID,
          )
          .where("contentId", isEqualTo: d.contentsID)
          .snapshots();
      return document;
    } catch (e) {
      print("stream ata error ${d.contentsID}");
      print("stream ata error $e");
      DocumentSnapshot snapshot;
      return snapshot;
    }
  }

  String choosedImageAta(data, Question d) {
    try {
      String gelenData = data[0]['chosedImage'];
      return gelenData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  altKategoriNameAta(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          // Add one stop for each color. Stops should increase from 0 to 1
          colors: [
            Colors.cyanAccent[400],
            Colors.cyanAccent[700],
            Colors.tealAccent[700],

            Colors.tealAccent[400],

          ],
        )),
        child: Center(
          child: Text(
            " " + _data[index].subCategoryName + " ",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        height: 30,
      ),
    );
  }
}

ButtonStyle buttonStyle(Color color) {
  return ButtonStyle(
      padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.only(left: 30, right: 30, top: 8, bottom: 8)),
      backgroundColor: MaterialStateProperty.resolveWith((states) => color),
      shape: MaterialStateProperty.resolveWith((states) =>
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))));
}

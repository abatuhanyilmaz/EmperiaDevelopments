import 'package:cloud_firestore/cloud_firestore.dart';

class Question {

  String category;
  String title;
  String thumbnailImagelUrl;
  int loves;
  String date;
  String timestamp;
  List questionImageList;
  String contentsID;
  String subCategoryName;

  Question({

    this.category,
    this.title,
    this.thumbnailImagelUrl,
    this.loves,
    this.date,
    this.timestamp,
    this.questionImageList,
    this.contentsID,this.subCategoryName

  });


  factory Question.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot;
    return Question(
        category: d['category'],
        title: d['title'],
        date: d['date'],
        timestamp: d['timestamp'],
        questionImageList:d['questionImageList'],
        contentsID:d['contentsID'],
      subCategoryName:d['subCategories'],


    );
  }


  Question.fromMap(Map<String, dynamic> map)
      : category = map['category'],
        title = map['title'],
        date = map['date'],
        timestamp = map['timestamp'],
        questionImageList = map['questionImageList'],
        contentsID = map['contentsID'],
  subCategoryName=map['subCategories'];



}
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//User model
class Users {
  Users user;
  final String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;
  String customerDateOfBirth;
  String customerJob;
  String customerMedeniHal;
  String customerName;
  String customerWifeName;
  String haveKid;
  List kidsList;
  bool userWritedInfo;
  String konutNumara;
  String userRatedCount;
  String userFeedBack;

  Users(
      {@required this.userID,
      @required this.email,
      this.profilURL,
      this.userName,
      this.createdAt,
      this.customerDateOfBirth,
      this.customerJob,
      this.customerMedeniHal,
      this.customerName,
      this.customerWifeName,
      this.haveKid,
      this.kidsList,
      this.userWritedInfo,this.userRatedCount,this.userFeedBack,this.konutNumara});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID ?? "",
      'email': email ?? "unknown",
      'userName': uret(),
      'profilURL': profilURL ?? "",
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'customerDateOfBirth': customerDateOfBirth ?? "",
      'customerJob': customerJob ?? "",
      'customerMedeniHal': customerMedeniHal ?? "",
      'customerWifeName': customerWifeName ?? "",
      'customerName': customerName ?? "",
      'haveKid': haveKid ?? "",
      'kidsList': kidsList ?? [],
      'userWritedInfo': userWritedInfo ?? false,
      'userRatedCount': userRatedCount ?? "",
      'userFeedBack': userFeedBack ?? "",
      'konutNumara':konutNumara??"",


    };
  }

  Users.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        customerDateOfBirth = map['customerDateOfBirth'],
        customerJob = map['customerJob'],
        customerMedeniHal = map['customerMedeniHal'],
        customerName = map['customerName'],
        customerWifeName = map['customerWifeName'],
        haveKid = map['haveKid'],
        kidsList = map['kidsList'],
        konutNumara=map['konutNumara'],
        userWritedInfo = map['userWritedInfo'];

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt,}';
  }

  String uret() {
    return email.substring(0, email.indexOf("@"));
  }
}

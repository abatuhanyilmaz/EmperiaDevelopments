import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String name;
  String thumbnailUrl;
  String timestamp;
  bool anahtarTeslimMi;

  Category({
    this.name,
    this.thumbnailUrl,
    this.timestamp,
    this.anahtarTeslimMi
  });


  factory Category.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot;
    return Category(
      name: d['name'],
      thumbnailUrl: d['thumbnail'],
      timestamp: d['timestamp'],
      anahtarTeslimMi: d['anahtarTeslimMi'],
    );
  }
}
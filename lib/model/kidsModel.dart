class Kids{
  final String kidsName;
final String kidsDateOfBirht;
List<dynamic> kidsList=[];
Kids(this.kidsDateOfBirht,this.kidsName);
 @override
  String toString() {
    // TODO: implement toString
    return "kidsName :$kidsName , kidsDateOfBirth :$kidsDateOfBirht";
  }
   Map<String, dynamic> toMap() {
     return {
       'kidsName':this.kidsName,
       'kidsDateOfBirth':this.kidsDateOfBirht,
       'kidsList':this.kidsList
     };
   }

}
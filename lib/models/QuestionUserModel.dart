import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionUserModel {
  String firstName;
  String lastName;
  String uid;
  String email;
  String date;
  String phone;
  String id;

  QuestionUserModel(this.firstName, this.lastName, this.uid, this.phone,
      this.email, this.date, this.id);

  QuestionUserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    uid = json['uid'];
    phone = json['phone'];
    email = json['email'];
    date = json['date'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'uid': uid,
        'phone': phone,
        'email': email,
        'date': date
      };

  Map<String, dynamic> toJsonID() => {
        'firstName': firstName,
        'lastName': lastName,
        'uid': uid,
        'phone': phone,
        'email': email,
        'date': date,
        'id': id
      };

  static List<QuestionUserModel> toList(QuerySnapshot querySnapshot) {
    List<QuestionUserModel> list = List();
    querySnapshot.documents.forEach((document) {
      Map<String, dynamic> json = document.data;
      json['id'] = document.documentID;
      list.add(QuestionUserModel.fromJson(json));
    });
    return list;
  }

  static QuestionUserModel toObject(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data;
    json['id'] = documentSnapshot.documentID;
    return QuestionUserModel.fromJson(json);
  }
}

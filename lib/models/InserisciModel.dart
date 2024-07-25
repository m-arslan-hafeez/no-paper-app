import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_covid/models/QuestionUserModel.dart';

import 'QuestionModel.dart';

class InseriscriModel {
  String firstName;
  String lastName;
  String phone;
  String uid;
  String signatureValue;
  double bodyTemp;
  String date;
  List<QuestionModel> questions;
  bool isCheck;
  String id;

  InseriscriModel(
      {this.firstName="",
      this.lastName="",
      this.phone="",
      this.uid="",
      this.signatureValue="",
      this.date,
        this.bodyTemp=0,
      this.questions,
      this.isCheck = false,
      this.id});

  InseriscriModel.fromJson(Map<String, dynamic> jsonData) {
    firstName = jsonData['firstName'] ?? "";
    lastName = jsonData['lastName'] ?? "";
    phone = jsonData['phone'] ?? "";
    bodyTemp = jsonData['bodyTemp'] ?? 0;
    uid = jsonData['uid'] ?? "";
    signatureValue = jsonData['signatureValue'] ?? "";
    date = jsonData['date'] ?? "";
    questions = QuestionModel.toListFromJson(json.decode(jsonData['questions'] ?? []) ?? []);
    isCheck = jsonData['isCheck'] ?? false;
    id = jsonData['id'];
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'bodyTemp': bodyTemp,
        'uid': uid,
        'signatureValue': signatureValue,
        'date': date,
        'questions': json.encode(questions),
        'isCheck': isCheck,
      };

  Map<String, dynamic> toJsonID() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'bodyTemp': bodyTemp,
        'uid': uid,
        'signatureValue': signatureValue,
        'date': date,
        'isCheck': isCheck,
        'questions': json.encode(questions),
        'id': id
      };

  static List<InseriscriModel> toList(QuerySnapshot querySnapshot) {
    List<InseriscriModel> list = List();
    querySnapshot.documents.forEach((document) {
      Map<String, dynamic> json = document.data;
      json['id'] = document.documentID;
      list.add(InseriscriModel.fromJson(json));
    });
    return list;
  }

  static InseriscriModel toObject(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data;
    json['id'] = documentSnapshot.documentID;
    return InseriscriModel.fromJson(json);
  }
}

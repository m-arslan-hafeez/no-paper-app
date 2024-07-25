import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String firstName; //done
  String lastName;//done
  String uid;
  String vatNumber;//done
  String email;
  String businessName;//done
  String address; //done
  String responsible;//done
  String date;
  String role;
  String password;
  String fileUrl;
  String id;

  UserModel(
      this.firstName,
      this.lastName,
      this.uid,
      this.vatNumber,
      this.email,
      this.businessName,
      this.address,
      this.responsible,
      this.date,
      this.role,
      this.password,
      this.fileUrl,
      this.id);

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    uid = json['uid'];
    vatNumber = json['vatNumber'];
    address = json['address'];
    responsible = json['responsible'];
    date = json['date'] ?? "";
    email = json['email'];
    businessName = json['businessName'] ?? "";
    role = json['role'] ?? "";
    password = json['password'] ?? "";
    fileUrl = json['fileUrl'] ?? "";
    id = json['id'];
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'uid': uid,
        'vatNumber': vatNumber,
        'address': address,
        'responsible': responsible,
        'date': date,
        'email': email,
        'businessName': businessName,
        'role': role,
        'password': password,
        'fileUrl': fileUrl
      };

  Map<String, dynamic> toJsonID() => {
        'firstName': firstName,
        'lastName': lastName,
        'uid': uid,
        'vatNumber': vatNumber,
        'address': address,
        'responsible': responsible,
        'date': date,
        'email': email,
        'businessName': businessName,
        'role': role,
        'password': password,
        'fileUrl': fileUrl,
        'id': id
      };

  static List<UserModel> toList(QuerySnapshot querySnapshot) {
    List<UserModel> list = List();
    querySnapshot.documents.forEach((document) {
      Map<String, dynamic> json = document.data;
      json['id'] = document.documentID;
      list.add(UserModel.fromJson(json));
    });
    return list;
  }

  static UserModel toObject(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data;
    json['id'] = documentSnapshot.documentID;
    return UserModel.fromJson(json);
  }
}

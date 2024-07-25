import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String questionText;
  String answer;
  String type;
  String id;
  String uid;
  int order;
  String date;
  bool isRedSemaphore;
  bool isGreenSemaphore;
  bool isRisposta;

  QuestionModel(
      {this.questionText,
      this.answer,
      this.uid,
      this.type = "Tipo Risposta",
      this.date,
      this.id,
      this.order,
      this.isRedSemaphore = false,
      this.isGreenSemaphore = false,
      this.isRisposta = false});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    questionText = json['questionText'] ?? "";
    type = json['type'] ?? "Tipo Risposta";
    uid = json['uid'] ?? "";
    date = json['date'] ?? "";
    order = json['order'] ?? 0;
    answer = json['answer'] ?? "";
    isRedSemaphore = json['isRedSemaphore'] ?? false;
    isGreenSemaphore = json['isGreenSemaphore'] ?? false;
    isRisposta = json['isRisposta'] ?? false;
    id = json['id'];
  }

  Map<String, dynamic> toJson() => {
        'questionText': questionText,
        'uid': uid,
        'answer': answer,
        'type': type,
        'isRisposta': isRisposta,
        'date': date,
        'order': order,
        'isRedSemaphore': isRedSemaphore,
        'isGreenSemaphore': isGreenSemaphore,
        'isRisposta': isRisposta,
        'id': id ?? ""
      };

  Map<String, dynamic> toJsonID() => {
        'questionText': questionText,
        'type': type,
        'isRedSemaphore': isRedSemaphore,
        'isGreenSemaphore': isGreenSemaphore,
        'answer': answer,
        'uid': uid,
        'order': order,
        'date': date,
        'isRisposta': isRisposta,
        'id': id
      };

  static List<QuestionModel> toList(QuerySnapshot querySnapshot) {
    List<QuestionModel> list = List();
    querySnapshot.documents.forEach((document) {
      Map<String, dynamic> json = document.data;
      json['id'] = document.documentID;
      list.add(QuestionModel.fromJson(json));
    });

    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  static List<QuestionModel> toListFromJson(List data) {
    List<QuestionModel> list = List();
    data.forEach((document) {
      //  Map<String, dynamic> json = document.data;
      // json['id'] = document.documentID;
      list.add(QuestionModel.fromJson(document));
    });
    return list;
  }

  static QuestionModel toObject(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data;
    json['id'] = documentSnapshot.documentID;
    return QuestionModel.fromJson(json);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalQuestionModel {
  String id;
  String uid;
  bool isTemperatureEnabled;
  bool isSignature;
  bool isPrecompilato;
  bool isRisposta;
  bool canAddCustomQuestions;
  double temperatureValue;

  GlobalQuestionModel(
      {
      this.uid,
      this.id,
      this.isTemperatureEnabled = false,
      this.isSignature = false,
      this.isPrecompilato = false,
      this.isRisposta = false,
      this.canAddCustomQuestions = false,
      this.temperatureValue = 0.0});

  GlobalQuestionModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? "";
    temperatureValue = json['temperatureValue'] ?? 0;
    isTemperatureEnabled = json['isTemperatureEnabled'] ?? false;
    isSignature = json['isSignature'] ?? false;
    isRisposta = json['isRisposta'] ?? false;
    canAddCustomQuestions = json['canAddCustomQuestions'] ?? false;
    isPrecompilato = json['isPrecompilato'] ?? false;
    id = json['id'];
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'isRisposta': isRisposta,
        'temperatureValue': temperatureValue,
        'isSignature': isSignature,
        'isTemperatureEnabled': isTemperatureEnabled,
        'canAddCustomQuestions': canAddCustomQuestions,
        'isPrecompilato': isPrecompilato,
        'isRisposta': isRisposta
      };

  Map<String, dynamic> toJsonID() => {
        'uid': uid,
        'isTemperatureEnabled': isTemperatureEnabled,
        'isSignature': isSignature,
        'isPrecompilato': isPrecompilato,
        'isRisposta': isRisposta,
        'temperatureValue': temperatureValue,
        'canAddCustomQuestions': canAddCustomQuestions,
        'id': id
      };

  static List<GlobalQuestionModel> toList(QuerySnapshot querySnapshot) {
    List<GlobalQuestionModel> list = List();
    querySnapshot.documents.forEach((document) {
      Map<String, dynamic> json = document.data;
      json['id'] = document.documentID;
      list.add(GlobalQuestionModel.fromJson(json));
    });
    return list;
  }

  static List<GlobalQuestionModel> toListFromJson(List data) {
    List<GlobalQuestionModel> list = List();
    data.forEach((document) {
      //  Map<String, dynamic> json = document.data;
      // json['id'] = document.documentID;
      list.add(GlobalQuestionModel.fromJson(document));
    });
    return list;
  }

  static GlobalQuestionModel toObject(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data;
    if(json==null) return GlobalQuestionModel();
    json['id'] = documentSnapshot.documentID;
    return GlobalQuestionModel.fromJson(json);
  }
}

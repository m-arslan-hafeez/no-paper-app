import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDb {
  static FirestoreDb firestoreDb;

  static FirestoreDb getInstace() {
    if (firestoreDb == null) {
      firestoreDb = FirestoreDb();
    }
    return firestoreDb;
  }

  static getDocuments(String document) {
    Firestore.instance.collection(document).getDocuments();
  }

  static queryDocuments(String document) {
    Firestore.instance
        .collection('users')
        .where("username", isEqualTo: "flutter")
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => print(doc["title"])));
  }

  Future<bool> setDocument(String document, dynamic model, String key) async {
    if (key == null) {
      key = Firestore.instance.collection(document).document().documentID;
    }
    Firestore.instance
        .collection(document)
        .document(key)
        .setData(model.toJson());
    return true;
  }

  Future<bool> updateDocument(String document, dynamic model, String key) async {
    if (key == null) {
      key = Firestore.instance.collection(document).document().documentID;
    }
    Firestore.instance
        .collection(document)
        .document(key)
        .setData(model.toJson());
    return true;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_covid/models/GlobalQuestionModel.dart';
import 'package:qr_covid/models/InserisciModel.dart';
import 'package:qr_covid/models/QuestionModel.dart';
import 'package:qr_covid/models/QuestionUserModel.dart';
import 'package:qr_covid/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseOperations {
  static FirebaseOperations firebaseOperations;

  static FirebaseOperations getInstance() {
    if (firebaseOperations == null) {
      firebaseOperations = FirebaseOperations();
    }
    return firebaseOperations;
  }

  Future<UserModel> loginUser(Map<String, String> map) async {
    QuerySnapshot data = await Firestore.instance
        .collection('users')
        .where("username", isEqualTo: map["username"])
        .where("password", isEqualTo: map["password"])
        .getDocuments();
    if (data.documents.length > 0) {
      List<UserModel> list = UserModel.toList(data);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      // await sharedPreferences.setString(
      //     Consts.userInfo, json.encode(list[0].toJsonID()));
      // await sharedPreferences.setString(Consts.loginStatus, "true");
      return list[0];
    } else {
      return null;
    }
  }

  // Future<List<QuestionModel>> queryQuestions(
  //     String tag, String category) async {
  //   QuerySnapshot data = await Firestore.instance
  //       .collection('questions')
  //       .where("tag", isEqualTo: tag)
  //       .where("category", isEqualTo: category)
  //       .getDocuments();
  //   if (data.documents.length > 0) {
  //     return QuestionModel.toList(data);
  //   } else {
  //     return List();
  //   }
  // }

  // Future<List<AnswerModel>> getAnswers(
  //     String tag, String category, String uid) async {
  //   QuerySnapshot data = await Firestore.instance
  //       .collection('content_answers')
  //       .where("tag", isEqualTo: tag)
  //       .where("category", isEqualTo: category)
  //       .where("useruuid", isEqualTo: uid)
  //       .getDocuments();
  //   if (data.documents.length > 0) {
  //     return AnswerModel.toList(data);
  //   } else {
  //     return List();
  //   }
  // }
  //
  // Future<InfoModel> queryInfos(String tag, String category) async {
  //   print("123$category:$tag");
  //   QuerySnapshot data = await Firestore.instance
  //       .collection('infos')
  //       .where("tag", isEqualTo: tag)
  //       .where("category", isEqualTo: category)
  //       .getDocuments();
  //   if (data.documents.length > 0) {
  //     return InfoModel.toList(data)[0];
  //   } else {
  //     return null;
  //   }
  // }
  //
  // Future<List<SectionModel>> querySections(String categoryId) async {
  //   QuerySnapshot data = await Firestore.instance
  //       .collection('sections')
  //       .where("categoryId", isEqualTo: categoryId)
  //       //    .orderBy("priority")
  //       .getDocuments();
  //   if (data.documents.length > 0) {
  //     print("asfassdafs");
  //     return SectionModel.toList(data);
  //   } else {
  //     print("null");
  //     return List();
  //   }
  // }

  Future<List<UserModel>> getUsers() async {
    QuerySnapshot data =
        await Firestore.instance.collection('users').getDocuments();
    if (data.documents.length > 0) {
      return UserModel.toList(data);
    } else {
      return List();
    }
  }

  Future<List<InseriscriModel>> getQuestionUsers(String uid) async {
    QuerySnapshot data = await Firestore.instance
        .collection('question_users')
        .where("uid", isEqualTo: uid)
        .getDocuments();
    if (data.documents.length > 0) {
      return InseriscriModel.toList(data);
    } else {
      return List();
    }
  }

  Future<List<QuestionModel>> getQuestionByUser(String uid) async {
    QuerySnapshot data = await Firestore.instance
        .collection('questions')
        .where("uid", isEqualTo: uid)
        .getDocuments();
    if (data.documents.length > 0) {
      return QuestionModel.toList(data);
    } else {
      return List();
    }
  }

  void deleteQuestionByUser(String id) async {
    await Firestore.instance.collection('questions').document(id).delete();
  }

  Future<List<UserModel>> getUsersByCompany(String company) async {
    QuerySnapshot data = await Firestore.instance
        .collection('users')
        .where("company", isEqualTo: company)
        .where("role", isEqualTo: "user")
        .getDocuments();
    if (data.documents.length > 0) {
      return UserModel.toList(data);
    } else {
      return List();
    }
  }

  Future<UserModel> getUser(String uid) async {
    DocumentSnapshot data =
        await Firestore.instance.collection('users').document(uid).get();
    return data == null ? null : UserModel.toObject(data);
  }

  Future<GlobalQuestionModel> getGlobalQuestion(String id) async {
    DocumentSnapshot data = await Firestore.instance
        .collection('global_questions')
        .document(id)
        .get();

    return data == null ? null : GlobalQuestionModel.toObject(data);
  }

  // Future<MiscModel> queryMisc(String tag, String category) async {
  //   QuerySnapshot data = await Firestore.instance
  //       .collection('misc')
  //       .where("tag", isEqualTo: tag)
  //       .where("category", isEqualTo: category)
  //       .getDocuments();
  //   if (data.documents.length > 0) {
  //     return MiscModel.toList(data)[0];
  //   } else {
  //     return null;
  //   }
  // }
  //
  // Future<AnswerModel> getMiscAnswers(String id) async {
  //   DocumentSnapshot data =
  //       await Firestore.instance.collection('answers').document(id).get();
  //   return data == null ? null : AnswerModel.toObject(data);
  // }
  //
  // Future<ProgressModel> getProgress(String uid, String category) async {
  //   print("progress:$uid");
  //   DocumentSnapshot data =
  //       await Firestore.instance.collection('progress').document(uid).get();
  //
  //   return data == null
  //       ? ProgressModel.fromJson(null)
  //       : ProgressModel.toObject(data);
  // }
  //
  // Future<SectionRatingModel> getSectionRating(String id) async {
  //   print("section_rating:$id");
  //   DocumentSnapshot data = await Firestore.instance
  //       .collection('section_rating')
  //       .document(id)
  //       .get();
  //   return data == null ? null : SectionRatingModel.toObject(data);
  // }
}

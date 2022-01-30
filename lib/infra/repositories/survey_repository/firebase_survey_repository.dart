import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './../../../data/repositories/repositories.dart';
import './../../../data/models/models.dart';

class FirebaseSurveyRepository implements SurveyRepository {
  final FirebaseFirestore firebasInstance;
  static final String collectionName = 'surveys';
  static final String collectionName2 = 'user_survey';

  FirebaseSurveyRepository({
    required this.firebasInstance,
  });

  Future<List<RemoteSurveyModel>?> getSurveys({required String userUid}) async {
    try {
      final snapshots = await firebasInstance.collection(collectionName).get();

      List<RemoteSurveyModel>? list = [];

      if (snapshots.docs.length > 0) {
        for (var snapshot in snapshots.docs) {
          var json = snapshot.data();

          CollectionReference users =
              FirebaseFirestore.instance.collection(collectionName2);

          QuerySnapshot query = await users
              .where('survey_id', isEqualTo: json['id'])
              .where('user_uid', isEqualTo: userUid)
              .get();

          if (query.docs.length > 0) {
            json['didAnswer'] = true;
          } else {
            json['didAnswer'] = false;
          }

          list.add(RemoteSurveyModel.fromJson(json));
        }
      }

      return list;
    } on FirebaseAuthException {
      throw RepositoryError.forbidden;
    } catch (error) {
      throw RepositoryError.badRequest;
    }
  }

  Future<RemoteSurveyResultModel> getSurveyResult({
    required String surveyId,
    required String userUid,
  }) async {
    try {
      final snapshot =
          await firebasInstance.collection(collectionName).doc(surveyId).get();

      var json = snapshot.data();

      if (json == null) {
        throw RepositoryError.notFound;
      }

      CollectionReference users =
          FirebaseFirestore.instance.collection(collectionName2);

      QuerySnapshot query = await users
          .where('survey_id', isEqualTo: surveyId)
          .where('user_uid', isEqualTo: userUid)
          .get();

      if (query.docs.length > 0) {
        json['didAnswer'] = true;

        final String answer = query.docs.first.get('answer');

        for (var result in json['answers']) {
          if (result['answer'] == answer) {
            result['isCurrentAccountAnswer'] = true;
          } else {
            result['isCurrentAccountAnswer'] = false;
          }
        }
      } else {
        json['didAnswer'] = false;

        for (var result in json['answers']) {
          result['isCurrentAccountAnswer'] = false;
        }
      }

      json['surveyId'] = json['id'];

      return RemoteSurveyResultModel.fromJson(json);
    } on FirebaseAuthException {
      throw RepositoryError.forbidden;
    } catch (error) {
      throw RepositoryError.badRequest;
    }
  }

  Future<RemoteSurveyResultModel> saveSurveyResult({
    required String surveyId,
    required String userUid,
    required String answer,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection(collectionName2);

      QuerySnapshot query = await users
          .where('survey_id', isEqualTo: surveyId)
          .where('user_uid', isEqualTo: userUid)
          .get();

      final FirebaseSurveyResultModel firebaseSurveyResult =
          FirebaseSurveyResultModel(
        answer: answer,
        surveyId: surveyId,
        userUid: userUid,
      );

      if (query.docs.length > 0) {
        final String docId = query.docs.first.id;
        firebasInstance
            .collection(collectionName2)
            .doc(docId)
            .set(firebaseSurveyResult.toJson());
      } else {
        firebasInstance
            .collection(collectionName2)
            .add(firebaseSurveyResult.toJson());
      }

      await updateSurveyAnswerPercent(surveyId: surveyId);

      return await getSurveyResult(
        surveyId: surveyId,
        userUid: userUid,
      );
    } on FirebaseAuthException {
      throw RepositoryError.forbidden;
    } catch (error) {
      throw RepositoryError.badRequest;
    }
  }

  Future<void> updateSurveyAnswerPercent({
    required String surveyId,
  }) async {
    try {
      final surveys =
          await firebasInstance.collection(collectionName).doc(surveyId).get();

      var json = surveys.data();

      if (json != null) {
        CollectionReference users =
            FirebaseFirestore.instance.collection(collectionName2);

        QuerySnapshot query =
            await users.where('survey_id', isEqualTo: surveyId).get();

        if (query.docs.length > 0) {
          double total = query.docs.length.toDouble();

          for (var result in json['answers']) {
            QuerySnapshot queryAnswer = await users
                .where('survey_id', isEqualTo: surveyId)
                .where('answer', isEqualTo: result['answer'])
                .get();

            double totalAnswers = queryAnswer.docs.length.toDouble();

            result['percent'] = ((totalAnswers / total) * 100).toInt();
          }
        } else {
          for (var result in json['answers']) {
            result['percent'] = 0;
          }
        }

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(surveyId)
            .set(json);
      }
    } on FirebaseAuthException {
      throw RepositoryError.forbidden;
    } catch (error) {
      throw RepositoryError.badRequest;
    }
  }
}

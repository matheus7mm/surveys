import 'package:cloud_firestore/cloud_firestore.dart';

import './../../../data/repositories/repositories.dart';
import './../../../infra/repositories/repositories.dart';

SurveyRepository makeSurveyRepository() {
  return FirebaseSurveyRepository(
    firebasInstance: FirebaseFirestore.instance,
  );
}

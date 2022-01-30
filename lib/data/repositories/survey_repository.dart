import './../models/models.dart';

abstract class SurveyRepository {
  Future<List<RemoteSurveyModel>?> getSurveys({required String userUid});

  Future<RemoteSurveyResultModel?> getSurveyResult({
    required String surveyId,
    required String userUid,
  });

  Future<RemoteSurveyResultModel?> saveSurveyResult({
    required String surveyId,
    required String userUid,
    required String answer,
  });
}

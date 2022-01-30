import '../../../data/usecases/usecases.dart';
import '../../../domain/domain.dart';

import '../factories.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) {
  return RemoteSaveSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}

SaveSurveyResult makeFirebaseRemoteSaveSurveyResult(String surveyId) {
  return FirebaseRemoteSaveSurveyResult(
    surveyRepository: makeSurveyRepository(),
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    deleteSecureCacheStorage: makeSecureStorageAdapter(),
    surveyId: surveyId,
  );
}

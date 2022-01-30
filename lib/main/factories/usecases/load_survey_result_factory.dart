import '../../../data/usecases/usecases.dart';
import '../../../domain/domain.dart';

import './../../composites/composites.dart';
import '../factories.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}

LoadSurveyResult makeFirebaseRemoteLoadSurveyResult(String surveyId) {
  return FirebaseRemoteLoadSurveyResult(
    surveyRepository: makeSurveyRepository(),
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    deleteSecureCacheStorage: makeSecureStorageAdapter(),
  );
}

LocalLoadSurveyResult makeLocalLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(
    cacheStorage: makeLocalStorageAdapter(),
  );
}

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) =>
    RemoteLoadSurveyResultWithLocalFallback(
      remote: makeFirebaseRemoteLoadSurveyResult(surveyId),
      local: makeLocalLoadSurveyResult(surveyId),
    );

import 'package:surveys/main/composites/composites.dart';

import './../../../data/usecases/usecases.dart';
import './../../../domain/domain.dart';

import './../factories.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys'),
  );
}

LoadSurveys makeFirebaseRemoteLoadSurveys() {
  return FirebaseRemoteLoadSurveys(
    surveyRepository: makeSurveyRepository(),
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    deleteSecureCacheStorage: makeSecureStorageAdapter(),
  );
}

LocalLoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(
    cacheStorage: makeLocalStorageAdapter(),
  );
}

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() {
  return RemoteLoadSurveysWithLocalFallback(
    remote: makeFirebaseRemoteLoadSurveys(),
    local: makeLocalLoadSurveys(),
  );
}

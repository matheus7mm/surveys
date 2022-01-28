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

LocalLoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(
    cacheStorage: makeLocalStorageAdapter(),
  );
}

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() {
  return RemoteLoadSurveysWithLocalFallback(
    remote: makeRemoteLoadSurveys(),
    local: makeLocalLoadSurveys(),
  );
}

import './../../../domain/domain.dart';
import './../../../data/cache/cache.dart';

import './../../repositories/repositories.dart';
import './../../models/models.dart';

class FirebaseRemoteLoadSurveyResult implements LoadSurveyResult {
  final SurveyRepository surveyRepository;
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;

  FirebaseRemoteLoadSurveyResult({
    required this.surveyRepository,
    required this.fetchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
  });

  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    try {
      final String? token = await fetchSecureCacheStorage.fetch('token');

      if (token == null || token.isEmpty == true) {
        throw RepositoryError.forbidden;
      }

      final RemoteSurveyResultModel? model =
          await surveyRepository.getSurveyResult(
        userUid: token,
        surveyId: surveyId,
      );

      if (model == null) {
        throw RepositoryError.serverError;
      }

      return model.toEntity();
    } on RepositoryError catch (error) {
      if (error == RepositoryError.forbidden) {
        await deleteSecureCacheStorage.delete('token');
        throw DomainError.accessDenied;
      } else {
        throw DomainError.unexpected;
      }
    }
  }
}

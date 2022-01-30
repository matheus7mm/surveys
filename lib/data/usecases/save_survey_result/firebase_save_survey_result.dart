import './../../../domain/domain.dart';
import './../../../data/cache/cache.dart';

import './../../repositories/repositories.dart';
import './../../models/models.dart';

class FirebaseRemoteSaveSurveyResult implements SaveSurveyResult {
  final SurveyRepository surveyRepository;
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;
  final String surveyId;

  FirebaseRemoteSaveSurveyResult({
    required this.surveyRepository,
    required this.fetchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
    required this.surveyId,
  });

  Future<SurveyResultEntity> save({required String answer}) async {
    try {
      final String? token = await fetchSecureCacheStorage.fetch('token');

      if (token == null || token.isEmpty == true) {
        throw RepositoryError.forbidden;
      }

      final RemoteSurveyResultModel? model =
          await surveyRepository.saveSurveyResult(
        userUid: token,
        surveyId: surveyId,
        answer: answer,
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

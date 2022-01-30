import './../../../domain/domain.dart';
import './../../../data/cache/cache.dart';

import './../../repositories/repositories.dart';
import './../../models/models.dart';

class FirebaseRemoteLoadSurveys implements LoadSurveys {
  final SurveyRepository surveyRepository;
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;

  FirebaseRemoteLoadSurveys({
    required this.surveyRepository,
    required this.fetchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final String? token = await fetchSecureCacheStorage.fetch('token');

      if (token == null || token.isEmpty == true) {
        throw RepositoryError.forbidden;
      }

      final List<RemoteSurveyModel>? list =
          await surveyRepository.getSurveys(userUid: token);

      if (list == null) {
        return [];
      }

      return list
          .map<SurveyEntity>((surveyModel) => surveyModel.toEntity())
          .toList();
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

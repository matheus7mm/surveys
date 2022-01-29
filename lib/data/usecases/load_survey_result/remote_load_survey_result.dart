import '../../../domain/domain.dart';

import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveyResult implements LoadSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveyResult({
    required this.url,
    required this.httpClient,
  });

  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    try {
      final json = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      error == HttpError.forbidden
          ? throw DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}
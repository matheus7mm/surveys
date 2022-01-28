import '../../../domain/domain.dart';

import '../../http/http.dart';
import '../../models/models.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({
    required this.url,
    required this.httpClient,
  });

  Future<SurveyResultEntity> save({required String answer}) async {
    try {
      final json = await httpClient.request(
        url: url,
        method: 'put',
        body: {'answer': answer},
      );
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch (error) {
      error == HttpError.forbidden
          ? throw DomainError.accessDenied
          : throw DomainError.unexpected;
    }
  }
}

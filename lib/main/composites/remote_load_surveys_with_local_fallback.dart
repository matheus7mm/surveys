import './../../domain/domain.dart';
import './../../data/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final LoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    required this.remote,
    required this.local,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();
      await local.save(surveys);
      return surveys;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
      await local.validate();
      return await local.load();
    }
  }
}

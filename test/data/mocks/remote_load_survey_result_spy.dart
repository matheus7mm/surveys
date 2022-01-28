import 'package:mocktail/mocktail.dart';

import 'package:surveys/domain/domain.dart';
import 'package:surveys/data/usecases/usecases.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoadBySurvey(SurveyResultEntity surveyResult) =>
      mockLoadBySurveyCall().thenAnswer((_) async => surveyResult);
  void mockLoadBySurveyError(DomainError error) =>
      mockLoadBySurveyCall().thenThrow(error);
}

import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/domain.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {
  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoadBySurvey(SurveyResultEntity surveyResult) =>
      mockLoadBySurveyCall().thenAnswer((_) async => surveyResult);
  void mockLoadBySurveyError(DomainError error) =>
      mockLoadBySurveyCall().thenThrow(error);
}

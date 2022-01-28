import 'package:mocktail/mocktail.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/domain.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {
  LocalLoadSurveyResultSpy() {
    mockValidate();
    mockSave();
  }

  When mockLoadBySurveyCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));
  void mockLoadBySurvey(SurveyResultEntity surveyResult) =>
      mockLoadBySurveyCall().thenAnswer((_) async => surveyResult);
  void mockLoadBySurveyError() =>
      mockLoadBySurveyCall().thenThrow(DomainError.unexpected);

  When mockValidateCall() => when(() => this.validate(any()));
  void mockValidate() => mockValidateCall().thenAnswer((_) async => _);
  void mockValidateError() => mockValidateCall().thenThrow(Exception());

  When mockSaveCall() =>
      when(() => this.save(surveyResult: any(named: 'surveyResult')));
  void mockSave() => mockSaveCall().thenAnswer((_) async => _);
  void mockSaveError() => mockSaveCall().thenThrow(Exception());
}

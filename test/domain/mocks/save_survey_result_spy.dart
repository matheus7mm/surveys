import 'package:mocktail/mocktail.dart';

import 'package:surveys/domain/domain.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveCall() => when(() => this.save(answer: any(named: 'answer')));
  void mockSave(SurveyResultEntity data) =>
      this.mockSaveCall().thenAnswer((_) async => data);
  void mockSaveError(DomainError error) => this.mockSaveCall().thenThrow(error);
}

import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/domain.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {
  When mockLoadCall() => when(() => this.load());
  void mockLoad(List<SurveyEntity> surveys) =>
      mockLoadCall().thenAnswer((_) async => surveys);
  void mockLoadError(DomainError error) => mockLoadCall().thenThrow(error);
}

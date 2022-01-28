import 'dart:async';
import 'package:surveys/presentation/mixins/mixins.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surveys/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final surveysController = StreamController<List<SurveyViewModel>>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();
  final navigateToController = StreamController<NavigationState?>();

  SurveysPresenterSpy() {
    when(() => this.surveysStream).thenAnswer((_) => surveysController.stream);
    when(() => this.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);

    when(() => this.loadData()).thenAnswer((_) async => _);
  }

  void emitSurveys(List<SurveyViewModel> data) => surveysController.add(data);
  void emitSurveysError(String error) => surveysController.addError(error);

  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void emitSessionExpired([bool show = true]) =>
      isSessionExpiredController.add(show);

  void emitNavigateTo(NavigationState navigationState) =>
      navigateToController.add(navigationState);

  void dispose() {
    surveysController.close();
    isSessionExpiredController.close();
    isLoadingController.close();
  }
}

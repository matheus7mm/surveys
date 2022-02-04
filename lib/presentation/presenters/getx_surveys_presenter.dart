import 'package:intl/intl.dart';
import 'package:get/get.dart';

import './../../domain/domain.dart';

import './../../ui/pages/pages.dart';
import './../../ui/helpers/helpers.dart';

import './../mixins/mixins.dart';

class GetxSurveysPresenter extends GetxController
    with LoadingManager, SessionManager, NavigationManager
    implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  final LogOut logOut;

  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({
    required this.loadSurveys,
    required this.logOut,
  });

  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map(
            (survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer,
            ),
          )
          .toList();
      isLoading = false;
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveys.subject
            .addError(UIError.unexpected.description, StackTrace.current);
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading = true;
      await logOut.logOut();
      navigateTo = NavigationState(route: '/login', clear: true);
    } on DomainError {
      _surveys.subject
          .addError(UIError.unexpected.description, StackTrace.current);
    } finally {
      isLoading = false;
    }
  }

  void goToSurveyResult(String surveyId) {
    navigateTo = NavigationState(
      route: '/survey_result/$surveyId',
      onPop: (_) {
        loadData();
      },
    );
  }
}

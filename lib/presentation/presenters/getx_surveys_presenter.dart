import 'dart:async';

import 'package:intl/intl.dart';
import 'package:get/get.dart';

import './../../domain/domain.dart';

import './../../ui/pages/pages.dart';
import './../../ui/helpers/helpers.dart';

import './../mixins/mixins.dart';

class SurveysState {
  List<SurveyViewModel> surveys = [];
}

class GetxSurveysPresenter extends GetxController
    with LoadingManager, SessionManager, NavigationManager
    implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  final LogOut logOut;

  var _controller = StreamController<SurveysState>.broadcast();
  var _state = SurveysState();

  void _update() => _controller.add(_state);

  void updateSurveys(List<SurveyViewModel> surveys) {
    _state.surveys = surveys;
    _update();
  }

  Stream<List<SurveyViewModel>> get surveysStream => _controller.stream.map(
        (state) => state.surveys,
      );

  GetxSurveysPresenter({
    required this.loadSurveys,
    required this.logOut,
  });

  Future<void> loadData() async {
    try {
      isLoading = true;
      final surveys = await loadSurveys.load();
      updateSurveys(surveys
          .map(
            (survey) => SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer,
            ),
          )
          .toList());
      isLoading = false;
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _controller.addError(UIError.unexpected.description);
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
      _controller.addError(UIError.unexpected.description, StackTrace.current);
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

  void close() {
    _controller.close();
  }
}

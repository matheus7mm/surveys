import 'dart:async';

import 'package:get/get.dart';

import '../../domain/domain.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/helpers.dart';
import './../mixins/mixins.dart';
import './../helpers/helpers.dart';

class SurveyResultState {
  SurveyResultViewModel? surveyResult;
}

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  var _controller = StreamController<SurveyResultState>.broadcast();
  var _state = SurveyResultState();

  void _update() => _controller.add(_state);

  void updateSurveyResult(SurveyResultViewModel surveyResult) {
    _state.surveyResult = surveyResult;
    _update();
  }

  Stream<SurveyResultViewModel?> get surveyResultStream => _controller.stream
      .map(
        (state) => state.surveyResult,
      )
      .distinct();

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.saveSurveyResult,
    required this.surveyId,
  });

  Future<void> loadData() async {
    await showResultOnAction(
        () => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  Future<void> save({required String answer}) async {
    await showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  Future<void> showResultOnAction(Future<SurveyResultEntity> action()) async {
    try {
      isLoading = true;
      final surveyResult = await action().timeout(Duration(seconds: 30));
      updateSurveyResult(surveyResult.toViewModel());
    } catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _controller.addError(
            UIError.unexpected.description, StackTrace.current);
      }
    } finally {
      isLoading = false;
    }
  }

  void close() {
    _controller.close();
  }
}

import 'package:flutter/material.dart';

import './../../../presentation/mixins/mixins.dart';

import './survey_viewmodel.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<bool> get isLoadingStream;
  Stream<bool> get isSessionExpiredStream;
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<NavigationState?> get navigateToStream;

  Future<void> loadData();
  Future<void> signOut();
  void goToSurveyResult(String surveyId);

  void close();
}

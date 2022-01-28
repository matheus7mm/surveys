import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../ui/pages/pages.dart';

import './../../factories.dart';

Widget makeSurveyResultPage() {
  return SurveyResultPage(
    presenter: makeGetxSurveyResultPresenter(Get.parameters['survey_id'] ?? ''),
  );
}

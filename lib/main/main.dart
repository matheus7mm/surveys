import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import './../ui/components/components.dart';
import './../ui/helpers/helpers.dart';
import './factories/factories.dart';

void main() {
  // To do in the Future: use FlutterNativeSplash.removeAfter(...)
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light,
    );

    AppConfig.setOrientation(portraitMode: true);

    return GetMaterialApp(
      title: '4Dev',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeSplashPage, transition: Transition.fade),
        GetPage(
          name: '/login',
          page: makeLoginPage,
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/signup',
          page: makeSignUpPage,
        ),
        GetPage(
          name: '/surveys',
          page: makeSurveysPage,
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/survey_result/:survey_id',
          page: makeSurveyResultPage,
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:mocktail/mocktail.dart';

import 'package:surveys/presentation/mixins/mixins.dart';
import 'package:surveys/ui/pages/pages.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {
  final navigateToController = StreamController<NavigationState?>();

  SplashPresenterSpy() {
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);

    when(() => this
            .checkAccount(durationInSeconds: any(named: 'durationInSeconds')))
        .thenAnswer((_) async => _);
  }

  void emitNavigateTo(NavigationState navigationState) =>
      navigateToController.add(navigationState);

  void dispose() {
    navigateToController.close();
  }
}

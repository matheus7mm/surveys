import 'dart:async';
import 'package:mocktail/mocktail.dart';

import 'package:surveys/presentation/mixins/mixins.dart';

import 'package:surveys/ui/helpers/helpers.dart';
import 'package:surveys/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final mainErrorController = StreamController<UIError?>();
  final navigateToController = StreamController<NavigationState?>();
  final isFormValidController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();

  LoginPresenterSpy() {
    when(() => this.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => this.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => this.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => this.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(() => this.auth()).thenAnswer((_) async => _);
  }

  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);

  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);

  void emitFormError() => isFormValidController.add(false);
  void emitFormValid() => isFormValidController.add(true);

  void emitLoading([bool show = true]) => isLoadingController.add(show);

  void emitMainError(UIError error) => mainErrorController.add(error);

  void emitNavigateTo(NavigationState navigationState) =>
      navigateToController.add(navigationState);

  void dispose() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }
}

import 'package:flutter/material.dart';

import './../../../presentation/mixins/mixins.dart';

import './../../helpers/errors/errors.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get mainErrorStream;
  Stream<NavigationState?> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail(String email);
  void validatePassword(String email);
  Future<void> auth();
  void goToSignUp();
}

import 'package:flutter/material.dart';
import 'package:surveys/ui/helpers/i18n/resources.dart';
import 'package:provider/provider.dart';

import './../../../components/components.dart';

import './../login_presenter.dart';

class LoginButton extends StatelessWidget {
  final double buttonWidth;

  LoginButton({required this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return PrimaryButton(
          onPressed: snapshot.data == true ? presenter.auth : null,
          buttonText: R.strings.login.toUpperCase(),
          overlayColor: colorBrandPrimaryDarkest,
          backgroundColor: colorBrandPrimaryDark,
          backgroundDisabledColor: colorBrandPrimaryLight,
          totalWidth: buttonWidth,
        );
      },
    );
  }
}

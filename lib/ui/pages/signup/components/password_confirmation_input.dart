import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import './../../../components/components.dart';

import '../signup_presenter.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
        stream: presenter.passwordConfirmationErrorStream,
        builder: (context, snapshot) {
          return Input(
            onChangedFunction: presenter.validatePasswordConfirmation,
            hintText: 'Zlue@123',
            labelText: R.strings.confirmPassword,
            errorText: snapshot.data?.description,
            prefix: Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            obscureText: true,
          );
        });
  }
}

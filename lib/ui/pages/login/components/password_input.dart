import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../../helpers/helpers.dart';
import './../../../components/components.dart';

import './../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return Input(
          onChangedFunction: presenter.validatePassword,
          hintText: 'Zlue@123',
          labelText: R.strings.password,
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
      },
    );
  }
}

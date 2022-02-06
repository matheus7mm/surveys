import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../../../helpers/helpers.dart';
import './../login_presenter.dart';

import './../../../components/components.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return Input(
          onChangedFunction: presenter.validateEmail,
          hintText: 'matheus@gmail.com',
          labelText: R.strings.email,
          errorText: snapshot.data?.description,
          keyboardType: TextInputType.emailAddress,
          prefix: Padding(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        );
      },
    );
  }
}

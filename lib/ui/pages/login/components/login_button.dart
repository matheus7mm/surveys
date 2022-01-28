import 'package:flutter/material.dart';
import 'package:fordev/ui/helpers/i18n/resources.dart';
import 'package:provider/provider.dart';

import './../login_presenter.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
          onPressed: snapshot.data == true ? presenter.auth : null,
          child: Text(
            R.strings.enter.toUpperCase(),
          ),
        );
      },
    );
  }
}

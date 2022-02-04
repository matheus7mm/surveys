import 'package:flutter/material.dart';

import './../helpers/helpers.dart';

Future<void> showLoading(BuildContext context) async {
  await Future.delayed(Duration.zero);
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => SimpleDialog(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(
              '${R.strings.wait}...',
              textAlign: TextAlign.center,
            ),
          ],
        )
      ],
    ),
  );
}

Future<void> hideLoading(BuildContext context) async {
  await Future.delayed(Duration.zero);
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}

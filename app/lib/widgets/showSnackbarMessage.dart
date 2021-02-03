import 'package:flutter/material.dart';

void showSnackbarMessage(BuildContext context, String message,
    {int duration = 1}) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: duration),
  ));
}

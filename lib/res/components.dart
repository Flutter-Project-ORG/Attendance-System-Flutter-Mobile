import 'package:flutter/material.dart';

class Components {
  static void showSuccessSnackBar(BuildContext context,
      {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
  static void showErrorSnackBar(BuildContext context,
      {required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}

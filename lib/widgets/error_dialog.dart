import 'package:flutter/material.dart';

class ErrorDialog {
  static Future<void> openDialog(context, String? message) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error occurred!'),
        content: Text(
          message ??
              'Something went wrong!\n\nPlease check your internet connection or try again later!',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}

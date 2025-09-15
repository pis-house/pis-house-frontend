import 'package:flutter/material.dart';

class PisErrorSnackBar {
  final String message;
  PisErrorSnackBar(this.message);

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: '閉じる',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

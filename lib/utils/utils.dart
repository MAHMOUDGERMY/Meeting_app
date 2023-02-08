import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text, bool isSuccess) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
      ),
    ),
  );
}

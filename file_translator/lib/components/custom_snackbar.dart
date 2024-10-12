import 'package:flutter/material.dart';
import 'package:sub_translator/globals.dart';

void showCustomSnackbar({
  required String message,
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  snackbarKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: actionLabel ?? '',
        onPressed: onActionPressed ?? () {},
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.blue,
    ),
  );
}

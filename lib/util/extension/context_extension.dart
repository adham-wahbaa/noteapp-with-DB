import 'package:flutter/material.dart';

extension ContextExtension on BuildContext{
  void showSnackBar(String message){
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:tracking_app_v1/theme/border_styles.dart';

class FormSubmitButton extends StatelessWidget {
  final BuildContext context;
  final Color backgroundColor;
  final Color textColor;
  final String title;
  final VoidCallback? method;

  const FormSubmitButton(
      {super.key,
      required this.context,
      required this.backgroundColor,
      required this.textColor,
      required this.title,
      this.method});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: backgroundColor,
      textColor: textColor,
      minWidth: double.infinity,
      height: 60,
      shape: BorderStyles.buttonBorder,
      onPressed: method,
      child: Text(title),
    );
  }
}

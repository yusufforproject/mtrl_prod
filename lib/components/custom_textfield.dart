// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtrl_prod/components/uppercase.dart';

import '../core/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Color color;
  final IconData? icon;
  final bool boldText;
  final String label;
  final bool enabled;
  final TextInputType keyboardType;
  final Null Function(dynamic value) onFieldSubmitted;
  final TextAlign textAlign;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.color,
    required this.icon,
    required this.boldText,
    required this.label,
    required this.enabled,
    required this.keyboardType,
    required this.onFieldSubmitted,
    required this.textAlign,
    this.autofocus,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus ?? false,
      controller: controller,
      inputFormatters: inputFormatters != null
          ? [
              UpperCaseTextFormatter(),
              ...inputFormatters!,
            ] // Add the custom formatter to the inputFormatters.
          : [UpperCaseTextFormatter()],
      keyboardType: keyboardType,
      textAlign: textAlign,
      style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: boldText ? FontWeight.bold : FontWeight.normal),
      decoration: InputDecoration(
        suffixIcon: icon != null
            ? Icon(
                icon,
                color: enabled ? color : Colors.grey[600],
              )
            : null,
        labelText: label,
        labelStyle: TextStyle(
          color: enabled ? color : Colors.grey[600],
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: color, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: color,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: color,
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.grey[600]!,
            width: 2.0,
          ),
        ),
        enabled: enabled,
        // hintText: label,
        // hintStyle: TextStyle(
        //   color: enabled ? color : Colors.grey[600],
        //   fontSize: 16,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
      onFieldSubmitted: (value) {
        onFieldSubmitted(value);
      },
    );
  }
}

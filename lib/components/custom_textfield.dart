// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Color color;
  final IconData icon;
  final bool boldText;
  final String label;
  final bool enabled;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.color,
    required this.icon,
    required this.boldText,
    required this.label,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: boldText ? FontWeight.bold : FontWeight.normal),
      decoration: InputDecoration(
        suffixIcon: Icon(
          icon,
          color: enabled ? color : Colors.grey[600],
        ),
        labelText: label,
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
      ),
    );
  }
}

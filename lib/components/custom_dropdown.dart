// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final Color borderColor;
  final String label;
  final bool enabled;
  final bool textBold;
  final List<Map<String, dynamic>> items;
  final T? value;
  final void Function(T?) onChanged;

  const CustomDropdownButtonFormField({
    super.key,
    required this.borderColor,
    required this.label,
    required this.enabled,
    required this.textBold,
    required this.items,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: textBold ? FontWeight.bold : FontWeight.normal),  
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[600]!, width: 2),),
        enabled: enabled
        ),
      items: items.map<DropdownMenuItem<T>>(
        (Map<String, dynamic> item) {
          return DropdownMenuItem<T>(
            value: item['$value'],
            child: Text(item['$value']),
          );
        }
      ).toList(),
      onChanged: onChanged,
    );
  }
}


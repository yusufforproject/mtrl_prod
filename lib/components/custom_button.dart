// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color txtColor;
  final Color bgColor;
  final void Function()? onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.icon,
    required this.txtColor,
    required this.bgColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.only(left: 8, right: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      onPressed: () {
        onPressed!();
      },
      child: Row(
        children: [
          Icon(icon, color: txtColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: txtColor),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../core/app_colors.dart';


loading(BuildContext context, {String? message, bool? barrierDismissible}) {
  showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info, color: AppColors.primary),
              SizedBox(width: 10),
              Text('Information', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          content: SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
                ),
                const SizedBox(height: 10),
                Text(message ?? 'Loading...'),
              ],
            ),
          ),
        );
      });
}

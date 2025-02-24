// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/variable.dart';
import '../pages/config_page.dart'; // Adjust the import according to your project structure

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final String title;
  final String subtitle;
  final bool config;
  final Color backgroundColor;

  CustomAppBar({
    Key? key,
    required this.subtitle,
    required this.config,
    this.backgroundColor = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Variable.appName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '$subtitle | ${Variable.sectDescription} ${Variable.subSecDescription}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
      backgroundColor: backgroundColor,
      actions: [
        if(config == true)
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: () async {
                final password = await showDialog<String>(
                  context: context,
                  builder: (context) {
                    final controller = TextEditingController();
                    return AlertDialog(
                      title: const Text(
                        'Password Required',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      content: TextField(
                        style: const TextStyle(fontSize: 14),
                        controller: controller,
                        obscureText: true,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.lightorange,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.lightorange,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: AppColors.lightorange,
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(controller.text),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                if (password == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password cannot be empty'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  if (password == '4dm1nsatu23') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ConfigPage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Wrong password'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ));
                  }
                }
              },
              tooltip: 'Enter your password',
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

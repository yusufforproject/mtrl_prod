  import 'package:flutter/material.dart';

bool _validateSave(dynamic _qtyController, dynamic _materialController, BuildContext context) {
    if (_materialController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Material harus diisi"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jumlah harus diisi"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (int.parse(_qtyController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Jumlah harus lebih dari 0"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

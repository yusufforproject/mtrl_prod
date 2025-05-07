import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/variable.dart';


Future<bool> cekOpr(opr) async {
  try {
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/apis/cek_opr.php'),
      body: {
        'oprcode': opr,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        List<dynamic> dataOpr = data['data'];
        var firstItem = dataOpr.first;
        Variable.oprCode = firstItem['oprcode'];
        Variable.oprName = firstItem['oprname'];
        print('ini oprcode: ${Variable.oprCode}');
        print('ini oprname: ${Variable.oprName}');
        Variable.isLoggedIn = true;
        return true;
      } else {
        print('No data found');
        return false;
      }
    } else {
      print('Server error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error occurred: $e');
    return false;
  }
}

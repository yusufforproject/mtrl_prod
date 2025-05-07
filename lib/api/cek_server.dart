import 'package:flutter/material.dart';

import '../core/variable.dart';
import 'package:http/http.dart' as http;

Future<bool> checkServerStatus() async {
  try {
    // var timeout;
    final response = await http
        .get(Uri.parse('${Variable.baseUrl}/apis/cek_server.php'))
        .timeout(const Duration(milliseconds: 2700), onTimeout: () {
      // timeout = true;
      return http.Response('Timeout', 408);
    });
    if (response.statusCode == 408) {
      return Variable.serverStatus = false;
      // return false;
    } else {
      return Variable.serverStatus = response.statusCode == 200;
      // return Variable.serverStatus = false;
      // return response.statusCode == 200;
    }
      // Variable.serverStatus == true;
      // return true;
    // return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

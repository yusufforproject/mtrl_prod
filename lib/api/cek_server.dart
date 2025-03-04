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
    // Variable.serverStatus = response.statusCode == 200;
    // debugPrint('Server status: ${Variable.serverStatus}');
    if (response.statusCode == 408) {
      return false;
    } else {
      return response.statusCode == 200;
    }
    // return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}

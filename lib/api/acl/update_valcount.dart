import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mtrl_prod/core/variable.dart';

Future<String> updateValcount(roll, mcn) async {
  final response = await http
      .post(Uri.parse('${Variable.baseUrl}/apis/acl/updt_valcount.php'), body: {
    'roll': roll,
    'mcn': mcn,
  });
  Map<String, dynamic> data = jsonDecode(response.body);

  return data['status'];
}

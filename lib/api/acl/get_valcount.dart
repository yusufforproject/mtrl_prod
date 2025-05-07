import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/variable.dart';

Future<bool> getValcount() async {
  final response = await http.post(Uri.parse('${Variable.baseUrl}/apis/acl/get_valcount.php'), body: {
    'mcn':Variable.mcnSelected
  });
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    // Variable.dataMcnCounter.add({
    //   'valcount': data['valcount']
    // });
    Variable.valcount = data['valcount'];
    print(Variable.valcount);
    return true;
  } else {
    return false;
  }
}
import 'dart:convert';


import '../core/sqflite_data.dart';
import '../core/variable.dart';
import 'package:http/http.dart' as http;

Future<bool> uploadLocalData() async {
  try {
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/apis/upload_local_data.php'),
      body: jsonEncode(Variable.allBarcodesLocal),
    );
    print('ini response: ${response.body}');
    if (response.statusCode == 200) {
      DatabaseHelper().deleteAllAcl();
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

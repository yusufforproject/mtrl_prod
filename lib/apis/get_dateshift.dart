import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/variable.dart';

Future<void> getDateshift() async {
  final response = await http.get(Uri.parse('${Variable.baseUrl}/apis/get_dateshift.php'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data.containsKey('data')) {
      List<dynamic> dataDateshift = data['data'];
      var firstItem = dataDateshift.first;
      Variable.dateSys = firstItem['tgl'];
      Variable.shfSys = firstItem['shf'];
      Variable.groupSys = firstItem['grp'];
      // Variable.group = dataDateshift.length.toString();
    }
    print('Data from system:');
    print('ini dateshift: ${Variable.dateSys}${Variable.shfSys}');
    print('ini group: ${Variable.groupSys}');
    print('Data dari user:');
    print('ini pickedDate: ${Variable.pickedDate}');
    print('ini shift: ${Variable.shift}');
    print('ini group: ${Variable.group}');

  } else {
    throw Exception('Failed to load dateshift');
  }
}

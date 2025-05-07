import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/variable.dart';

Future<bool> getDateshift() async {
  // if (Variable.serverStatus == false) {
  //   return;
  // } else {
  final response =
      await http.get(Uri.parse('${Variable.baseUrl}/apis/get_dateshift.php'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data.containsKey('data')) {
      List<dynamic> dataDateshift = data['data'];
      var firstItem = dataDateshift.first;
      Variable.dateSys = firstItem['tgl'];
      switch (firstItem['shf']) {
        case 'I':
          Variable.shfSys = '1';
          break;
        case 'II':
          Variable.shfSys = '2';
          break;
        case 'III':
          Variable.shfSys = '3';
          break;
        default:
          Variable.shfSys = '1';
      }
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
    return true;
  } else {
    return false;
    // throw Exception('Failed to load dateshift');
  }
  // }
}

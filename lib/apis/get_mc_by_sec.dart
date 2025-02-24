import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/variable.dart';


Future<bool> getMcnList() async {
  try {
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/apis/get_mc_by_sec.php'),
      body: {
        'section': '${Variable.sect}${Variable.subSec}',
      },
    );
    // print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        List<dynamic> dataMcn = data['data'];
        Variable.mcnList = [];
        dataMcn.forEach((item) {
          Variable.mcnList.add({
            'mcn': item['mcn'],
          });
        });
        print('ini mcnList: ${Variable.mcnList}'); // print(Variable.mcnList);
        print('ini mcnSelected: ${Variable.mcnSelected}');
        return true;
      } else {
        print('No machine found');
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

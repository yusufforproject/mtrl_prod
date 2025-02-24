import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/variable.dart';


Future<bool> getItems() async {
  try {
    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/apis/get_items.php'),
      // body: {
      //   'sec': '${Variable.sect}${Variable.subSec}',
      // },
    );
    // print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        List<dynamic> dataItems = data['data'];
        Variable.items = [];
        dataItems.forEach((item) {
          Variable.items.add({
            'item': item['item'],
            'descr': item['descr']
          });
        });
        print('ini items: ${Variable.items}'); // print(Variable.mcnList);
        print('ini items.length: ${Variable.items.length}'); // print(Variable.mcnList);
        return true;
      } else {
        print('No items found');
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

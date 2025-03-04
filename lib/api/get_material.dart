import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/variable.dart';

Future<bool> getMaterial(qrMtrl) async {
  if (Variable.serverStatus == false) {
    return false;
  } else {
    try {
      final response = await http.get(
        Uri.parse('${Variable.baseUrl}/apis/get_material.php?qrcode=$qrMtrl'),
        // body: {
        //   'sec': '${Variable.sect}${Variable.subSec}',
        // },
      );
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('data')) {
          List<dynamic> dataMaterial = data['data'];
          Variable.treatmentDetails = [];
          for (var item in dataMaterial) {
            Variable.treatmentDetails.add({
              'bc_entried': item['bc_entried'],
              'akt': item['akt'],
              'uom': item['uom'],
              'mesin': item['mesin'],
              'idkary': item['idkary'],
              'idprint': item['idprint'],
              'idroll': item['idroll'],
              'tglprod': item['tglprod'],
              'jdge': item['jdge'],
            });
          }
          bool hasNull = Variable.treatmentDetails.any((element) {
            return element.values.any((value) => value == null);
          });

          if (hasNull) {
            Variable.treatmentDetails = [];
          }
          print(
              'ini treatment: ${Variable.treatmentDetails}'); // print(Variable.mcnList);
          return true;
        } else {
          print('No treatment found');
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
}

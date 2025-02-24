import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../core/variable.dart';


Future<bool> getBarcodes() async {
  try {
    var getDt = Variable.pickedDate.isEmpty
        ? DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(Variable.dateSys))
        : DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(Variable.pickedDate));
    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/apis/get_barcodes.php?dt=$getDt&opr=${Variable.oprCode}&mcn=${Variable.mcnSelected}'),
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        List<dynamic> dataBarcodes = data['data'];
        Variable.barcodes = [];
        dataBarcodes.forEach((item) {
          Variable.barcodes.add({
            'size': item['size'],
            'qcode_sch': item['qcode_sch'],
            'qtysch': item['qtysch'],
            'akt': item['akt'],
          });
        });
        print('ini barcodes: ${Variable.barcodes}'); // print(Variable.mcnList);
        print('ini barcodes.length: ${Variable.barcodes.length}'); // print(Variable.mcnList);
        return true;
      } else {
        print('No barcodes found');
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

Future<bool> getBarcodesById() async {
  try {
    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/apis/get_barcodes_by_id.php?qcode_sch=${Variable.schedules[0]['qcode_sch']}&id=${Variable.idPrint}'),
      // body: {
      //   'sec': '${Variable.sect}${Variable.subSec}',
      // },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        List<dynamic> dataBarcodes = data['data'];
        Variable.barcodesById = [];
        dataBarcodes.forEach((item) {
          Variable.barcodesById.add({
            'bc_entried': item['bc_entried'],
            'expireddt': item['expireddt'],
            'merge_time': item['merge_time'],
            'idtag': item['idtag'],
            'descr': item['descr'],
            'mcn': item['mcn'],
            'opr': item['opr'],
            'oprname': item['oprname'],
            'qty': item['qty'],
            'uom': item['uom'],
            'created_at': item['created_at'],
            'isChecked': false,
          });
        });
        print('ini barcodes by id: ${Variable.barcodesById}'); // print(Variable.mcnList);
        print('ini barcodes.length: ${Variable.barcodesById.length}'); // print(Variable.mcnList);
        return true;
      } else {
        print('No barcodes found');
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

Future<bool> getBarcodesBySch() async {
  try {
    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/apis/get_barcodes_by_sch.php?qrcode=${Variable.schedules[0]['qcode_sch']}'),
      // body: {
      //   'sec': '${Variable.sect}${Variable.subSec}',
      // },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        List<dynamic> dataBarcodes = data['data'];
        Variable.barcodesBySch = [];
        for (var item in dataBarcodes) {
          Variable.barcodesBySch.add({
            'bc_entried': item['bc_entried'],
            'expireddt': item['expireddt'],
            'merge_time': item['merge_time'],
            'idprint': item['idprint'],
            'idroll': item['idroll'],
            'idtag': item['idtag'],
            'descr': item['descr'],
            'mcn': item['mcn'],
            'opr': item['opr'],
            'oprname': item['oprname'],
            'qty': item['qty'],
            'uom': item['uom'],
            'created_at': item['created_at'],
            'isChecked': false,
          });
        }
        print('ini barcodes by sch: ${Variable.barcodesBySch}'); // print(Variable.mcnList);
        print('ini barcodes.length: ${Variable.barcodesBySch.length}'); // print(Variable.mcnList);
        return true;
      } else {
        print('No barcodes found');
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
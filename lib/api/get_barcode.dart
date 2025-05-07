import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../core/variable.dart';

var getDt = Variable.pickedDate.isEmpty
    ? DateFormat('yyyy-MM-dd')
        .format(DateFormat('dd/MM/yyyy').parse(Variable.dateSys))
    : DateFormat('yyyy-MM-dd')
        .format(DateFormat('dd/MM/yyyy').parse(Variable.pickedDate));
var shf = Variable.pickedDate.isEmpty ? Variable.shfSys : Variable.shift;
var grp = Variable.pickedDate.isEmpty ? Variable.groupSys : Variable.group;
Future<bool> getBarcodes() async {
  try {
    final response = await http.get(
      Uri.parse(
          '${Variable.baseUrl}/apis/get_barcodes.php?dt=$getDt&opr=${Variable.oprCode}&sec=${Variable.sect}${Variable.subSec}'),
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        List<dynamic> dataBarcodes = data['data'];
        Variable.barcodesForRekap = [];
        dataBarcodes.forEach((item) {
          Variable.barcodesForRekap.add({
            'itemcode': item['itemcode'],
            'qcode_sch': item['qcode_sch'],
            'sch': item['sch'],
            'akt': item['akt'],
            'ydate_shift': item['ydate_shift'],
          });
        });
        print(
            'ini barcodesForRekap: ${Variable.barcodesForRekap}'); // print(Variable.mcnList);
        print(
            'ini barcodes.length: ${Variable.barcodesForRekap.length}'); // print(Variable.mcnList);
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
  if (Variable.serverStatus == false) {
    return false;
  } else {
    try {
      final response = await http.get(
        Uri.parse(
            '${Variable.baseUrl}/apis/get_barcodes_by_id.php?qcode_sch=${Variable.schedules[0]['qcode_sch']}&id=${Variable.idPrint}'),
        // body: {
        //   'sec': '${Variable.sect}${Variable.subSec}',
        // },
      );
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('data')) {
          List<dynamic> dataBarcodes = data['data'];
          Variable.barcodesForFetching = [];
          dataBarcodes.forEach((item) {
            Variable.barcodesForFetching.add({
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
          print(
              'ini barcodes for fetching: ${Variable.barcodesForFetching}'); // print(Variable.mcnList);
          print(
              'ini barcodes.length: ${Variable.barcodesForFetching.length}'); // print(Variable.mcnList);
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
}

Future<bool> getBarcodesBySch() async {
  if (Variable.serverStatus == false) {
    return false;
  } else {
    try {
      final response = await http.get(
        Uri.parse(
            '${Variable.baseUrl}/apis/get_barcodes_by_sch.php?qcode_sch=${Variable.schedules[0]['qcode_sch']}'),
        // body: {
        //   'sec': '${Variable.sect}${Variable.subSec}',
        // },
      );
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('data')) {
          List<dynamic> dataBarcodes = data['data'];
          Variable.barcodesForFetching = [];
          for (var item in dataBarcodes) {
            Variable.barcodesForFetching.add({
              'bc_entried': item['bc_entried'],
              'bc_alias': item['bc_alias'],
              'expireddt': item['expireddt'],
              'merge_time': item['merge_time'],
              'idprint': item['idprint'],
              'idroll': item['idroll'],
              'idtag': item['idtag'],
              'descr': item['descr'],
              'mcn': item['mcn'],
              'opr': item['opr'],
              'oprname': item['oprname'].trim(),
              'qty': item['qty'],
              'uom': item['uom'],
              'created_at': item['created_at'],
              'isChecked': false,
            });
          }
          print(
              'ini barcodes for fetching: ${Variable.barcodesForFetching}'); // print(Variable.mcnList);
          print(
              'ini barcodes.length: ${Variable.barcodesForFetching.length}'); // print(Variable.mcnList);
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
}

Future<void> getDetailsBarcode(qcodeSch) async {
  print('ini qcodeSch: $qcodeSch');
  print('ini getDt: $getDt');
  print('ini shf: $shf');
  print('ini grp: $grp');
  print('ini mcn: ${Variable.mcnSelected}');
  print('ini opr: ${Variable.oprCode}');
  print('ini sec: ${Variable.sect}${Variable.subSec}');
  try {
    final response = await http.get(
      Uri.parse(
          '${Variable.baseUrl}/apis/get_details.php?qcode_sch=$qcodeSch&dt=$getDt&shf=$shf&grp=$grp&mcn=${Variable.mcnSelected}&opr=${Variable.oprCode}&sec=${Variable.sect}${Variable.subSec}'),
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        List<dynamic> dataBarcodes = data['data'];
        Variable.detailsBarcode = [];
        dataBarcodes.forEach((item) {
          Variable.detailsBarcode.add({
            'bc_entried': item['bc_entried'],
            'idprint': item['idprint'],
            'idroll': item['idroll'],
            'txndate': item['txndate'],
            'qty': item['qty'],
          });
        });
        print('ini detailsBarcode: ${Variable.detailsBarcode}');
      }
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/variable.dart';

Future<bool> getSchedule(qrSch) async {
  if (Variable.serverStatus == false) {
    return false;
  } else {
    try {
      final response = await http.get(
        Uri.parse('${Variable.baseUrl}/apis/get_schedule.php?qrcode=$qrSch'),
        // body: {
        //   'sec': '${Variable.sect}${Variable.subSec}',
        // },
      );
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('data')) {
          List<dynamic> dataSchedule = data['data'];
          Variable.schedules = [];
          for (var item in dataSchedule) {
            Variable.schedules.add({
              'size': item['size'],
              'descr': item['descr'],
              'qtysch': item['qtysch'],
              'act': item['act'],
              'qcode_sch': item['qcode_sch'],
            });
          }

          if (Variable.schedules
              .any((element) => element.containsValue(null))) {
            Variable.schedules = [];
            return false;
          }

          List<dynamic> dataParent = data['parent'];
          Variable.parent = [];
          for (var item in dataParent) {
            Variable.parent.add({
              'parent': item['parent'],
            });
          }

          List<dynamic> dataBom = data['bom'];
          Variable.bom = [];
          for (var item in dataBom) {
            Variable.bom.add({
              'child': item['child'],
              'qty': item['qty'],
            });
          }
          print('ini schedule: ${Variable.schedules}');
          print('ini parent: ${Variable.parent}');
          print('ini bom: ${Variable.bom}');
          return true;
        } else {
          print('No schedule found');
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

Future<bool> getSuratJalan() async {
  if (Variable.serverStatus == false) {
    return false;
  } else {
    var tanggal =
        Variable.pickedDate.isEmpty ? Variable.dateSys : Variable.pickedDate;
    var shift = Variable.shift.isEmpty ? Variable.shfSys : Variable.shift;
    // var shift = Variable.shift.isEmpty ? Variable.shfSys : Variable.shift;
    try {
      final response = await http.get(
        Uri.parse(
            '${Variable.baseUrl}/apis/get_suratjalan.php?tanggal=$tanggal&shift=$shift&mc=${Variable.mcnSelected}&opr=${Variable.oprCode}'),
        // body: {
        //   'sec': '${Variable.sect}${Variable.subSec}',
        // },
      );
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('data')) {
          List<dynamic> suratJalan = data['data'];
          Variable.suratJalan = [];
          for (var item in suratJalan) {
            Variable.suratJalan.add({
              'item_abc': item['item_abc'],
              'qcode_sch': item['qcode_sch'],
              'item_asq': item['item_asq'],
              'qtysch': item['qtysch'],
              'mtr': item['mtr'],
              'isChecked': false,
            });
          }

          if (Variable.suratJalan
              .any((element) => element.containsValue(null))) {
            Variable.suratJalan = [];
            return false;
          }

          print('ini srt jalan: ${Variable.suratJalan}');
          return true;
        } else {
          print('No surat jalan found');
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

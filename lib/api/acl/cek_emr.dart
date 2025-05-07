import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/variable.dart';

Future<bool> cekBarcodeEmr(ym, roll, mcn) async {
  final response = await http.post(
      Uri.parse('${Variable.baseUrl}/apis/acl/cek_emr.php'),
      body: {'yrmnth': ym, 'roll': roll, 'mcn': mcn});
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> dataEmr = data['data'];
    print(data);
    Variable.barcodeEmr.clear();
    dataEmr.forEach((item) {
      Variable.barcodeEmr.add({
        'bc_entried': item['bc_entried'],
        'descr': item['descr'],
        'qty': item['qty'],
        'uom': item['uom'],
        'mcn': item['mcn'],
        'opr': item['opr'],
        'oprname': item['oprname'].trim(),
        'expireddt': item['expireddt'],
        'merge_time': item['merge_time'],
        'merge_date': item['merge_date'],
        'idprint': item['idprint'],
        'idroll': item['idroll'],
        'created_at': item['created_at'],
      });
    });
    print('barcode emr: ${Variable.barcodeEmr}');
    return true;
  } else {
    return false;
  }
}

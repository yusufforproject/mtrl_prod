import 'package:http/http.dart' as http;
import '../core/variable.dart';

Future<bool> addNewBarcode(String qty) async {
  Variable.idPrint = '${Variable.mcnSelected}-${DateTime.now().millisecondsSinceEpoch}';
  final response = await http.post(
    Uri.parse('${Variable.baseUrl}/apis/add_barcode.php'),
    body: {
      'tanggal': Variable.pickedDate.isEmpty ? Variable.dateSys : Variable.pickedDate,
      'shift': Variable.pickedDate.isEmpty ? Variable.shfSys : Variable.shift,
      'grp': Variable.pickedDate.isEmpty ? Variable.groupSys : Variable.group,
      'mcn': Variable.mcnSelected,
      'size': Variable.schedules[0]['size'],
      'qty': qty,
      'opr': Variable.oprCode,
      'idprint': Variable.idPrint,
      'qcode_sch': Variable.schedules[0]['qcode_sch'],
      'mtrl': Variable.treatmentDetails[0]['bc_entried'],
      'section': Variable.sect,
    },
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
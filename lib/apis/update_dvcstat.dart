import 'package:http/http.dart' as http;
import '../core/variable.dart';

Future<bool> updateDvcStat(String typeStat) async {
  final response = await http.post(
    Uri.parse('${Variable.baseUrl}/apis/update_dvcstat.php'),
    body: {
      'type_stat': typeStat,
      'dateshfgrp': Variable.pickedDate.isEmpty
          ? '${Variable.dateSys}-${Variable.shfSys}${Variable.groupSys}'
          : '${Variable.pickedDate}-${Variable.shift}${Variable.group}',
      'section': Variable.sect + Variable.subSec,
      'on_app': Variable.appName,
      'on_ver': Variable.appVersion,
      'on_dvc': Variable.dvcId,
      'on_mcn': Variable.dvcPlaced,
      'oprcode': Variable.oprCode,
      'oprname': Variable.oprName,
    },
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

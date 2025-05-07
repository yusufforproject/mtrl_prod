import '../core/variable.dart';

Future<String> validationAcl() async {
  if (Variable.materials.isEmpty) {
    return 'empty';
  }
  if (Variable.serverStatus == true) {
    for (var bom in Variable.bom) {
      if (!Variable.materials.any((material) => material['item_mtrl'] == bom['child'])) {
      return 'unmatch';
      }
    }
    if (Variable.schedules[0]['act'] > Variable.schedules[0]['qtysch']) {
      return 'over';
    }
    return 'ok';
  } else {
    return 'ok';
  }
}

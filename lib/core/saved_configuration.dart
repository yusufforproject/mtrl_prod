import 'package:shared_preferences/shared_preferences.dart';

import 'variable.dart';

class SavedConfiguration {

  static Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('main_ip', Variable.baseUrl);
    await prefs.setString('mix_ip', Variable.mixIP);
    await prefs.setString('section', Variable.sect);
    await prefs.setString('subsection', Variable.subSec);
    await prefs.setString('device_id', Variable.dvcId);
    await prefs.setString('device_placed', Variable.dvcPlaced);
  }


  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    Variable.baseUrl = prefs.getString('main_ip') ?? Variable.baseUrl;
    Variable.mixIP = prefs.getString('mix_ip') ?? Variable.mixIP;
    Variable.sect = prefs.getString('section') ?? Variable.sect;
    Variable.subSec = prefs.getString('subsection') ?? Variable.subSec;
    Variable.dvcId = prefs.getString('device_id') ?? Variable.dvcId;
    Variable.dvcPlaced = prefs.getString('device_placed') ?? Variable.dvcPlaced;
  }
}
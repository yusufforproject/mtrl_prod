import 'package:flutter_dotenv/flutter_dotenv.dart';

class Variable {
  static String baseUrl = dotenv.env['BASE_URL']!;
  static String mixIP = dotenv.env['MIX_URL']!;
  static String sect = 'ABC';
  static String get sectDescription {
    switch (sect) {
      case 'ABG':
        return 'Bead Grommet';
      case 'ACL':
        return 'Topping Calendar';
      case 'ABC':
        return 'Bias Cutting';
      case 'ASQ':
        return 'Squeegee';
      case 'ATE':
        return 'Tread Extruder';
      // Add more cases as needed
      default:
        return 'Unknown section';
    }
  }

  static String get uomBySect {
    switch (sect + subSec) {
      case 'ABG-SL':
        return 'ROLL';
      case 'ACL':
        return 'ROLL';
      case 'ABC':
        return 'ROLL';
      case 'ASQ':
        return 'ROLL';
      case 'ATE':
        return 'PCS';
      // Add more cases as needed
      default:
        return 'PCS';
    }
  }

  static String subSec = '';
  static String get subSecDescription {
    switch (subSec) {
      case '-SL':
        return '- Slitter';
      case '-AP':
        return '- Apex';
      case '-FO':
        return '- Forming';
      case '-FP':
        return '- Flipper';
      // Add more cases as needed
      default:
        return '';
    }
  }

  static var appName = "MATERIAL PROD";
  static var appSubtitle = "Material Production";
  static var appVersion = "v2.0.0 - 25.02";
  static var dvcId = "SC23001";
  static var dvcPlaced = "Office";

  static List<Map<String, dynamic>> get offlineMcnList {
    switch (sect) {
      case 'ABG':
        return [
          {'mcn': 'ABG1'},
          {'mcn': 'ABG2'},
          // Add more machines as needed
        ];
      case 'ACL':
        return [
          {'mcn': 'ACL01'},
          {'mcn': 'ACL02'},
          // Add more machines as needed
        ];
      case 'ABC':
        return [
          {'mcn': 'ABC1'},
          {'mcn': 'ABC2'},
          {'mcn': 'ABC3'},
          {'mcn': 'ABC4'},
          {'mcn': 'ABC5'},
          {'mcn': 'ABC6'},
          {'mcn': 'ABC7'},
          {'mcn': 'ABC8'},
          {'mcn': 'ABC9'},
          {'mcn': 'ABC10'},
          {'mcn': 'ABC11'},
        ];
      case 'ASQ':
        return [
          {'mcn': 'ASQ01'},
          {'mcn': 'ASQ02'},
          // Add more machines as needed
        ];
      case 'ATE':
        return [
          {'mcn': 'ATE01'},
          {'mcn': 'ATE02'},
          // Add more machines as needed
        ];
      // Add more cases as needed
      default:
        return [];
    }
  }

  // data by system
  static var dateSys = "";
  static var shfSys = "";
  static var groupSys = "";
  static List<Map<String, dynamic>> mcnList = [];
  static List<Map<String, dynamic>> items = [];
  static List<Map<String, dynamic>> barcodes = [];
  static List<Map<String, dynamic>> schedules = [];
  static List<Map<String, dynamic>> suratJalan = [];
  static List<Map<String, dynamic>> parent = [];
  static List<Map<String, dynamic>> bom = [];
  static List<Map<String, dynamic>> barcodesBySch = [];
  static List<Map<String, dynamic>> barcodesById = [];
  static List<Map<String, dynamic>> treatmentDetails = [];
  static var totQtySch = "";
  static bool? serverStatus;

  // data from user
  static var pickedDate = "";
  static var shift = "";
  static var group = "";
  static var macAdress = "";
  static var mcnSelected = "";
  static var idPrint = "";
  static var qtyInput = "";

  // data operator
  static var oprCode = "";
  static var oprName = "";

// data treatment
  // static var bcEntried = "";
  // static var bcAlias = "";
  // static var itemcode = "";
  // static var qty = "";
  // static var uom = "";
  // static var mcn = "";
  // static var opr = "";
  // static var expDate = "";
  // static var tglSGProd = "";
  // static var tglProd = "";
  // static var noRoll = "";
  // static var idRoll = "";

  //
}

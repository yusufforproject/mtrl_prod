class Variable {
  static String baseUrl = "http://10.129.78.183/planta/mtrl_prod";
  static String mixIP =
      "http://10.129.78.183/GTBIASAPI/apitxnmltmixv2.php?bc_entried=";
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
    switch (sect+subSec) {
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

  // data by system
  static var dateSys = "";
  static var shfSys = "";
  static var groupSys = "";
  static List<Map<String, dynamic>> mcnList = [];
  static List<Map<String, dynamic>> items = [];
  static List<Map<String, dynamic>> barcodes = [];
  static List<Map<String, dynamic>> schedules = [];
  static List<Map<String, dynamic>> suratJalan = [];
  static List<Map<String, dynamic>> parent= [];
  static List<Map<String, dynamic>> bom = [];
  static List<Map<String, dynamic>> barcodesBySch = [];
  static List<Map<String, dynamic>> barcodesById = [];
  static List<Map<String, dynamic>> treatmentDetails = [];
  static var totQtySch = "";

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

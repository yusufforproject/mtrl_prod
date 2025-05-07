import '../core/variable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<bool> deleteBarcode(bcEntried, roll) async {
    try {
      final response = await http.post(
        Uri.parse('${Variable.baseUrl}/apis/delete_barcode.php'),
        body: {
          'bc_entried': bcEntried,
          'sec': Variable.sect,
          'mcn': Variable.mcnSelected,
          'idroll': Variable.idRoll,
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Server error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
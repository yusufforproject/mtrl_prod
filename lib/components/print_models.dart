import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../core/variable.dart';

class PrintModels {
  // Print All barcode
  Future<void> printAllBarcode() async {
    if (await PrintBluetoothThermal.connectionStatus) {
      final generator =
          Generator(PaperSize.mm58, await CapabilityProfile.load());
      for (var i = 0; i < Variable.barcodesForFetching.length; i++) {
        final bytes =
            _generateBarcodeBytes(generator, Variable.barcodesForFetching[i]);
        final result = await PrintBluetoothThermal.writeBytes(bytes);
        debugPrint("Print $result");
      }
    }
  }

  // Print Checked
  Future<void> printChecked() async {
    if (await PrintBluetoothThermal.connectionStatus) {
      final generator =
          Generator(PaperSize.mm58, await CapabilityProfile.load());
      for (var i = 0; i < Variable.barcodesForFetching.length; i++) {
        if (Variable.barcodesForFetching[i]['isChecked'] == true) {
          final bytes =
              _generateBarcodeBytes(generator, Variable.barcodesForFetching[i]);
          final result = await PrintBluetoothThermal.writeBytes(bytes);
          debugPrint("Print $result");
        }
      }
    }
  }

  Future<void> printLastBarcode() async {
    if (await PrintBluetoothThermal.connectionStatus) {
      final generator =
          Generator(PaperSize.mm58, await CapabilityProfile.load());
      final bytes =
          _generateBarcodeBytes(generator, Variable.barcodesForFetching.last);
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      debugPrint("Print $result");
    }
  }

  Future<void> printEmrBarcode() async {
    if (await PrintBluetoothThermal.connectionStatus) {
      final generator =
          Generator(PaperSize.mm58, await CapabilityProfile.load());
      final bytes =
          _generateBarcodeBytes(generator, Variable.barcodeEmr.first);
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      debugPrint("Print $result");
    }
  }

  List<int> _generateBarcodeBytes(
      Generator generator, Map<String, dynamic> barcode) {
    return [
      ...generator.text(
        (barcode['bc_entried'] ?? '').split('_').first,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
      if (Variable.sect != 'ABC' && Variable.serverStatus == true)
        ...generator.text(
          barcode['descr'] ?? '',
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
      ...generator.text(
        '',
      ),
      ...generator.qrcode(barcode['bc_entried'].substring(0, 1) == 'R' ? barcode['bc_alias'] : barcode['bc_entried'],
          size: QRSize.Size6, cor: QRCorrection.H, align: PosAlign.center),
      ...generator.text(' '),
      ...generator.text(
        (() {
          final idTag = barcode['idtag'] ?? '';
          final index = Variable.barcodesForFetching.indexOf(barcode) + 1;
          switch (Variable.sect) {
            case 'ACL':
              return 'ROLL: ${barcode['idprint'] ?? ''}-${barcode['idroll'] ?? ''}';
            case 'ABC':
              return '$idTag  #$index';
            case 'ASQ':
              return '$idTag  #$index';
            default:
              return '$idTag  #$index';
          }
        })(),
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
        ),
      ),
      ...generator.text(barcode['bc_entried'].substring(0, 1) == 'R' ? barcode['bc_alias'].split(' ').last : barcode['bc_entried'].split('_').last,
          styles: const PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
          linesAfter: 1),
      ...generator.text(
        '${barcode['merge_time'] ?? ''} | ${barcode['mcn'] ?? ''}',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      ...generator.text(
        'EXP : ${barcode['expireddt'] ?? ''}',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      ...generator.text(
        'PIC : ${(barcode['opr'] ?? '')}_${(barcode['oprname'] ?? '').length > 18 ? (barcode['oprname'] ?? '').padRight(18).substring(0, 18) : (barcode['oprname'] ?? '')}',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      ...generator.text(
        ((){
          switch (Variable.sect) {
            case 'ACL':
              return 'QTY : ${barcode['qty'] ?? ''} MTR';
            default:
              return 'QTY : ${barcode['qty'] ?? ''} ${Variable.uomBySect}';
          }
        })(),
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
        linesAfter: 1,
      ),
      if(Variable.sect == 'ACL')
      ...generator.text(
        '[  ]',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      ...generator.text(
        '${barcode['created_at'] ?? ''}',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      ...generator.text(
        '------------------------------',
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
        linesAfter: 1,
      ),
    ];
  }
}

List<int> _generateBarcodeACL(
    Generator generator, Map<String, dynamic> barcode) {
  return [
    ...generator.text(
      (barcode['bc_entried'] ?? '').split('_').first,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ),
    ...generator.text(
      barcode['descr'] ?? '',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
      linesAfter: 1,
    ),
    ...generator.qrcode(barcode['bc_entried'],
        size: QRSize.Size6, cor: QRCorrection.H, align: PosAlign.center),
    ...generator.text(' '),
    ...generator.text(
      'ROLL: ${barcode['idprint'] ?? ''}-${barcode['idroll'] ?? ''}  #${Variable.barcodesForFetching.indexOf(barcode) + 1}',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size2,
      ),
    ),
    ...generator.text(barcode['bc_entried'].split('_').last,
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
        linesAfter: 1),
    ...generator.text(
      '${barcode['merge_time'] ?? ''} | ${barcode['mcn'] ?? ''}',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ),
    ...generator.text(
      'EXP : ${barcode['expireddt'] ?? ''}',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ),
    ...generator.text(
      'PIC : ${(barcode['opr'] ?? '')}_${(barcode['oprname'] ?? '').padRight(18).substring(0, 18)}',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ),
    ...generator.text(
      'QTY : ${barcode['qty'] ?? ''} ${Variable.uomBySect}',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
      linesAfter: 1,
    ),
    ...generator.text(
      '${barcode['created_at'] ?? ''}',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    ),
    ...generator.text(
      '------------------------------',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
      linesAfter: 1,
    ),
  ];
}

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mtrl_prod/api/acl/get_valcount.dart';
import 'package:mtrl_prod/api/cek_server.dart';
import 'package:mtrl_prod/components/custom_notif.dart';
import 'package:mtrl_prod/components/loading.dart';
import 'package:mtrl_prod/components/validation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../components/print_models.dart';
import '../api/get_barcode.dart';
import '../api/add_barcode.dart';
import '../api/get_schedule.dart';
import '../components/custom_appbar.dart';

import '../components/bottom_nav.dart';
import '../components/uppercase.dart';
import '../core/app_colors.dart';
import '../core/sqflite_data.dart';
import '../core/variable.dart';

class ProdPage extends StatefulWidget {
  const ProdPage({super.key});

  @override
  State<ProdPage> createState() => _ProdPageState();
}

class _ProdPageState extends State<ProdPage> {
  // final TextEditingController schController = Variable.schedules.isNotEmpty
  //     ? TextEditingController(text: Variable.schedules[0]['qcode_sch'])
  //     : TextEditingController();
  final TextEditingController schController = Variable.schedules.isEmpty
      ? TextEditingController()
      : TextEditingController(text: Variable.schedules[0]['qcode_sch']);
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController noRollController = Variable.offlineNoRoll != null
      ? TextEditingController(text: Variable.offlineNoRoll.toString())
      : TextEditingController();
  String? searchItem;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    fetchBarcodeBySch();
    // _scanSchedule();
    _getValCount();
  }

  Future<void> _getValCount() async {
    await checkServerStatus();
    if (Variable.serverStatus == true) {
      final result = await getValcount();
      if (Variable.schedules.isNotEmpty) {
        await getSchedule(Variable.schedules[0]['qcode_sch']);
      }
      if (result) {
        setState(() {});
      }
    }
  }

  Future<void> addBarcode() async {
    // await getSchedule();
    Variable.qtyInput = qtyController.text;
    final result = await validationAcl();
    if (result == 'empty') {
      CustomNotification().materialEmpty(context);
    } else if (result == 'unmatch') {
      CustomNotification().unmatchMaterial(context);
    } else if (result == 'over') {
      CustomNotification().overSchedule(context);
    } else {
      await checkServerStatus();
      if (Variable.serverStatus == true) {
        bool isSuccess;
        isSuccess = await addBarcodeAcl(qtyController.text);
        if (isSuccess) {
          setState(() {
            fetchBarcodeBySch();
            _getValCount();
          });
          CustomNotification().notifOk(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to add barcode'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        //   'tglsg': Variable.pickedDate.isEmpty ? '${Variable.dateSys}_${Variable.shfSys}${Variable.groupSys}' : '${Variable.pickedDate}_${Variable.shift}${Variable.group}',
        // 'mcn': Variable.mcnSelected,
        // 'size': Variable.schedules[0]['size'],
        // 'qty': qty,
        // 'opr': Variable.oprCode,
        // 'idprint': Variable.idPrint,
        // 'idroll': Variable.idRoll,
        // 'qcode_sch': Variable.schedules[0]['qcode_sch'],
        // 'mtrl': Variable.materials.map((material) => material['qcode_mtrl']).join(';'),
        // 'section': Variable.sect,
        Variable.offlineNoRoll = int.parse(noRollController.text) + 1;
        var tgl =
            Variable.pickedDate != '' ? Variable.pickedDate : Variable.dateSys;
        var tglYmd =
            tgl.substring(6, 10) + tgl.substring(3, 5) + tgl.substring(0, 2);
        var sifGrup = Variable.pickedDate != ''
            ? '${Variable.shift}${Variable.group}'
            : '${Variable.shfSys}${Variable.groupSys}';
        // var parsedDate = DateTime.tryParse(Variable.pickedDate) ?? DateTime.now();
        var expDate = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(tglYmd).add(const Duration(days: 4)));
        var txnKey =
            '${Variable.mcnSelected}-${DateFormat('yyyyMMddhhmmssa').format(DateTime.now())}${(1000000000 + (9999999999 - 1000000000) * (DateTime.now().microsecond / 1000000)).toInt()}_';

        var padItem = Variable.schedules[0]['size'].padRight(10, ' ');
        Map<String, String> monthArray = {
          '01': '1',
          '02': '2',
          '03': '3',
          '04': '4',
          '05': '5',
          '06': '6',
          '07': '7',
          '08': '8',
          '09': '9',
          '10': 'O',
          '11': 'N',
          '12': 'D'
        };
        var mY = '${monthArray[tgl.substring(3,5)]}${tgl.substring(9, 10)}';
        var padCounter = Variable.offlineNoRoll.toString().padLeft(5, '0');
        DatabaseHelper().insertAcl({
          'txn_key': txnKey,
          'bc_entried':
              "${Variable.schedules[0]['size']}_${DateTime.now().millisecondsSinceEpoch}",
          'bc_alias': '$padItem$mY$padCounter',
          'tglsg': '${tgl}_$sifGrup',
          'expdt': expDate,
          'qty': qtyController.text,
          'mcn': Variable.mcnSelected,
          'opr': Variable.oprCode,
          'sch': Variable.schedules[0]['qcode_sch'],
          'mtrl': Variable.materials
              .map((material) => material['qcode_mtrl'])
              .join(';'),
          'idprint': Variable.offlineNoRoll.toString(),
          'idroll': Variable.idRoll,
          'section': Variable.sect,
          'created_at':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'txn_date': DateFormat('dd/MM/yyyy hh:mm:ss a').format(DateTime.now())
        });
        setState(() {
          Navigator.popAndPushNamed(context, '/prod');
        });
        CustomNotification().notifOk(context);
      }
    }
  }

  Future<void> fetchBarcodeBySch() async {
    // await getSchedule();
    if (Variable.schedules.isNotEmpty) {
      await checkServerStatus();
      if (Variable.serverStatus == true) {
        bool isSuccess = false;
        isSuccess = await getBarcodesBySch();
        if (isSuccess) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text("Barcode fetched successfully"),
          //     duration: Duration(seconds: 3),
          //     backgroundColor: Colors.green,
          //   ),
          // );
          // setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to fetching data'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        Variable.barcodesForFetching = [];
        List<dynamic> dataBarcodes = await DatabaseHelper()
            .fetchDataLocalAcl(Variable.schedules[0]['qcode_sch']);
        for (var item in dataBarcodes) {
          Variable.barcodesForFetching.add({
            'bc_entried': item['bc_entried'],
            'bc_alias': item['bc_alias'],
            'expireddt': item['expdt'],
            'merge_time': item['tglsg'],
            'idprint': item['idprint'],
            'idroll': item['idroll'],
            'mcn': item['mcn'],
            'opr': item['opr'],
            'qty': item['qty'],
            'created_at': item['created_at'],
            'txn_date': item['txn_date'],
            'isChecked': false,
          });
        }
        Variable.schedules[0]['act'] =
            Variable.barcodesForFetching.length.toString();
        // print('ini dataBarcodes: $dataBarcodes');
        print('barcodes for fetching: ${Variable.barcodesForFetching}');
        setState(() {});
        // Variable.barcodesById.add({
        //   'bc_entried': Variable.schedules[0]['qcode_sch'],
        // });
      }
    }
  }

  Future<void> _scanSchedule() async {
    // if (Variable.schedules.isEmpty) {
    loading(context, message: "Getting schedule data...");
    // }
    await checkServerStatus();
    if (Variable.serverStatus == false) {
      if (schController.text.split('_').last.length == 10 &&
          schController.text.contains('_')) {
        Variable.schedules.clear();
        // List<dynamic> dataScheduleLocal = await DatabaseHelper()
        // .getScheduleLocal(Variable.schedules[0]['qcode_sch']);
        Variable.schedules.add(
          {
            'qcode_sch': schController.text,
            'size': schController.text.split('_').first,
            'descr': '-',
            'qtysch': '-',
            'act': Variable.barcodesForFetching.length.toString(),
          },
        );
        Navigator.pop(context);
        print(Variable.schedules);
        setState(() {
          Navigator.pushReplacementNamed(context, '/prod');
        });
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Schedule not found",
                style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Timer(const Duration(seconds: 2), () {
      //   Navigator.of(context).pop();
      // });
    } else {
      final bool response = await getSchedule(schController.text);

      if (!response) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Schedule not found",
                style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (schController.text.isNotEmpty) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Schedule found"),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
        }
        setState(() {
          Navigator.pushReplacementNamed(context, '/prod');
        });
      }
    }
  }

  Future<void> connect(String mac) async {
    // setState(() {
    // bool? dvcConn = false;
    // PrintBluetoothThermal.disconnect;
    // });

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.orange,
              ),
              SizedBox(height: 16),
              Text(
                "Connecting...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          // child: Text("Connecting..."),
        );
      },
    );

    // Attempt to connect
    bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);

    Navigator.pop(context); // Hide loading indicator

    if (result == false) {
      result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    }

    // if (result) {
    //   print("connected to $mac");
    //   setState(() {
    //     // dvcConn = true;
    //   });
    // }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text("Connection Status: $result\nMac Address: $mac",
    //         style: const TextStyle(color: Colors.white)),
    //     duration: const Duration(seconds: 3),
    //     backgroundColor: result ? Colors.green : Colors.red,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          subtitle: "Produksi",
          config: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        controller: schController,
                        inputFormatters: [UpperCaseTextFormatter()],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.orange,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: 'Scan Schedule',
                          labelStyle: TextStyle(color: Colors.grey[600]!),
                          suffixIcon: const Icon(Icons.qr_code_scanner_rounded),
                          suffixIconColor: Variable.schedules.isEmpty
                              ? AppColors.orange
                              : Colors.grey[600],
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.orange,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[600]!,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _scanSchedule();
                          }
                        },
                        enabled: Variable.schedules.isEmpty ? true : false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.red[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          // setState(() {
                          schController.clear();
                          Variable.barcodesForFetching = [];
                          Variable.schedules.clear();
                          // Variable.idRoll;
                          // Variable.idPrint = '';
                          print('schedule: ${Variable.schedules}');
                          setState(() {});
                          // });
                        },
                        child: const Icon(
                          Icons.refresh_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Visibility(
                  visible: Variable.sect == 'ACL',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No. Roll: ',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            Visibility(
                              visible: Variable.serverStatus == true,
                              child: Text(
                                '${Variable.valcount} - ${Variable.idRoll}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Visibility(
                              visible: Variable.serverStatus == false,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      textAlign: TextAlign.center,
                                      controller: noRollController,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' - ${Variable.idRoll}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.lightblue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                            ),
                            
                            onPressed: () {
                              setState(() {
                                qtyController.text = '450';
                              });
                            },
                            child: Text(
                              '450',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // SizedBox(height: 4,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Sch: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 4,
                            bottom: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[600]!,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            Variable.schedules.isEmpty
                                ? '0'
                                : Variable.schedules[0]['qtysch'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Act: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 4,
                            bottom: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[600]!,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            Variable.schedules.isEmpty
                                ? '0'
                                : Variable.schedules[0]['act'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Qty',
                          labelStyle: const TextStyle(
                            color: AppColors.lightblue,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.lightblue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.lightblue,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (Variable.barcodesForFetching.isEmpty) return;
                          if (!await PrintBluetoothThermal.connectionStatus) {
                            await connect(Variable.macAdress.split("#")[1]);
                          }
                          if (Variable.sect == 'ACL') {
                            await PrintModels().printLastBarcode();
                          } else {
                            await PrintModels().printAllBarcode();
                          }
                        },
                        icon: const Icon(
                          Icons.print,
                          size: 22,
                          color: Colors.white,
                        ),
                        label: Variable.sect == 'ACL'
                            ? const Text(
                                'Print',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Print All',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (!await PrintBluetoothThermal.connectionStatus) {
                            await connect(Variable.macAdress.split("#")[1]);
                            // await PrintModels().printChecked();
                            // } else {
                          }
                          PrintModels().printChecked();
                        },
                        icon: const Icon(
                          Icons.check_box,
                          size: 22,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Checked',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 5,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // int convert = 1;
                          // if (Variable.schedules.isNotEmpty) {
                          //   switch (Variable.schedules[0]['size']
                          //       .split('-')
                          //       .first) {
                          //     case 'APB':
                          //       convert = 29;
                          //       break;
                          //     case 'ABB':
                          //       convert = 36;
                          //       break;
                          //     case 'ACB':
                          //       convert = 30;
                          //       break;
                          //     case 'AFB':
                          //       convert = 28;
                          //       break;
                          //     default:
                          //       convert = 1;
                          //   }
                          // }
                          // if (Variable.schedules.isEmpty ||
                          //     qtyController.text.isEmpty) {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: const Text(
                          //           "Sch or Quantity cannot be empty",
                          //           style: TextStyle(color: Colors.white)),
                          //       duration: const Duration(seconds: 3),
                          //       backgroundColor: Colors.red[600],
                          //     ),
                          //   );
                          // } else if (Variable.treatmentDetails.isEmpty) {
                          //   showDialog(
                          //       context: context,
                          //       builder: (context) {
                          //         return AlertDialog(
                          //             title: Row(
                          //               children: [
                          //                 Icon(Icons.warning,
                          //                     color: Colors.red[600]),
                          //                 const SizedBox(width: 10),
                          //                 Text('Treatment not found',
                          //                     style: TextStyle(
                          //                         color: Colors.red[600],
                          //                         fontWeight: FontWeight.bold,
                          //                         fontSize: 16)),
                          //               ],
                          //             ),
                          //             content: const Text(
                          //                 'Silahkan scan treatment terlebih dahulu'),
                          //             actions: [
                          //               TextButton(
                          //                   child: const Text('OK'),
                          //                   onPressed: () {
                          //                     Navigator.of(context).pop();
                          //                     Navigator.pushNamed(
                          //                         context, '/mtrl');
                          //                   })
                          //             ]);
                          //       });
                          // } else {
                          //   if (Variable.serverStatus == true) {
                          //     if (double.parse(
                          //             Variable.treatmentDetails[0]['akt']) <
                          //         (double.parse(Variable.bom[0]['qty']) *
                          //                 int.parse(qtyController.text) *
                          //                 convert)
                          //             .toInt()) {
                          //       showDialog(
                          //           context: context,
                          //           builder: (context) {
                          //             return AlertDialog(
                          //                 title: Row(
                          //                   children: [
                          //                     Icon(Icons.warning,
                          //                         color: Colors.red[600]),
                          //                     const SizedBox(width: 10),
                          //                     Text(
                          //                       'Treatment habis',
                          //                       style: TextStyle(
                          //                         color: Colors.red[600],
                          //                         fontWeight: FontWeight.bold,
                          //                         fontSize: 16,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 content: const Text(
                          //                     'Material tidak cukup\nSilahkan scan treatment baru'),
                          //                 actions: [
                          //                   TextButton(
                          //                       child: const Text('OK'),
                          //                       onPressed: () {
                          //                         Navigator.of(context).pop();
                          //                         Navigator.pushNamed(
                          //                             context, '/mtrl');
                          //                       })
                          //                 ]);
                          //           });
                          //     } else if (Variable.bom.any((item) =>
                          //         item['child'] !=
                          //         Variable.treatmentDetails[0]['bc_entried']
                          //             .split('_')
                          //             .first)) {
                          //       Navigator.of(context)
                          //           .pushReplacementNamed('/mtrl');
                          //       showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return AlertDialog(
                          //             title: Row(
                          //               children: [
                          //                 Icon(Icons.warning,
                          //                     color: Colors.red[600]),
                          //                 const SizedBox(width: 8),
                          //                 Text(
                          //                   'Material tidak sesuai',
                          //                   style: TextStyle(
                          //                       color: Colors.red[600],
                          //                       fontSize: 16,
                          //                       fontWeight: FontWeight.bold),
                          //                 ),
                          //               ],
                          //             ),
                          //             content: SingleChildScrollView(
                          //               child: ListBody(
                          //                 children: [
                          //                   Text(
                          //                       '${'BOM (' + Variable.schedules[0]['size']}):',
                          //                       style: const TextStyle(
                          //                           color: Colors.black,
                          //                           fontWeight:
                          //                               FontWeight.bold)),
                          //                   ...Variable.bom.map((item) {
                          //                     return Text(
                          //                       '- ' + item['child'],
                          //                       style: const TextStyle(
                          //                           color: Colors.black,
                          //                           fontWeight:
                          //                               FontWeight.bold),
                          //                     );
                          //                   }).toList(),
                          //                 ],
                          //               ),
                          //             ),
                          //             actions: <Widget>[
                          //               TextButton(
                          //                 child: const Text(
                          //                   'OK',
                          //                   style: TextStyle(
                          //                       color: AppColors.primary),
                          //                 ),
                          //                 onPressed: () {
                          //                   Navigator.of(context).pop();
                          //                 },
                          //               ),
                          //             ],
                          //           );
                          //         },
                          //       );
                          //     } else {
                          //       if (Variable.parent.isNotEmpty) {
                          //         showDialog(
                          //             context: context,
                          //             builder: (context) {
                          //               return AlertDialog(
                          //                 title: Row(
                          //                   children: [
                          //                     Icon(Icons.question_mark_rounded,
                          //                         color: AppColors.primary),
                          //                     const SizedBox(width: 8),
                          //                     Text(
                          //                       '${Variable.schedules[0]['size']}',
                          //                       style: TextStyle(
                          //                         color: AppColors.primary,
                          //                         fontSize: 16,
                          //                         fontWeight: FontWeight.bold,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 content: Text(
                          //                   'akan dilapis sebanyak ${qtyController.text} roll?',
                          //                   style: const TextStyle(
                          //                     color: Colors.black,
                          //                     fontWeight: FontWeight.bold,
                          //                   ),
                          //                 ),
                          //                 actions: <Widget>[
                          //                   Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment
                          //                               .spaceBetween,
                          //                       children: <Widget>[
                          //                         TextButton(
                          //                           child: Text(
                          //                             'TIDAK',
                          //                             style: TextStyle(
                          //                                 color:
                          //                                     Colors.red[600]),
                          //                           ),
                          //                           onPressed: () {
                          //                             addBarcode();
                          //                             Navigator.of(context)
                          //                                 .pop();
                          //                           },
                          //                         ),
                          //                         TextButton(
                          //                           child: Text(
                          //                             'YA',
                          //                             style: TextStyle(
                          //                                 color: Colors
                          //                                     .green[600]),
                          //                           ),
                          //                           onPressed: () {
                          //                             addBarcode();
                          //                             Navigator.of(context)
                          //                                 .pop();
                          //                             Navigator.of(context)
                          //                                 .pushReplacementNamed(
                          //                                     '/srtjln');
                          //                           },
                          //                         ),
                          //                       ])
                          //                 ],
                          //           );
                          //         });
                          //   }

                          // } else {
                          //   addBarcode();
                          // }
                          // }
                          if (schController.text.isEmpty ||
                              qtyController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Sch dan Qty tidak boleh kosong',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Colors.red[600],
                              ),
                            );
                          } else {
                            if (Variable.serverStatus == false) {
                              if (noRollController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'No Roll tidak boleh kosong',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.red[600],
                                  ),
                                );
                              } else {
                                addBarcode();
                              }
                            } else {
                              addBarcode();
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.add_circle_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  future:
                      Variable.schedules.isEmpty ? fetchBarcodeBySch() : null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching data'));
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.31,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[600]!,
                            width: 1.5,
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Variable.barcodesForFetching.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No data',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: IntrinsicColumnWidth(),
                                    1: FlexColumnWidth(),
                                    2: IntrinsicColumnWidth(),
                                  },
                                  border: TableBorder.all(
                                    color: Colors.grey[600]!,
                                  ),
                                  children: [
                                    ...Variable.barcodesForFetching
                                        .map((barcode) {
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              Variable.sect == 'ACL'
                                                  ? "${barcode['idprint']} - ${barcode['idroll']}"
                                                  : (
                                                      Variable.barcodesForFetching
                                                              .indexOf(
                                                                  barcode) +
                                                          1,
                                                    ).toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              Variable.sect == 'ACL'
                                                  ? barcode['bc_entried']
                                                      .split('_')
                                                      .last
                                                  : barcode['bc_entried'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Checkbox(
                                            value:
                                                barcode['isChecked'] ?? false,
                                            activeColor: AppColors.orange,
                                            onChanged: (bool? value) {
                                              setState(
                                                () {
                                                  barcode['isChecked'] = value!;
                                                  // DatabaseHelper().updateDataLocalAcl(
                                                  //   {
                                                  //     'isChecked': 'true',
                                                  //   },
                                                  //   barcode['bc_entried'],
                                                  // );
                                                },
                                              );
                                              print(
                                                  Variable.barcodesForFetching);
                                            },
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavbar(selectedIndex: 1),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mtrl_prod/api/delete_barcode.dart';

import '../api/cek_server.dart';
import '../api/get_barcode.dart';
import '../components/bottom_nav.dart';
import '../components/custom_appbar.dart';
import '../components/custom_notif.dart';
import '../components/loading.dart';
import '../core/app_colors.dart';
import '../core/sqflite_data.dart';
import '../core/variable.dart';

class DetailPage extends StatelessWidget {
  //declare variable to catch ket from navigator
  final qcode_sch;
  final server;

  const DetailPage({
    super.key,
    this.qcode_sch,
    this.server,
  });

  Future<List<Map<String, dynamic>>> _getBarcodesBySch(qcode) async {
    // await checkServerStatus();
    // if (Variable.serverStatus == true) {
    if (server == 'Server') {
      await getDetailsBarcode(qcode);
    } else {
      final result = await DatabaseHelper().fetchDataLocalBySch(qcode);
      Variable.detailsBarcode = [];
      for (var item in result) {
        Variable.detailsBarcode.add({
          'bc_entried': item['bc_entried'],
          'bld_date': item['txn_date'],
        });
      }
    }
    print('Variable.detailsBarcode: ${Variable.detailsBarcode}');
    return Variable.detailsBarcode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'Details - $server',
        config: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                qcode_sch.split('_')[0],
                style: const TextStyle(
                  // color: Colors.green[600],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                future: _getBarcodesBySch(qcode_sch),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.orange,
                    ));
                    // return loading(context, message: 'Getting data...');
                  } else if (snapshot.hasError) {
                    // Navigator.pop(context);
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || Variable.detailsBarcode.isEmpty) {
                    // Navigator.pop(context);
                    return Column(
                      children: [
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: TableBorder.all(color: Colors.black),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(),
                            2: IntrinsicColumnWidth(),
                            3: IntrinsicColumnWidth(),
                          },
                          children: [
                            TableRow(
                              decoration:
                                  const BoxDecoration(color: AppColors.orange),
                              children: [
                                // TableCell(
                                //   child: Container(
                                //     padding: const EdgeInsets.all(8.0),
                                //     // color: AppColors.orange,
                                //     child: const Text(
                                //       'No',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.white,
                                //       ),
                                //       textAlign: TextAlign.center,
                                //     ),
                                //   ),
                                // ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    // color: AppColors.primary,
                                    child: const Text(
                                      'Roll',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    // color: AppColors.primary,
                                    child: const Text(
                                      'Barcode',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    // color: AppColors.primary,
                                    child: const Text(
                                      'Qty',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    // color: AppColors.primary,
                                    child: const Icon(
                                      Icons.settings_outlined,
                                      color: Colors.white,
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Center(
                            child: Text('No Data'),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Navigator.pop(context);
                    final data = snapshot.data!;
                    return Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(),
                        2: IntrinsicColumnWidth(),
                        3: IntrinsicColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration:
                              const BoxDecoration(color: AppColors.orange),
                          children: [
                            // TableCell(
                            //   child: Container(
                            //     padding: const EdgeInsets.all(8.0),
                            //     // color: AppColors.orange,
                            //     child: const Text(
                            //       'No',
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Colors.white,
                            //       ),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //   ),
                            // ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                // color: AppColors.primary,
                                child: const Text(
                                  'Roll',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                // color: AppColors.primary,
                                child: const Text(
                                  'Barcode',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                // color: AppColors.primary,
                                child: const Text(
                                  'Qty',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                // color: AppColors.primary,
                                child: const Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                        ...data.map((item) {
                          return TableRow(
                            children: [
                              // for (var value in [
                              //   '${data.indexOf(item) + 1}',
                              //   item['bc_entried'].toString(),
                              //   item['bld_date'].toString()
                              // ])
                              // TableCell(
                              //   child: Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       '${data.indexOf(item) + 1}',
                              //       textAlign: TextAlign.center,
                              //     ),
                              //   ),
                              // ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${item['idprint'].toString()} - ${item['idroll'].toString()}",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['bc_entried']
                                        .toString()
                                        .split('_')
                                        .last,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['qty'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: GestureDetector(
                                  onTap: () {
                                    CustomNotification().notifConfirm(context,
                                        'Apakah anda ingin menghapus data ini?',
                                        () {
                                      deleteBarcode(item['bc_entried'],
                                              item['idprint'])
                                          .then((value) {
                                        if (value == true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Data berhasil dihapus',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor:
                                                  Colors.green[600],
                                            ),
                                          );
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                qcode_sch: qcode_sch,
                                                server: server,
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Gagal menghapus data',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor: Colors.red[600],
                                            ),
                                          );
                                        }
                                      });
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red[600],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        // ),
                        // ],
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavbar(
        selectedIndex: server == 'Server' ? 3 : 4,
      ),
    );
  }
}

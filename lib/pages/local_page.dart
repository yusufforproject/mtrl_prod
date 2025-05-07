import 'package:flutter/material.dart';

import '../api/cek_server.dart';
import '../api/upload_local_data.dart';
import '../components/bottom_nav.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_notif.dart';
import '../components/loading.dart';
import '../core/app_colors.dart';
import '../core/sqflite_data.dart';
import '../core/variable.dart';

class LocalPage extends StatefulWidget {
  const LocalPage({super.key});

  @override
  State<LocalPage> createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  @override
  void initState() {
    super.initState();
    // checkServerStatus();
    _fetchData();
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    final result = await DatabaseHelper().fetchDataLocalAclForRekap();
    final upload = await DatabaseHelper().fetchAll();
    Variable.barcodesLocal = result;
    Variable.allBarcodesLocal = upload;
    print('ini length: ${Variable.barcodesLocal.length}');
    print('ini length: ${Variable.allBarcodesLocal.length}');
    print('ini ALL: ${Variable.allBarcodesLocal}');
    return Variable.barcodesLocal;
  }

  Future<void> _uploadLocalData() async {
    final result = await checkServerStatus();
    if (result) {
      loading(context, message: 'Uploading data...');
      final result = await uploadLocalData();
      if (result) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Data berhasil di-upload ke Server',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green[600],
          ),
        );
        setState(() {});
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Data gagal di-upload ke Server',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } else {
      CustomNotification().networkError(context);
    }
  }

  // Future<void> networkCheck() async {
  //   await checkServerStatus();
  //   if (Variable.serverStatus == true) {
  //     CustomNotification().networkOk(context);
  //   } else {
  //     CustomNotification().networkError(context);
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(subtitle: 'Data Lokal', config: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Data Lokal\n(Belum di-upload ke Server)',
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     CustomButton(
              //         label: 'Upload to Server',
              //         icon: Icons.cloud_upload_outlined,
              //         txtColor: Colors.white,
              //         bgColor: Colors.green[600]!,
              //         onPressed: () {
              //           _uploadLocalData();
              //         }),
              //     // SizedBox(width: 8,),
              //     CustomButton(
              //         label: 'Check',
              //         icon: Icons.wifi_find_outlined,
              //         txtColor: Colors.white,
              //         bgColor: AppColors.primary,
              //         onPressed: () {
              //           networkCheck();
              //         }),
              //   ],
              // ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                future: _fetchData(),
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
                  } else if (!snapshot.hasData ||
                      Variable.barcodesLocal.isEmpty) {
                    // Navigator.pop(context);
                    return Column(
                      children: [
                        Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: TableBorder.all(color: Colors.black),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: IntrinsicColumnWidth(),
                            2: FlexColumnWidth(),
                            3: IntrinsicColumnWidth(),
                            4: IntrinsicColumnWidth(),
                          },
                          children: [
                            TableRow(
                              decoration:
                                  const BoxDecoration(color: AppColors.orange),
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    // color: AppColors.orange,
                                    child: const Text(
                                      'No',
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
                                      'Tgl',
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
                                      'Size',
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
                    final data = Variable.barcodesLocal;
                    print('ini barcodes local: ${Variable.barcodesLocal}');
                    return Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: IntrinsicColumnWidth(),
                        2: FlexColumnWidth(),
                        3: IntrinsicColumnWidth(),
                        4: IntrinsicColumnWidth(),
                      },
                      children: [
                        TableRow(
                          decoration:
                              const BoxDecoration(color: AppColors.orange),
                          children: [
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                // color: AppColors.orange,
                                child: const Text(
                                  'No',
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
                                  'Tgl',
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
                                  'Size',
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
                          ],
                        ),
                        ...data.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> item = entry.value;
                          return TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${index + 1}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['tglsg'].toString(),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['sch'].split('_').first.toString(),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['qty'].toString(),
                                      textAlign: TextAlign.center),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // DatabaseHelper().deleteAllAcl().then((value) => print('deleted'));
              _uploadLocalData();
            },
            child: const Icon(Icons.cloud_upload_outlined, color: Colors.white,),
            backgroundColor: Colors.green[600],
            shape: const CircleBorder(),
            heroTag: null,
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            child: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
            backgroundColor: Colors.red[600],
            shape: const CircleBorder(),
            onPressed: () {
              // _deleteLocalData();
              // DatabaseHelper().deleteCxs();
              // print('local data deleted');
              // DatabaseHelper().fetchDataLocalForUpload();
              CustomNotification().notifConfirm(context, 'Apakah anda yakin ingin menghapus semua data lokal?', () {
                DatabaseHelper().deleteAllAcl().then((value) => setState(() {
                }));
              });
            },
            heroTag: null,
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(selectedIndex: 4),
    );
  }
}

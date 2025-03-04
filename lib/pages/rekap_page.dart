// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../api/get_barcode.dart';
import '../components/bottom_nav.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../core/app_colors.dart';
import '../core/variable.dart';

class RekapPage extends StatelessWidget {
  const RekapPage({super.key});

  Future<List<Map<String, dynamic>>> fetchDataFromDatabase() async {
    await getBarcodes();
    return Variable.barcodes;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          subtitle: 'Rekap',
          config: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 150,
                child: CustomButton(
                  label: 'SURAT JALAN',
                  icon: Icons.list_alt_rounded,
                  bgColor: AppColors.primary,
                  txtColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/srtjln');
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                future: fetchDataFromDatabase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.orange,
                    ));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data as List<Map<String, dynamic>>;
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
                                  'Itemcode',
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
                                child: Text(
                                  'Sch\n(${Variable.uomBySect})',
                                  style: const TextStyle(
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
                                child: Text(
                                  'Akt\n(${Variable.uomBySect})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                        ...data.map((item) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${data.indexOf(item) + 1}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['size'].toString(),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(item['qtysch'].toString(),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['akt'].toString(),
                                    textAlign: TextAlign.center,
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
        bottomNavigationBar: const BottomNavbar(selectedIndex: 3),
      ),
    );
  }
}

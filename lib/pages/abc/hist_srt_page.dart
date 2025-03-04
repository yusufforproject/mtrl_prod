import 'package:flutter/material.dart';

import '../../api/get_schedule.dart';
import '../../components/bottom_nav.dart';
import '../../components/custom_appbar.dart';
import '../../core/app_colors.dart';
import '../../core/variable.dart';

class HistSrtPage extends StatefulWidget {
  const HistSrtPage({super.key});

  @override
  State<HistSrtPage> createState() => _HistSrtPageState();
}

class _HistSrtPageState extends State<HistSrtPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'History Surat Jalan',
        config: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: Variable.suratJalan.isEmpty ? getSuratJalan() : null,
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
                                padding: const EdgeInsets.all(8.0),
                                // color: AppColors.primary,
                                child: const Icon(
                                  Icons.check_box,
                                  color: Colors.white,
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
                                    item['item_asq'].toString(),
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
                                  child: Checkbox(
                                    value: item['isChecked'] ?? false,
                                    onChanged:
                                        (bool? value) {
                                          setState(() {
                                            item['isChecked'] = value!;
                                          });
                                        },
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
      bottomNavigationBar: const BottomNavbar(
        selectedIndex: 3,
      ),
    );
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtrl_prod/core/variable.dart';

import '../../api/get_material.dart';
import '../../components/bottom_nav.dart';
import '../../components/custom_appbar.dart';
import '../../components/uppercase.dart';
import '../../core/app_colors.dart';
import '../prod_page.dart';

class MatAbcPage extends StatefulWidget {
  const MatAbcPage({super.key});

  @override
  State<MatAbcPage> createState() => _MatAbcPageState();
}

class _MatAbcPageState extends State<MatAbcPage> {
  final TextEditingController _controller = Variable.treatmentDetails.isEmpty
      ? TextEditingController()
      : TextEditingController(text: Variable.treatmentDetails[0]['bc_entried']);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _scanMaterial() async {
    if (Variable.serverStatus == true) {
      if (Variable.bom
          .any((item) => item['child'] == _controller.text.split('_').first)) {
        final response = await getMaterial(_controller.text);
        if (!response || Variable.treatmentDetails.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Treatment not found',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              'Treatment found',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ));
          setState(() {});
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Material tidak sesuai',
                    style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('${'BOM (' + Variable.schedules[0]['size']}):',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    ...Variable.bom.map((item) {
                      return Text(
                        '- ' + item['child'],
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        Variable.treatmentDetails.clear();
        Variable.treatmentDetails.add({
          'bc_entried': _controller.text,
          'akt': '0',
          'uom': '',
          'mesin': '-',
          'idkary': '-',
          'idprint': '-',
          'idroll': '-',
          'tglprod': '-',
          'jdge': 'OK',
        });
        print(Variable.treatmentDetails);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // } else {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'Material',
        config: false,
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      controller: _controller,
                      inputFormatters: [UpperCaseTextFormatter()],
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide:
                              BorderSide(color: AppColors.orange, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide:
                              BorderSide(color: AppColors.orange, width: 2.0),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                          borderSide:
                              BorderSide(color: Colors.grey[600]!, width: 2.0),
                        ),
                        labelText: 'Scan Material',
                        labelStyle: TextStyle(
                          color: Colors.grey[600]!,
                        ),
                        suffixIcon: const Icon(Icons.qr_code_scanner_rounded),
                        suffixIconColor: Variable.treatmentDetails.isEmpty
                            ? AppColors.orange
                            : Colors.grey[600],
                      ),
                      onFieldSubmitted: (value) async {
                        if (value.isEmpty) {
                          return;
                        } else {
                          await _scanMaterial();
                        }
                      },
                      enabled: Variable.treatmentDetails.isEmpty ? true : false,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          Variable.treatmentDetails.clear();
                          print(Variable.treatmentDetails);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.red[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                      ),
                      child: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                future: getMaterial(_controller.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || Variable.treatmentDetails.isEmpty) {
                    return const Text('No data found');
                  } else {
                    return Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      border: TableBorder.all(color: Colors.black),
                      children: Variable.treatmentDetails.map((detail) {
                        return TableRow(children: [
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Item Code',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  detail['bc_entried'].split('_').first ?? ''),
                            ),
                          ),
                        ]);
                      }).toList()
                        ..addAll(Variable.treatmentDetails.map((detail) {
                          return TableRow(children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'No. Roll',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text((detail['idprint'] ?? '') +
                                    '-' +
                                    (detail['idroll'] ?? '')),
                              ),
                            ),
                          ]);
                        }).toList())
                        ..addAll(Variable.treatmentDetails.map((detail) {
                          return TableRow(children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Tgl. Prod.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(detail['tglprod'].toString()),
                              ),
                            ),
                          ]);
                        }).toList())
                        ..addAll(Variable.treatmentDetails.map((detail) {
                          return TableRow(children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Quantity',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${detail['akt']} MTR',
                                  style: TextStyle(
                                      color: double.parse(detail['akt']) <= 0
                                          ? Colors.white
                                          : Colors.black,
                                      backgroundColor:
                                          double.parse(detail['akt']) <= 0
                                              ? Colors.red[600]
                                              : Colors.transparent),
                                ),
                              ),
                            ),
                          ]);
                        }).toList())
                        ..addAll(Variable.treatmentDetails.map((detail) {
                          return TableRow(children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Mesin',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(detail['mesin'].toString()),
                              ),
                            ),
                          ]);
                        }).toList())
                        ..addAll(Variable.treatmentDetails.map((detail) {
                          return TableRow(children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'PIC',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(detail['idkary'].toString()),
                              ),
                            ),
                          ]);
                        }).toList())
                        ..addAll(Variable.treatmentDetails.map((detail) {
                          return TableRow(children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(detail['jdge'].toString()),
                              ),
                            ),
                          ]);
                        }).toList()),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(selectedIndex: 2),
    );
  }
}

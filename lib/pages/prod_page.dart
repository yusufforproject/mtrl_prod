import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtrl_prod/apis/get_schedule.dart';
import '../components/print_models.dart';
import '../apis/get_barcode.dart';
import '../apis/add_barcode.dart';
import '../components/custom_appbar.dart';

import '../components/bottom_nav.dart';
import '../components/uppercase.dart';
import '../core/app_colors.dart';
import '../core/variable.dart';

class ProdPage extends StatefulWidget {
  const ProdPage({super.key});

  @override
  State<ProdPage> createState() => _ProdPageState();
}

class _ProdPageState extends State<ProdPage> {
  final TextEditingController schController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  String? searchItem;

  @override
  void initState() {
    super.initState();
    // fetchBarcodeBySch();
    _scanSchedule();
  }

  Future<void> addBarcode() async {
    // await getSchedule();
    Variable.qtyInput = qtyController.text;
    bool isSuccess;
    isSuccess = await addNewBarcode(qtyController.text);
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Barcode added successfully"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        fetchBarcodeById();
        // Navigator.pushReplacementNamed(context, '/prod');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add barcode'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> fetchBarcodeById() async {
    // await getSchedule();
    bool isSuccess = false;
    if (Variable.schedules.isNotEmpty) {
      isSuccess = await getBarcodesById();
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
    }
  }

  Future<void> _scanSchedule() async {
    final bool response = await getSchedule(schController.text.isEmpty
        ? Variable.schedules[0]['qcode_sch']
        : schController.text);
    if (!response) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Schedule not found", style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      if (schController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sch found"),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
      setState(() {
        fetchBarcodeById();
      });
    }
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        autofocus: true,
                        controller: Variable.schedules.isNotEmpty
                            ? TextEditingController(
                                text: Variable.schedules[0]['qcode_sch'])
                            : schController,
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
                          setState(() {
                            schController.clear();
                            Variable.barcodesBySch.clear();
                            Variable.barcodesById.clear();
                            Variable.schedules.clear();
                            // Variable.idPrint = '';
                          });
                        },
                        child: const Icon(
                          Icons.refresh_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          PrintModels().printAllBarcode();
                        },
                        icon: const Icon(
                          Icons.print,
                          size: 22,
                          color: Colors.white,
                        ),
                        label: const Text(
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
                        onPressed: () {
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
                          int convert = 1;
                          if (Variable.schedules.isNotEmpty) {
                            switch (Variable.schedules[0]['size']
                                .split('-')
                                .first) {
                              case 'APB':
                                convert = 29;
                                break;
                              case 'ABB':
                                convert = 36;
                                break;
                              case 'ACB':
                                convert = 30;
                                break;
                              case 'AFB':
                                convert = 28;
                                break;
                              default:
                                convert = 1;
                            }
                          }
                          if (Variable.schedules.isEmpty ||
                              qtyController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    "Sch or Quantity cannot be empty",
                                    style: TextStyle(color: Colors.white)),
                                duration: const Duration(seconds: 3),
                                backgroundColor: Colors.red[600],
                              ),
                            );
                          } else if (Variable.treatmentDetails.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(Icons.warning,
                                              color: Colors.red[600]),
                                          const SizedBox(width: 10),
                                          Text('Treatment not found',
                                              style: TextStyle(
                                                  color: Colors.red[600],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                      content: const Text(
                                          'Silahkan scan treatment terlebih dahulu'),
                                      actions: [
                                        TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pushNamed(
                                                  context, '/mtrl');
                                            })
                                      ]);
                                });
                          } else if (double.parse(
                                  Variable.treatmentDetails[0]['akt']) <
                              (double.parse(Variable.bom[0]['qty']) *
                                      int.parse(qtyController.text) *
                                      convert)
                                  .toInt()) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(Icons.warning,
                                              color: Colors.red[600]),
                                          const SizedBox(width: 10),
                                          Text('Treatment habis',
                                              style: TextStyle(
                                                  color: Colors.red[600],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                      content: const Text(
                                          'Material tidak cukup\nSilahkan scan treatment baru'),
                                      actions: [
                                        TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pushNamed(
                                                  context, '/mtrl');
                                            })
                                      ]);
                                });
                          } else if (Variable.bom.any((item) =>
                              item['child'] !=
                              Variable.treatmentDetails[0]['bc_entried']
                                  .split('_')
                                  .first)) {
                            Navigator.of(context).pushReplacementNamed('/mtrl');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.warning,
                                          color: Colors.red[600]),
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
                                        Text(
                                            '${'BOM (' + Variable.schedules[0]['size']}):',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        ...Variable.bom.map((item) {
                                          return Text(
                                            '- ' + item['child'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        'OK',
                                        style:
                                            TextStyle(color: AppColors.primary),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            if (Variable.parent.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(Icons.question_mark_rounded,
                                              color: AppColors.primary),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${Variable.schedules[0]['size']}',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        'akan dilapis sebanyak ${qtyController.text} roll?',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  'TIDAK',
                                                  style: TextStyle(
                                                      color: Colors.red[600]),
                                                ),
                                                onPressed: () {
                                                  addBarcode();
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'YA',
                                                  style: TextStyle(
                                                      color: Colors.green[600]),
                                                ),
                                                onPressed: () {
                                                  addBarcode();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          '/srtjln');
                                                },
                                              ),
                                            ])
                                      ],
                                    );
                                  });
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
                  future: Variable.barcodesById.isEmpty
                      ? fetchBarcodeById()
                      : null,
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
                          child: Variable.barcodesById.isEmpty
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
                                    ...Variable.barcodesById.map((barcode) {
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              (Variable.barcodesById
                                                          .indexOf(barcode) +
                                                      1)
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              barcode['bc_entried'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.zero,
                                            child: Checkbox(
                                              value:
                                                  barcode['isChecked'] ?? false,
                                              activeColor: AppColors.orange,
                                              onChanged: (bool? value) {
                                                setState(
                                                  () {
                                                    barcode['isChecked'] =
                                                        value!;
                                                  },
                                                );
                                              },
                                            ),
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

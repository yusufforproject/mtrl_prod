import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtrl_prod/components/custom_notif.dart';
import 'package:mtrl_prod/core/variable.dart';

import '../../api/get_material.dart';
import '../../components/bottom_nav.dart';
import '../../components/custom_appbar.dart';
import '../../components/uppercase.dart';
import '../../core/app_colors.dart';
import '../prod_page.dart';

class MatAclPage extends StatefulWidget {
  const MatAclPage({super.key});

  @override
  State<MatAclPage> createState() => _MatAclPageState();
}

class _MatAclPageState extends State<MatAclPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future<void> _scanMaterial() async {
    var materialScanned = _controller.text.replaceAll(' ', '_');
    var type;
    if(materialScanned.substring(0,1) == 'N'){
      type = 'nylon';
    } else{
      type = 'cmpd';
    }
    if (Variable.serverStatus == true) {
      if (Variable.bom
          .any((item) => item['child'] == materialScanned.split('_').first)) {
        Variable.materials.add({
          'qcode_mtrl': materialScanned,
          'item_mtrl': materialScanned.split('_').first,
          'type_mtrl': type
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Material found',
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green[600],
        ));
        setState(() {});
      } else {
        CustomNotification().unmatchMaterial(context);
      }
    } else {
      setState(() {
        Variable.materials.add({
          'qcode_mtrl': materialScanned,
          'item_mtrl': materialScanned.split('_').first,
          'type_mtrl': type
        });
        print(Variable.materials);
      });
    }
    _controller.clear();
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
                          Variable.materials.clear();
                          print(Variable.materials);
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
                Table(border: TableBorder.all(color: Colors.black), children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                  TableCell(
                    child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Nylon',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ),
                  ),
                  ],
                ),
                ...Variable.materials.where((detail) => detail['type_mtrl'] == 'nylon').map((detail) {
                  return TableRow(children: [
                  TableCell(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(detail['qcode_mtrl'] ?? ''),
                    ),
                  ),
                  ]);
                }).toList()
              ]),
              SizedBox(
                height: 16,
              ),
              Table(border: TableBorder.all(color: Colors.black), children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Compound',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  
                ),
                ...Variable.materials.where((detail) => detail['type_mtrl'] == 'cmpd').map((detail) {
                  return TableRow(children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(detail['qcode_mtrl'] ?? ''),
                      ),
                    ),
                  ]);
                }).toList()
              ]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavbar(selectedIndex: 2),
    );
  }
}

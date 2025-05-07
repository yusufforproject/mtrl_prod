import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtrl_prod/api/acl/cek_emr.dart';
import 'package:mtrl_prod/api/cek_server.dart';
import 'package:mtrl_prod/components/bottom_nav.dart';
import 'package:mtrl_prod/components/custom_appbar.dart';
import 'package:mtrl_prod/components/custom_button.dart';
import 'package:mtrl_prod/components/custom_dropdown.dart';
import 'package:mtrl_prod/components/custom_textfield.dart';
import 'package:mtrl_prod/components/loading.dart';
import 'package:mtrl_prod/components/print_models.dart';

import '../../core/app_colors.dart';
import '../../core/variable.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  final TextEditingController ymController = TextEditingController();
  final TextEditingController noRollController = TextEditingController();
  final TextEditingController mcnController = TextEditingController();
  bool barcodeEmrValid = false;

  Future<void> _cekEmr() async {
    loading(context, message: 'Cek Barcode...');
    final result = await cekBarcodeEmr(
        ymController.text, noRollController.text, mcnController.text);
    if (result) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: const Text('Barcode Valid')));
      setState(() {
        barcodeEmrValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'Emergency',
        config: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    label: 'Rekap',
                    icon: Icons.file_copy_outlined,
                    txtColor: Colors.white,
                    bgColor: AppColors.orange,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/rekap');
                    },
                  ),
                  CustomButton(
                    label: 'Ganti No. Roll',
                    icon: Icons.change_circle_outlined,
                    txtColor: Colors.white,
                    bgColor: AppColors.primary,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/gantinoroll');
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: SizedBox(
                  width: 250,
                  child: Column(
                    children: [
                      Visibility(
                        visible: barcodeEmrValid,
                        child: Column(
                          children: [
                            Text(
                              'DATA TREATMENT ${Variable.barcodeEmr[0]['idprint'] ?? ''} - ${Variable.barcodeEmr[0]['idroll'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${Variable.barcodeEmr[0]['bc_entried'] ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Table(
                              border: TableBorder(
                                bottom: BorderSide(
                                  color: Colors.grey[600]!,
                                  width: 1.0,
                                ),
                                horizontalInside: BorderSide(
                                  color: Colors.grey[600]!,
                                  width: 1.0,
                                ),
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Text('Treatment'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          ': ${Variable.barcodeEmr[0]['bc_entried'].split('_')[0] ?? ''}'),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Text('No. Roll'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          ': ${Variable.barcodeEmr[0]['idprint'] ?? ''} - ${Variable.barcodeEmr[0]['idroll'] ?? ''}'),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Text('Tgl. Prod.'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          ': ${Variable.barcodeEmr[0]['merge_time'] ?? ''}'),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Text('Tgl. Exp.'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          ': ${Variable.barcodeEmr[0]['expireddt'] ?? ''}'),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Text('Qty.'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          ': ${Variable.barcodeEmr[0]['qty'] ?? ''}'),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Text('Mesin'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          ': ${Variable.barcodeEmr[0]['mcn'] ?? ''}'),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Text('PIC'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                          ': ${Variable.barcodeEmr[0]['opr'] ?? ''}_${Variable.barcodeEmr[0]['oprname'] ?? ''}'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox( height: 10.0 ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(label: 'PRINT', icon: Icons.print_outlined, txtColor: Colors.white, bgColor: Colors.red[600]!, onPressed: () {
                                  PrintModels().printEmrBarcode();
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !barcodeEmrValid,
                        child: Column(
                          children: [
                            const Text(
                              'MASUKKAN DATA BARCODE',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: CustomTextFormField(
                                    controller: ymController,
                                    color: AppColors.primary,
                                    icon: null,
                                    boldText: true,
                                    label: 'Tahun-Bulan',
                                    enabled: false,
                                    keyboardType: TextInputType.datetime,
                                    onFieldSubmitted: (y) {},
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.calendar_today,
                                      color: AppColors.primary),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      // builder: (context, child) {
                                      //   return Theme(
                                      //     data: Theme.of(context).copyWith(
                                      //       colorScheme:
                                      //           const ColorScheme.light(
                                      //         primary: AppColors.primary,
                                      //         onPrimary: Colors.white,
                                      //         onSurface: AppColors.primary,
                                      //       ),
                                      //     ),
                                      //     child: child!,
                                      //   );
                                      // },
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        ymController.text =
                                            '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}';
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            CustomTextFormField(
                              controller: noRollController,
                              color: AppColors.primary,
                              icon: Icons.numbers_outlined,
                              boldText: true,
                              label: 'No. Roll',
                              enabled: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (y) {},
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Pilih Mesin',
                                labelStyle:
                                    const TextStyle(color: AppColors.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'ACL1', child: Text('ACL1')),
                                DropdownMenuItem(
                                    value: 'ACL2', child: Text('ACL2')),
                              ],
                              onChanged: (value) {
                                // Handle dropdown value change
                                // print('Selected: $value');
                                mcnController.text = value!;
                                print(mcnController.text);
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: SizedBox(
                                width: 150,
                                child: CustomButton(
                                  label: 'CEK BARCODE',
                                  icon: Icons.qr_code_outlined,
                                  txtColor: Colors.white,
                                  bgColor: Colors.red[600]!,
                                  onPressed: () {
                                    if (ymController.text.isEmpty ||
                                        mcnController.text.isEmpty ||
                                        noRollController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                              'Silahkan isi semua field'),
                                          backgroundColor: Colors.red[600],
                                        ),
                                      );
                                    } else {
                                      _cekEmr();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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

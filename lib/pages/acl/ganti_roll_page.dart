import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtrl_prod/api/acl/update_valcount.dart';
import 'package:mtrl_prod/components/custom_textfield.dart';
import 'package:mtrl_prod/components/loading.dart';
import 'package:mtrl_prod/core/app_colors.dart';

import '../../components/bottom_nav.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';

class GantiRollPage extends StatefulWidget {
  const GantiRollPage({super.key});

  @override
  State<GantiRollPage> createState() => _GantiRollPageState();
}

class _GantiRollPageState extends State<GantiRollPage> {
  final TextEditingController rollController = TextEditingController();
  final TextEditingController mcnController = TextEditingController();
  String? response;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rollController.dispose();
    mcnController.dispose();
  }

  Future<void> _updateValcount() async {
    loading(context, message: 'Ganti No Roll...');
    final result =
        await updateValcount(rollController.text, mcnController.text);
    setState(() {
      Navigator.pop(context);
      response = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'Ganti No Roll',
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
                    label: 'Emergency',
                    icon: Icons.alarm,
                    txtColor: Colors.white,
                    bgColor: Colors.red[600]!,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/emergency');
                    },
                  ),
                  CustomButton(
                    label: 'Rekap',
                    icon: Icons.file_copy_outlined,
                    txtColor: Colors.white,
                    bgColor: AppColors.orange,
                    onPressed: () {
                      Navigator.of(context).pushNamed('/rekap');
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
                      const Center(
                        child: Text(
                          'GANTI NO ROLL\nACL',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextFormField(
                          controller: rollController,
                          color: AppColors.primary,
                          icon: Icons.numbers_outlined,
                          boldText: true,
                          label: 'No Roll',
                          enabled: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onFieldSubmitted: (y) {},
                          textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Pilih Mesin',
                          labelStyle: const TextStyle(color: AppColors.primary),
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
                          DropdownMenuItem(value: 'ACL1', child: Text('ACL1')),
                          DropdownMenuItem(value: 'ACL2', child: Text('ACL2')),
                        ],
                        onChanged: (value) {
                          // Handle dropdown value change
                          // print('Selected: $value');
                          mcnController.text = value!;
                          print(mcnController.text);
                        },
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: SizedBox(
                          width: 100,
                          child: CustomButton(
                            label: 'GANTI',
                            icon: Icons.change_circle_outlined,
                            txtColor: Colors.white,
                            bgColor: AppColors.primary,
                            onPressed: () {
                              if (mcnController.text.isEmpty ||
                                  rollController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'No Roll atau Mesin tidak boleh kosong',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red[600],
                                  ),
                                );
                              } else {
                                _updateValcount();
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      if (response != null)
                        Text(
                          '$response',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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

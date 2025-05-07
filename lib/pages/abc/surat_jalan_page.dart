import 'package:flutter/material.dart';
import 'package:mtrl_prod/components/bottom_nav.dart';
import 'package:mtrl_prod/components/custom_button.dart';

import '../../components/custom_appbar.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_textfield.dart';
import '../../core/app_colors.dart';
import '../../core/variable.dart';

class SrtJlnPage extends StatefulWidget {
  const SrtJlnPage({super.key});

  @override
  State<SrtJlnPage> createState() => _SrtJlnPageState();
}

class _SrtJlnPageState extends State<SrtJlnPage> {
  String tglsifgrp = Variable.pickedDate.isEmpty
      ? '${Variable.dateSys}_${Variable.shfSys}${Variable.groupSys}'
      : '${Variable.pickedDate}_${Variable.shift}${Variable.group}';
  final TextEditingController _itemAbc = Variable.schedules.isEmpty
      ? TextEditingController()
      : TextEditingController(text: Variable.schedules[0]['size']);
  final TextEditingController _qtyRoll =
      TextEditingController(text: Variable.qtyInput);
  final TextEditingController _itemAsq = TextEditingController();
  final TextEditingController _qtyMtr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          subtitle: 'Surat Jalan',
          config: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            scrollDirection: Axis.vertical,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('SURAT JALAN',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('$tglsifgrp | ${Variable.mcnSelected}',
                      style: const TextStyle(fontSize: 16))
                ],
              ),
              const SizedBox(height: 8),
              // CustomTextFormField(
              //   controller: _itemAbc,
              //   color: AppColors.lightblue,
              //   icon: Icons.abc,
              //   label: 'Item ABC',
              //   boldText: true,
              //   enabled: false,
              // ),
              const SizedBox(
                height: 8,
              ),
              CustomDropdownButtonFormField(
                borderColor: AppColors.lightblue,
                label: 'Item ASQ',
                textBold: true,
                enabled: true,
                items: Variable.parent,
                onChanged: (String? newValue) {
                  setState(() {
                    _itemAsq.text = newValue!;
                  });
                },
                value: 'parent',
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  // Expanded(
                  //   child: CustomTextFormField(
                  //     controller: _qtyRoll,
                  //     color: AppColors.lightblue,
                  //     icon: Icons.numbers,
                  //     boldText: true,
                  //     label: '',
                  //     enabled: false,
                  //   ),
                  // ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Expanded(
                    child: Text(
                      'ROLL',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.transparent),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  // Expanded(
                  //   child: CustomTextFormField(
                  //     controller: _qtyMtr,
                  //     color: AppColors.lightblue,
                  //     icon: Icons.numbers,
                  //     boldText: true,
                  //     label: '',
                  //     enabled: true,
                  //   ),
                  // ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Expanded(
                    child: Text(
                      'MTR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/hist_srt');
                  },
                  icon: Icons.history,
                  label: 'HISTORY',
                  txtColor: Colors.white,
                  bgColor: AppColors.orange,
                ),
                CustomButton(
                  onPressed: () {},
                  icon: Icons.print,
                  label: 'PRINT',
                  txtColor: Colors.white,
                  bgColor: AppColors.primary,
                ),
              ]),
              // TextButton(
              //     onPressed: () {
              //       Navigator.pushNamed(context, '/prod');
              //     },
              //     child: const Text('PROD')),
            ]),
          ),
        ),
        bottomNavigationBar: const BottomNavbar(selectedIndex: 1),
      ),
    );
  }
}

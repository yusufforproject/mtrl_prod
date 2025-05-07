import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mtrl_prod/components/custom_dropdown.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../api/cek_operator.dart';
import '../api/cek_server.dart';
import '../api/get_dateshift.dart';
import '../api/update_dvcstat.dart';
import '../components/bottom_nav.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_dateshift.dart';
import '../components/custom_notif.dart';
import '../components/custom_textfield.dart';
import '../components/loading.dart';
import '../core/app_colors.dart';
import '../core/variable.dart';

class LoginPageV2 extends StatefulWidget {
  const LoginPageV2({super.key});

  @override
  State<LoginPageV2> createState() => _LoginPageV2State();
}

class _LoginPageV2State extends State<LoginPageV2> {
  final TextEditingController controller = Variable.isLoggedIn!
      ? TextEditingController(text: '${Variable.oprCode}_${Variable.oprName}')
      : TextEditingController();
  bool dvcConn = Variable.macAdress.isEmpty ? false : true;
  List btDvc = [];
  @override
  void initState() {
    super.initState();
    // _checkServerStatus();
    getBluetooth();
  }

  Future<void> _checkServerStatus() async {
    Variable.serverStatus = await checkServerStatus();
    // Variable.serverStatus = false;
    if (Variable.serverStatus == true) {
      CustomNotification().networkOk(context);
    } else {
      CustomNotification().networkError(context);
    }
    setState(() {});
  }

  Future<void> getBluetooth() async {
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    setState(() {
      btDvc = listResult.map((e) => "${e.name}#${e.macAdress}").toList();
    });
  }

  Future<void> connect(String mac) async {
    // setState(() {
    dvcConn = false; // Reset connection state
    PrintBluetoothThermal.disconnect;
    // });

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.lightorange,
              ),
              SizedBox(height: 16),
              Text(
                "Connecting...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          // child: Text("Connecting..."),
        );
      },
    );

    // Attempt to connect
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);

    Navigator.pop(context); // Hide loading indicator

    if (result) {
      print("connected to $mac");
      setState(() {
        dvcConn = true;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Connection Status: $dvcConn\nMac Address: $mac",
            style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 3),
        backgroundColor: dvcConn ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _scanOpr() async {
    loading(context);
    await checkServerStatus();
    if (Variable.serverStatus == true) {
      final result = await cekOpr(controller.text);
      if (result) {
        updateDvcStat('login');
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Hallo, ${Variable.oprName}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green[600],
          ),
        );
        Variable.isLoggedIn = true;
        Navigator.pushNamed(context, '/prod');
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Gagal login, silahkan coba lagi',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    } else {
      if (controller.text.length != 7 || !controller.text.contains('-')) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Penneng tidak valid',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red[600],
          ),
        );
      } else {
        Navigator.pop(context);
        Variable.isLoggedIn = true;
        Variable.oprCode = controller.text;
        Variable.oprName = controller.text;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Hallo, ${Variable.oprName}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green[600],
          ),
        );
        Navigator.pushNamed(context, '/prod');
      }
    }
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red[600]),
              const SizedBox(
                width: 8,
              ),
              Text(
                'Logout',
                style: TextStyle(
                    color: Colors.red[600], fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text('Apakah anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Variable.isLoggedIn = false;
                Variable.pickedDate = '';
                Variable.shift = '';
                Variable.group = '';
                Variable.dateSys = '';
                Variable.shfSys = '';
                Variable.groupSys = '';
                Navigator.pushReplacementNamed(context, '/login');
                if (Variable.serverStatus == false) return;
                updateDvcStat('logout');
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        subtitle: 'Login',
        config: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.all(4),
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //             color: Variable.serverStatus == false
              //                 ? Colors.red[600]!
              //                 : Colors.green[600]!,
              //             width: 1),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: Text(
              //         Variable.serverStatus == false ? 'Offline' : 'Online',
              //         style: TextStyle(
              //             color: Variable.serverStatus == false
              //                 ? Colors.red[600]
              //                 : Colors.green[600],
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Bluetooth Thermal Printer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              '(${dvcConn ? "Connected" : "Disconnected"})',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: dvcConn ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value:
                              dvcConn ? Variable.macAdress : null,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                                top: 15,
                                bottom: 15,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              )),
                          hint: const Text('Select Bluetooth Device'),
                          items: btDvc.map((device) {
                            return DropdownMenuItem<String>(
                              value: device,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  device,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (device) {
                            if (device != null && device.isNotEmpty) {
                              setState(() {
                                Variable.macAdress = device;
                                List list = device.split("#");
                                String mac = list[1];
                                connect(mac);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const CustomDateshift(),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.settings,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: Variable.isLoggedIn! ? Variable.mcnSelected : null,
                      decoration: InputDecoration(
                        labelText: 'Mesin',
                        labelStyle: TextStyle(
                            color: Variable.isLoggedIn!
                                ? Colors.grey[600]
                                : AppColors.primary),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          top: 15,
                          bottom: 15,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[600]!,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabled: Variable.isLoggedIn! ? false : true,
                      ),
                      items: Variable.mcnList.isEmpty
                          ? Variable.offlineMcnList
                              .map<DropdownMenuItem<String>>(
                                  (Map<String, dynamic> value) {
                              return DropdownMenuItem<String>(
                                  value: value['mcn'],
                                  child: Text(
                                    value['mcn'].toUpperCase(),
                                    style: const TextStyle(color: Colors.black),
                                  ));
                            }).toList()
                          : Variable.mcnList.map<DropdownMenuItem<String>>(
                              (Map<String, dynamic> value) {
                              return DropdownMenuItem<String>(
                                value: value['mcn'],
                                child: Text(
                                  value['mcn'].toUpperCase(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                      onChanged: Variable.isLoggedIn!
                          ? null
                          : (String? newValue) {
                              setState(() {
                                Variable.mcnSelected = newValue!;
                                
                                print(Variable.mcnSelected);
                              });
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                controller: controller,
                color: AppColors.primary,
                icon: Icons.person_outline_rounded,
                boldText: true,
                label: 'Scan Penneng',
                enabled: Variable.isLoggedIn! ? false : true,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                onFieldSubmitted: (value) {
                  if(Variable.macAdress.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Silahkan hubungkan printer',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red[600],
                      ),
                    );
                    return;
                } else if ((Variable.dateSys.isEmpty &&
                          Variable.pickedDate.isEmpty) ||
                      (Variable.shfSys.isEmpty && Variable.shift.isEmpty) || (Variable.groupSys.isEmpty && Variable.group.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Silahkan pilih tanggal-shift-group',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red[600],
                      ),
                    );
                    return;
                  } else {
                    print(value);
                    _scanOpr();
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Visibility(
                visible: Variable.isLoggedIn! ? true : false,
                child: SizedBox(
                  width: 120,
                  child: CustomButton(
                    label: 'LOG OUT',
                    icon: Icons.logout_outlined,
                    txtColor: Colors.white,
                    bgColor: AppColors.orange,
                    onPressed: () {
                      _handleLogout();
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                Variable.appVersion,
                style: TextStyle(
                  color: Colors.grey[600]!,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Variable.isLoggedIn!
          ? const BottomNavbar(
              selectedIndex: 0,
            )
          : null,
    );
  }
}

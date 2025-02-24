import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/post_code.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/cek_operator.dart';
import '../apis/get_dateshift.dart';
import '../apis/get_items.dart';
import '../apis/get_mc_by_sec.dart';
import '../apis/update_dvcstat.dart';
import '../components/custom_appbar.dart';
import '../core/app_colors.dart';
import '../core/variable.dart';
import 'config_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _penneng = TextEditingController();
  bool dvcConn = false;
  bool userFound = false;
  List btDvc = [];

  @override
  void initState() {
    super.initState();
    _initData();
    getBluetooth();
    SharedPreferences.getInstance().then((prefs) {
      prefs.getKeys().forEach((key) {
        print('$key: ${prefs.get(key)}');
      });
    });
  }

  @override
  void dispose() {
    _penneng.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await getDateshift();
    await getMcnList();
    await getItems();
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

  Future<void> _scanOperator() async {
    // userFound = false;
    // await cekOpr(_penneng.text);

    final bool response = await cekOpr(_penneng.text);
    if (!response) {
      userFound = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("User Not Found", style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      userFound = true;
    }
    if (userFound) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User Found"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      updateDvcStat('login');
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
          subtitle: "Login",
          config: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: !dvcConn ? null : Variable.macAdress,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.lightblue,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 20,
                                top: 15,
                                bottom: 15,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.lightblue,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(25),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Text(
                      'Pastikan tanggal, shift, dan group sesuai',
                      style: TextStyle(
                        color: AppColors.lightorange,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 16.0,
                      ),
                      child: Text(
                        Variable.pickedDate.isEmpty
                            ? '${Variable.dateSys}-${Variable.shfSys}${Variable.groupSys}'
                            : '${Variable.pickedDate}-${Variable.shift}${Variable.group}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.lightblue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _showDatePicker();
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.lightblue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
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
                  const Icon(
                    Icons.settings,
                    color: AppColors.lightblue,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Mesin',
                        labelStyle: const TextStyle(color: AppColors.lightblue),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.lightblue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          top: 15,
                          bottom: 15,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.lightblue,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      items: Variable.mcnList.map<DropdownMenuItem<String>>(
                          (Map<String, dynamic> value) {
                        return DropdownMenuItem<String>(
                          value: value['mcn'],
                          child: Text(
                            value['mcn'].toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          Variable.mcnSelected = newValue!;
                          print(Variable.mcnSelected);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _penneng,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.lightblue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  labelText: 'Scan Penneng',
                  labelStyle: const TextStyle(color: AppColors.lightblue),
                  suffixIcon: const Icon(Icons.person),
                  suffixIconColor: AppColors.lightblue,
                  contentPadding: const EdgeInsets.only(
                    left: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.lightblue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    if (!dvcConn) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Printer Not Connected",
                              style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (Variable.dateSys.isEmpty &&
                        Variable.pickedDate.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Silahkan Pilih Tanggal",
                              style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (Variable.mcnSelected.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Silahkan Pilih Mesin",
                              style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      _scanOperator();
                    }
                  }
                },
              ),
              // Text(Variable.oprCode ?? 'oprCode'),
              // Text(Variable.oprName ?? 'oprName'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Variable.appVersion,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((value) {
      if (value != null) {
        Variable.pickedDate = DateFormat('dd/MM/yyyy').format(value);
        _showshiftDialog();
      }
    });
  }

  void _showshiftDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Pilih Shift',
            style: TextStyle(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  String selectedShift = Variable.shift;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        title: const Text('Shift 1'),
                        value: 'I',
                        groupValue: selectedShift,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedShift = value!;
                              Variable.shift = value;
                            },
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Shift 2'),
                        value: 'II',
                        groupValue: selectedShift,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedShift = value!;
                              Variable.shift = value;
                            },
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Shift 3'),
                        value: 'III',
                        groupValue: selectedShift,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedShift = value!;
                              Variable.shift = value;
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showDialogGroup();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogGroup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Pilih Group',
            style: TextStyle(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  String selectedGroup = Variable.group;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile<String>(
                        title: const Text('Group A'),
                        value: 'A',
                        groupValue: selectedGroup,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedGroup = value!;
                              Variable.group = value;
                            },
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Group B'),
                        value: 'B',
                        groupValue: selectedGroup,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedGroup = value!;
                              Variable.group = value;
                            },
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Group C'),
                        value: 'C',
                        groupValue: selectedGroup,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedGroup = value!;
                              Variable.group = value;
                            },
                          );
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Group D'),
                        value: 'D',
                        groupValue: selectedGroup,
                        onChanged: (value) {
                          setState(
                            () {
                              selectedGroup = value!;
                              Variable.group = value;
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _initData();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

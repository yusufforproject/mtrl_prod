import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/get_dateshift.dart';
import '../core/app_colors.dart';
import '../core/variable.dart';

class CustomDateshift extends StatefulWidget {
  const CustomDateshift({super.key});

  @override
  State<CustomDateshift> createState() => _CustomDateshiftState();
}

class _CustomDateshiftState extends State<CustomDateshift> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    if(Variable.serverStatus == false) return;
    if(Variable.isLoggedIn == true) return;
    bool getDate = await getDateshift();
    if (getDate) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Gagal mengambil data tanggal dan shift',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Variable.isLoggedIn!
                  ? Text(
                      Variable.pickedDate.isEmpty
                          ? 'Date-shift by system'
                          : 'Date-shift by operator',
                      style: const TextStyle(
                        color: AppColors.lightorange,
                        fontSize: 14,
                      ),
                    )
                  : const Text(
                      'Pastikan tanggal, shift, dan group sesuai',
                      style: const TextStyle(
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
              child: Text(
                Variable.pickedDate.isEmpty
                    ? '${Variable.dateSys}_${Variable.shfSys}${Variable.groupSys}'
                    : '${Variable.pickedDate}_${Variable.shift}${Variable.group}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                    Variable.isLoggedIn! ? null : _showDatePicker();
                    // _showDatePicker();
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Variable.isLoggedIn!
                          ? Colors.grey[600]
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 1,
                          offset: Offset(1, 1),
                        ),
                      ],
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
      ],
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
        showshiftDialog();
      }
    });
  }

  void showshiftDialog() {
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
                        value: '1',
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
                        value: '2',
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
                        value: '3',
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
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

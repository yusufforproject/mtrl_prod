import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/variable.dart';

// bottom navbar has 3 items login, input, print

class BottomNavbar extends StatefulWidget {
  // init index selected for passing
  final int selectedIndex;

  const BottomNavbar({super.key, required this.selectedIndex});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  // init local selectedIndex to track currently
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // init local from constructor
    _selectedIndex = widget.selectedIndex;
  }

  // func tappedNavBottom
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // switch case when tapped icon navbottom
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/prod');
        break;
      case 2:
        if (Variable.schedules.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Text(
                      'No Schedule Found',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[600],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: const Text(
                  'Silahkan scan schedule terlebih dahulu',
                  style: TextStyle(color: Colors.black),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, '/prod');
                    },
                  ),
                ],
              );
            },
          );
        } else {
          Navigator.pushReplacementNamed(context, '/mtrl');
        }
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/rekap');
        break;
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: 'Login',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Produksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'Material',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.file_copy_outlined),
          label: 'Rekap',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.print),
        //   label: 'Print',
        // ),
      ],
      // to tracking indexSelected from ontapped
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.primary,
      showUnselectedLabels: false,
      // when tap navigate to -
      onTap: _onItemTapped,
    );
  }
}

import 'package:flutter/material.dart';

import '../apis/get_dateshift.dart';
import '../apis/get_items.dart';
import '../apis/get_mc_by_sec.dart';
import '../apis/update_dvcstat.dart';
import '../components/bottom_nav.dart';
import '../components/custom_appbar.dart';
import '../core/app_colors.dart';
import '../core/variable.dart';
import 'config_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    // await getDateshift();
    await getMcnList();
    await getItems();
    setState(() {});
  }

  Future<void> _handleLogout() async {
    bool logoutSuccess = await updateDvcStat('logout');
    if (logoutSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logout success"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logout failed"),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
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
          subtitle: 'Home',
          config: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bluetooth Thermal Printer',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '(Connected)',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            items: [],
                            onChanged: null,
                            isExpanded: false,
                            elevation: 0,
                            icon: const SizedBox.shrink(),
                            value: Variable.macAdress.isEmpty
                                ? null
                                : Variable.macAdress,
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
                            hint: Text(Variable.macAdress),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        Variable.pickedDate.isEmpty
                            ? 'Date-shift-group by system'
                            : 'Date-shift-group by user',
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
                        padding: const EdgeInsets.only(left: 16.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey,
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
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  items: [],
                  onChanged: null,
                  isExpanded: false,
                  elevation: 0,
                  icon: const SizedBox.shrink(),
                  value: Variable.macAdress.isEmpty ? null : Variable.macAdress,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.settings, color: AppColors.lightblue),
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
                  hint: Text(Variable.mcnSelected),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.lightblue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.lightblue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelText: '${Variable.oprCode}_${Variable.oprName}',
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
                    enabled: false,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                  'Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _handleLogout();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Transform.rotate(
                        angle: 3.14,
                        child: const Icon(Icons.logout_outlined,
                            color: Colors.white),
                      ),
                      label: const Text('Logout',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                // Text(Variable.oprCode ?? 'oprCode'),
                // Text(Variable.oprName ?? 'oprName'),
                const SizedBox(
                  height: 4,
                ),
                Center(
                  child: Text(
                    Variable.appVersion,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavbar(selectedIndex: 0),
      ),
    );
  }
}

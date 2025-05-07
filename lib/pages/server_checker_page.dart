import 'package:flutter/material.dart';
import 'package:mtrl_prod/components/custom_button.dart';

import '../api/cek_server.dart';
import '../core/app_colors.dart';
import '../core/variable.dart';

class ServerCheckerPage extends StatefulWidget {
  const ServerCheckerPage({super.key});

  @override
  State<ServerCheckerPage> createState() => _ServerCheckerPageState();
}

class _ServerCheckerPageState extends State<ServerCheckerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startChecking();
  }

  Future<void> startChecking() async {
    // await dotenv.load(fileName: '.env');
    await checkServerStatus();
    if (Variable.serverStatus == true) {
      print("Online");
    } else {
      print("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Checking Server Status",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  future: checkServerStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: AppColors.orange,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // if (snapshot.hasData) {
                      bool isOnline = snapshot.data!;

                      // isOnline = false;
                      return AlertDialog(
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                        title: Row(
                          children: [
                            Icon(isOnline ? Icons.network_wifi : Icons.wifi_off_outlined,
                                color: isOnline
                                    ? AppColors.primary
                                    : Colors.red[600]),
                            const SizedBox(width: 8),
                            Text(
                              isOnline ? "Server Online" : "Server Offline",
                              style: TextStyle(
                                color: isOnline
                                    ? AppColors.primary
                                    : Colors.red[600],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          isOnline
                              ? "Jaringan tersedia, silahkan login"
                              : "Sorry, You are in Offline Mode",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: <Widget>[
                          Center(
                            child: CustomButton(
                              label: isOnline ? "LOGIN" : "Offline Mode",
                              icon: isOnline ? Icons.login : Icons.offline_bolt,
                              txtColor: Colors.white,
                              bgColor: isOnline
                                  ? AppColors.primary
                                  : Colors.red[600]!,
                              onPressed: () {
                                // isOnline
                                //     ? Navigator.pushReplacementNamed(
                                //         context, '/login')
                                //     : Navigator.pushReplacementNamed(context, '/offline');
                                Navigator.pushReplacementNamed(context, '/login');
                                setState(() {
                                  Variable.serverStatus = isOnline;
                                  debugPrint('Server status: ${Variable.serverStatus}');
                                });
                              },
                            ),
                          ),
                        ],
                      );
                      // } else {
                      //   return const CircularProgressIndicator(
                      //     color: AppColors.orange,
                      //   );
                      // }
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text(
                    "Refresh",
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

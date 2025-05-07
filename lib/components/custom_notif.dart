import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/variable.dart';

class CustomNotification {
  Future<void> networkError(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.wifi_off_outlined, color: Colors.red[600]),
            const SizedBox(width: 10),
            Text(
              'DISCONNECTED',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: const Text('Mohon maaf,\nJaringan belum tersedia :(',
            style: TextStyle(color: Colors.black, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> blockedOffline(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[600],
        title: const Row(
          children: [
            Icon(
              Icons.wifi_off_outlined,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'BLOCKED',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text('TIDAK BISA DIAKSES KETIKA OFFLINE',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> networkOk(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.wifi, color: Colors.green[600]),
            const SizedBox(width: 10),
            Text(
              'CONNECTED',
              style: TextStyle(
                color: Colors.green[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: const Text(
            'Jaringan Tersedia,\nSilahkan gunakan aplikasi dengan semestinya :)',
            style: TextStyle(color: Colors.black, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> materialEmpty(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[600],
        title: Row(
          children: [
            Icon(
              Icons.do_not_disturb_alt_outlined,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              'MATERIAL EMPTY',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text('MATERIAL TIDAK BOLEH KOSONG',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.popAndPushNamed(context, '/mtrl_acl');
            },
            child: const Text('OK'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> unmatchMaterial(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[600],
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                'MATERIAL\nTIDAK SESUAI',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('${'BOM (' + Variable.schedules[0]['size']}):',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                ...Variable.bom.map((item) {
                  return Text(
                    '- ' + item['child'],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: AppColors.primary),
              ),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/mtrl_acl');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> overSchedule(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[600],
        title: Row(
          children: [
            Icon(
              Icons.more,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              'OVER SCHEDULE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text('TIDAK BOLEH MELEBIHI SCHEDULE',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> notifOk(BuildContext context) async {
    var server = Variable.serverStatus! ? 'SERVER' : 'LOKAL';
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 1400), () {
            Navigator.pop(context);
          });
          return AlertDialog(
            backgroundColor: Colors.green[600],
            title: Row(
              children: [
                Icon(
                  Icons.check_circle_outline_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  'SUCCESS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Text(
              'DATA TERSIMPAN DI $server',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          );
        });
  }

  Future<void> notifConfirm(
      BuildContext context, String message, Function() onConfirm) async {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.red[600],
            ),
            const SizedBox(width: 10),
            Text(
              'KONFIRMASI',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm(); // Call the function passed as a parameter
                  setState(() {
                  });
                },
                child: Text(
                  'Ya',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

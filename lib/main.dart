import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mtrl_prod/pages/abc/hist_srt_page.dart';
import 'package:mtrl_prod/pages/acl/emergency_page.dart';
import 'package:mtrl_prod/pages/local_page.dart';
import 'package:mtrl_prod/pages/server_checker_page.dart';

import 'core/app_colors.dart';
import 'core/saved_configuration.dart';
import 'core/variable.dart';
import 'pages/abc/mat_abc_page.dart';
import 'pages/abc/surat_jalan_page.dart';
import 'pages/acl/ganti_roll_page.dart';
import 'pages/acl/mat_acl_page.dart';
import 'pages/config_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/login_page_v2.dart';
import 'pages/prod_page.dart';
import 'pages/rekap_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  print(dotenv.env);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Load the saved configuration before building the app
    SavedConfiguration.load();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Variable.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const ServerCheckerPage(),
      routes: {
        '/check': (context) => const ServerCheckerPage(),
        '/login': (context) => const LoginPageV2(),
        '/home': (context) => const HomePage(),
        '/prod': (context) => const ProdPage(),
        '/srtjln': (context) => const SrtJlnPage(),
        '/mtrl': (context) => const MatAbcPage(),
        '/mtrl_acl': (context) => const MatAclPage(),
        '/rekap': (context) => const RekapPage(),
        '/hist_srt': (context) => const HistSrtPage(),
        '/lokal': (context) => const LocalPage(),
        '/emergency': (context) => const EmergencyPage(),
        '/gantinoroll': (context) => const GantiRollPage(),
      },
    );
  }
}

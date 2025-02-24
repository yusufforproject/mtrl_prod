import 'package:flutter/material.dart';
import 'package:mtrl_prod/pages/abc/hist_srt_page.dart';

import 'core/app_colors.dart';
import 'core/saved_configuration.dart';
import 'core/variable.dart';
import 'pages/abc/mat_abc_page.dart';
import 'pages/abc/surat_jalan_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/prod_page.dart';
import 'pages/rekap_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SavedConfiguration.load();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Variable.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/prod': (context) => const ProdPage(),
        '/srtjln': (context) => const SrtJlnPage(),
        '/mtrl': (context) => const MatAbcPage(),
        '/rekap': (context) => const RekapPage(),
        '/hist_srt': (context) => const HistSrtPage(),
      },
    );
  }
}

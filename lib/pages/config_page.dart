import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/saved_configuration.dart';
import '../core/variable.dart';
import 'home_page.dart';
import 'login_page.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final mainipController = TextEditingController();
  final mixipController = TextEditingController();
  final sectionController = TextEditingController();
  final subSecController = TextEditingController();
  final dvcIdController = TextEditingController();
  final dvcPlacedController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainipController.text = Variable.baseUrl;
    mixipController.text = Variable.mixIP;
    sectionController.text = Variable.sect;
    subSecController.text = Variable.subSec;
    dvcIdController.text = Variable.dvcId;
    dvcPlacedController.text = Variable.dvcPlaced;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Variable.appName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              "Config | ${Variable.appSubtitle}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            if (Variable.oprCode != '') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Main IP',
                ),
                controller: mainipController,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'IP Mixing',
                ),
                controller: mixipController,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Section',
                      ),
                      controller: sectionController,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Sub Section',
                      ),
                      controller: subSecController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Device ID',
                      ),
                      controller: dvcIdController,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Device Placed',
                      ),
                      controller: dvcPlacedController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      Variable.baseUrl = mainipController.text;
                      Variable.mixIP = mixipController.text;
                      Variable.sect = sectionController.text;
                      Variable.subSec = subSecController.text;
                      Variable.dvcId = dvcIdController.text;
                      Variable.dvcPlaced = dvcPlacedController.text;
                      Variable.mcnSelected = '';
                      SavedConfiguration.save();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Configuration Saved!"),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

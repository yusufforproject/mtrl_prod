import 'package:flutter/material.dart';

import '../data/database_helper.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  final dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stored Messages")),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  // await dbHelper.printDatabasePath();
                  await dbHelper.initDB();
                  setState(() {});
                },
                child: Icon(Icons.start),
              ),
              TextButton(
                onPressed: () async {
                  // await dbHelper.printDatabasePath();
                  // await dbHelper.insertMessage("Hello, World!");
                  await dbHelper.insertAbcBarcode(2);
                  setState(() {});
                },
                child: Icon(Icons.add),
              ),
              TextButton(
                onPressed: () async {
                  // await dbHelper.printDatabasePath();
                  await dbHelper.deleteAllMessages();
                  // await dbHelper.resetDatabase();
                  setState(() {});
                },
                child: Icon(Icons.delete),
              ),
              TextButton(
                onPressed: () async {
                  // await dbHelper.printDatabasePath();
                  // var msg = await dbHelper.getMessages();
                  var msg = await dbHelper.getDataAbc();
                  setState(() {
                    print(msg);
                  });
                },
                child: Icon(Icons.get_app),
              ),
            ],
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: dbHelper.getDataAbc(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.data);
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No messages stored"));
              }

              List<Map<String, dynamic>> messages = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: messages.map((message) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(message['id'].toString()),
                          SizedBox(width: 3,),
                          Text(
                            message['bc_entried'],
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 3,),
                          Text(
                            message['qcode_sch'],
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 3,),
                          Text(
                            message['timestamp'],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

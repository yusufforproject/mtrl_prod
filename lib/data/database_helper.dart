import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../core/variable.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'a2a.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE txns(id INTEGER PRIMARY KEY, bc_entried TEXT, tanggal VARCHAR(20), shift VARCHAR(10), grp VARCHAR(10), tglprod VARCHAR(20), expireddt VARCHAR(20), mcn VARCHAR(10), size VARCHAR(50), qty VARCHAR(10), opr VARCHAR(20), idprint VARCHAR(50), idtag VARCHAR(50), qcode_sch VARCHAR(50), mtrl TEXT, section VARCHAR(50), timestamp TEXT)",
        );
      },
    );
  }

  Future<void> printDatabasePath() async {
    String path = await getDatabasesPath();
    print("📂 Database Path: $path");
  }

  Future<void> insertMessage(String text) async {
    final db = await database;
    String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    await db.insert(
      'txns',
      {'text': text, 'timestamp': dateTime},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAbcBarcode(qty) async {
    final db = await database;

    Variable.mcnSelected =
        Variable.mcnSelected.isEmpty ? 'ABC1' : Variable.mcnSelected;
    Variable.pickedDate = '26/02/2025';
    Variable.shift = 'I';
    var shiftIndex = 0;
    switch (Variable.shift) {
      case 'I':
        shiftIndex = 1;
        break;
      case 'II':
        shiftIndex = 2;
        break;
      case 'III':
        shiftIndex = 3;
        break;
      default:
        shiftIndex = 0;
    }
    Variable.group = 'A';
    var groupIndex = 0;
    switch (Variable.group) {
      case 'A':
        groupIndex = 1;
        break;
      case 'B':
        groupIndex = 2;
        break;
      case 'C':
        groupIndex = 3;
        break;
      case 'D':
        groupIndex = 4;
        break;
      default:
        groupIndex = 0;
    }
    Variable.oprCode = '00-0000';
    Variable.schedules.add({
      'size': 'TEST1',
      'qcode_sch': 'TEST1_999',
    });
    Variable.treatmentDetails.add({
      'bc_entried': 'TEST1',
    });

    Variable.idPrint =
        '${Variable.mcnSelected}-${DateTime.now().millisecondsSinceEpoch}';
    var tanggal =
        Variable.pickedDate.isEmpty ? Variable.dateSys : Variable.pickedDate;
    var shift = Variable.pickedDate.isEmpty ? Variable.shfSys : Variable.shift;
    var grp = Variable.pickedDate.isEmpty ? Variable.groupSys : Variable.group;
    var size = Variable.schedules[0]['size'];
    var qcodeSch = Variable.schedules[0]['qcode_sch'];
    var mtrl = Variable.treatmentDetails[0]['bc_entried'];
    String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    var tglprod = '${tanggal}_$shiftIndex$groupIndex';
    var expireddt = DateFormat('dd/MM/yyyy')
        .format(DateFormat('dd/MM/yyyy').parse(tanggal).add(Duration(days: 4)));
    var idtag =
        '${tanggal.split('/')[0]}${groupIndex}${Variable.mcnSelected.replaceAll('ABC', '').padLeft(2, '0')}-${expireddt.split('/')[0]}${expireddt.split('/')[1]}';

    int convert = 1;
    switch (Variable.schedules[0]['size'].split('-').first) {
      case 'APB':
        convert = 29;
        break;
      case 'ABB':
        convert = 36;
        break;
      case 'ACB':
        convert = 30;
        break;
      case 'AFB':
        convert = 28;
        break;
      default:
        convert = 1;
    }

    for (int i = 0; i < qty; i++) {
      var bcEntried = '${size}_${DateTime.now().millisecondsSinceEpoch}';
      await db.insert(
        'txns',
        {
          'bc_entried': bcEntried,
          'tanggal': tanggal,
          'shift': shift,
          'grp': grp,
          'tglprod': tglprod,
          'expireddt': expireddt,
          'mcn': Variable.mcnSelected,
          'size': size,
          'qty': convert,
          'opr': Variable.oprCode,
          'idprint': Variable.idPrint,
          'idtag': idtag,
          'qcode_sch': qcodeSch,
          'mtrl': mtrl,
          'section': Variable.sect,
          'timestamp': dateTime
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await database;
    return await db.query('txns', orderBy: "id DESC");
  }

  Future<List<Map<String, dynamic>>> getDataAbc() async {
    final db = await database;
    return await db.query('txns',
        where: "qcode_sch = ? AND idprint = ?",
        whereArgs: [Variable.schedules[0]['qcode_sch'], Variable.idPrint],
        orderBy: "id ASC");
  }

  Future<void> deleteMessage(int id) async {
    final db = await database;
    await db.delete('txns', where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteAllMessages() async {
    final db = await database;
    await db.delete('txns');
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS txns");
    await db.execute(
      "CREATE TABLE txns(id INTEGER PRIMARY KEY, bc_entried TEXT, tanggal VARCHAR(20), expireddt VARCHAR(20), shift VARCHAR(10), grp VARCHAR(10), tglprod VARCHAR(20), mcn VARCHAR(10), size VARCHAR(50), qty VARCHAR(10), opr VARCHAR(20), idprint VARCHAR(50), idtag VARCHAR(50), qcode_sch VARCHAR(50), mtrl TEXT, section VARCHAR(50), timestamp TEXT)",
    );
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'a1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> ensureTablesExist() async {
    Database db = await database;

    await db.execute('''
      CREATE TABLE IF NOT EXISTS aaa (
        recid INTEGER PRIMARY KEY AUTOINCREMENT,
        txn_key TEXT,
        bc_entried TEXT,
        bc_alias TEXT,
        tglsg TEXT,
        expdt TEXT,
        qty TEXT,
        mcn TEXT,
        opr TEXT,
        sch TEXT,
        mtrl TEXT,
        idprint TEXT,
        idroll TEXT,
        section TEXT,
        created_at TEXT,
        txn_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS abc_prod (
        recid INTEGER PRIMARY KEY AUTOINCREMENT,
        bc_entried TEXT,
        tglsg TEXT,
        expdt TEXT,
        qty TEXT,
        mcn TEXT,
        opr TEXT,
        sch TEXT,
        mtrl TEXT,
        idprint TEXT,
        idtag TEXT,
        section TEXT,
        created_at TEXT,
        txn_date TEXT
      )
    ''');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE aaa (
        recid INTEGER PRIMARY KEY AUTOINCREMENT,
        txn_key TEXT,
        bc_entried TEXT,
        bc_alias TEXT,
        tglsg TEXT,
        expdt TEXT,
        qty TEXT,
        mcn TEXT,
        opr TEXT,
        sch TEXT,
        mtrl TEXT,
        idprint TEXT,
        idroll TEXT,
        section TEXT,
        created_at TEXT,
        txn_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE abc_prod (
        recid INTEGER PRIMARY KEY AUTOINCREMENT,
        bc_entried TEXT,
        tglsg TEXT,
        expdt TEXT,
        qty TEXT,
        mcn TEXT,
        opr TEXT,
        sch TEXT,
        mtrl TEXT,
        idprint TEXT,
        idtag TEXT,
        section TEXT,
        created_at TEXT,
        txn_date TEXT
      )
    ''');

  }

  Future<bool> checkDuplicate(String bcEntried) async {
    Database db = await database;
    var result = await db.query(
      'aaa',
      where: 'bc_entried = ?',
      whereArgs: [bcEntried],
    );
    return result.isNotEmpty;
  }

  Future<int> insertAcl(Map<String, dynamic> row) async {
    // bool isDuplicate = await checkDuplicate(row['bc_entried']);
    // if (isDuplicate) {
    //   throw Exception('Duplicate entry found for bc_entried: ${row['bc_entried']}');
    // }

    Database db = await database;
    return await db.insert('aaa', row);
  }

  Future<List<Map<String, dynamic>>> fetchDataLocalAcl(String sch) async {
    Database db = await database;
    ensureTablesExist();
    // print(await db.query(
    //   'aaa',
    //   where: 'sch = ?',
    //   whereArgs: [sch],
    // ));
    return await db.query(
      'aaa',
      where: 'sch = ?',
      whereArgs: [sch],
    );
  }

  Future<List<Map<String, dynamic>>> fetchDataLocalAclForRekap() async {
    Database db = await database;
    ensureTablesExist();
    return await db.rawQuery('SELECT tglsg, sch, COUNT(*) as qty FROM aaa GROUP BY sch, tglsg ORDER BY recid DESC');
  }

  Future<List<Map<String, dynamic>>> getScheduleLocal() async {
    Database db = await database;
    ensureTablesExist();
    return await db.rawQuery('SELECT tglsg, sch, COUNT(*) as qty FROM aaa GROUP BY sch');
  }

  // fetchALl
  Future<List<Map<String, dynamic>>> fetchAll() async {
    Database db = await database;
    return await db.query('aaa');
  }
  // Future<int> update(Map<String, dynamic> row) async {
  //   Database db = await database;
  //   int id = row['recid'];
  //   return await db
  //       .update('tire_prod', row, where: 'recid = ?', whereArgs: [id]);
  // }

  // Future<int> delete(int id) async {
  //   Database db = await database;
  //   return await db.delete('tire_prod', where: 'recid = ?', whereArgs: [id]);
  // }

  Future<int> deleteAllAcl() async {
    Database db = await database;
    return await db.delete('aaa');
  
  }
  Future<int> deleteAllAbc() async {
    Database db = await database;
    return await db.delete('abc_prod');
  }

  Future<List<Map<String, dynamic>>> fetchDataLocalBySch(String qcodeSch) async {
    Database db = await database;
    var result = await db.query('aaa', where: 'qcode_sch = ?', whereArgs: [qcodeSch]);
    // Variable.barcodesBySch.clear();
    // Variable.barcodesBySch.addAll(result);
    print(result);
    return result;
  }
}

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/resultModel.dart';

class DatabaseHelper {
  static Database _db;

  // DB Name
  static const String dbName = 'myDatabase.db';
  // Table Name
  static const String tbl_11 = 'tbl_one_one';
  static const String tbl_12 = 'tbl_one_two';
  static const String tbl_21 = 'tbl_two_one';
  static const String tbl_22 = 'tbl_two_two';
  static const String tbl_31 = 'tbl_three_one';
  static const String tbl_32 = 'tbl_three_two';
  static const String tbl_41 = 'tbl_four_one';
  static const String tbl_42 = 'tbl_four_two';
  // Columns Name
  static const String colId = 'id';
  static const String colSubject = 'subject';
  static const String colGrade = 'grade';
  static const String colCredit = 'credit';

  // DatabaseHelper(sem);  // using constructor should try to go through the tables

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await initDatabase();
    return _db;
  }

  Future<Database> initDatabase() async {
    // Get the directory path for the both android and ios to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, dbName);

    // Open/create the database at a given path
    return await openDatabase(dbPath, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tbl_11(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colSubject TEXT, 
        $colGrade DOUBLE, 
        $colCredit INTEGER)
        ''');
    await db.execute('''
        CREATE TABLE $tbl_12(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colSubject TEXT, 
        $colGrade DOUBLE, 
        $colCredit INTEGER)
        ''');
    await db.execute('''
        CREATE TABLE $tbl_21(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colSubject TEXT, 
        $colGrade DOUBLE, 
        $colCredit INTEGER)
        ''');
    await db.execute('''
        CREATE TABLE $tbl_22(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colSubject TEXT, 
        $colGrade DOUBLE, 
        $colCredit INTEGER)
        ''');
    await db.execute('''
        CREATE TABLE $tbl_31(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colSubject TEXT, 
        $colGrade DOUBLE, 
        $colCredit INTEGER)
        ''');
    await db.execute('''
        CREATE TABLE $tbl_32(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colSubject TEXT, 
        $colGrade DOUBLE, 
        $colCredit INTEGER)
        ''');
    await db.execute('''
        CREATE TABLE $tbl_41(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colSubject TEXT, 
        $colGrade DOUBLE, 
        $colCredit INTEGER)
        ''');
    await db.execute('''
        CREATE TABLE $tbl_42(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colSubject TEXT, 
        $colGrade DOUBLE, 
        $colCredit INTEGER)
        ''');
    print('Result Tables Created!');
  }

  // Insert to db
  Future<Result> addResult(Result result, tblName) async {
    var dbClient = await database;
    result.id = await dbClient.insert(tblName, result.toMap());
    return result;
  }

  // Get all from db
  Future<List<Result>> getResult(String tblName) async {
    var dbClient = await database;
    List<Map> maps = await dbClient
        .query(tblName, columns: [colId, colSubject, colGrade, colCredit]);
    // List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");  // Need to modify according to app
    List<Result> results = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        results.add(Result.fromMap(maps[i]));
      }
      return results;
    } else {
      return null;
    }
  }

  // Update
  // Future<int> updateResult(Result result, String tblName) async {
  //   var dbClient = await database;
  //   return await dbClient.update(tblName, result.toMap(),
  //       where: '$colId = ?', whereArgs: [result.id]);
  // }

  // Delete from db
  Future<int> delResult(int id, String tblName) async {
    var dbClient = await database;
    return await dbClient.delete(tblName, where: '$colId = ?', whereArgs: [id]);
  }

  // Get total of (credit * grade) from db
  Future getCreditGrade(String tblName) async {
    var dbClient = await database;
    // Get total of (grade * credit)
    var val = await dbClient.rawQuery('SELECT SUM($colGrade*$colCredit) FROM $tblName');
    var totGradCred = val[0]['SUM($colGrade*$colCredit)'];
    if (totGradCred == null) return 0;
    return totGradCred;
  }

  // Get total credit from db
  Future<int> getTotalCredit(String tblName) async {
    var dbClient = await database;
    var sql = 'SELECT SUM ($colCredit) from $tblName';
    if (Sqflite.firstIntValue(await dbClient.rawQuery(sql)) == null) return 0;
    return Sqflite.firstIntValue(await dbClient.rawQuery(sql));
  }

  // clear table records
  Future dropSpecificTable(String tblName) async {
    var dbClient = await database;
    dbClient.delete(tblName);
    print('$tblName Table Data Deleted!');
    return null;
  }

  // clear table records
  Future dropResultTables() async {
    var dbClient = await database;
    dbClient.delete(tbl_11);
    dbClient.delete(tbl_12);
    dbClient.delete(tbl_21);
    dbClient.delete(tbl_22);
    dbClient.delete(tbl_31);
    dbClient.delete(tbl_32);
    dbClient.delete(tbl_41);
    dbClient.delete(tbl_42);
    print('All Result Data Deleted!');
    return null;
  }

  // Close the db
  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}

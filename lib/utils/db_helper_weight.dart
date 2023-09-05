import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/weightModel.dart';

class DatabaseHelperWeight {

  static Database _db;

  // DB Name
  static const String dbName = 'myDbWeight.db';
  // Table Name
  static const String tblName = 'tbl_weight';
  // Columns Name
  static const String Id = 'id';
  static const String yearOne_weight = 'yr_one';
  static const String yearTwo_weight = 'yr_two';
  static const String yearThree_weight = 'yr_three';
  static const String yearFour_weight = 'yr_four';

  Future<Database> get database async {
    if(_db != null) return _db;
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
    await db.execute(
        '''
        CREATE TABLE $tblName(
        $Id INTEGER PRIMARY KEY AUTOINCREMENT,
        $yearOne_weight DOUBLE,
        $yearTwo_weight DOUBLE,
        $yearThree_weight DOUBLE,
        $yearFour_weight DOUBLE)
        '''
    );
    print('Weight Table Created!');
  }

  // Insert to db
  Future<Weight> addWeight(Weight weight) async {
    var dbClient = await database;
    weight.id = await dbClient.insert(tblName, weight.toMap());
    print('Weight Data Added!');
    return weight;
  }

  // Get all from db
  Future<List<Weight>> getWeight() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query(tblName, columns: [Id, yearOne_weight, yearTwo_weight, yearThree_weight, yearFour_weight]);
    List<Weight> weights = [];
    if (maps.length > 0) {
      for(int i=0; i<maps.length; i++) {
        var values = Weight(maps[i][Id], maps[i][yearOne_weight], maps[i][yearTwo_weight], maps[i][yearThree_weight], maps[i][yearFour_weight]);
        weights.add(values);
      }
      print('Weight Data Retrieved!');
      return weights;
    } else {
      print('Weight Data Not Retrieved!');
      return null;
    }
  }

// Get total of (credit * grade) from db
  Future getWeightValue(String value) async {
    var dbClient = await database;
    var val = await dbClient.rawQuery('SELECT SUM($value) FROM $tblName');
    var weight = val[0]['SUM($value)'];
    if (weight == null) return 0.25;
    return weight;
  }

  // Update Weight
  Future<int> updateWeight(Weight weight) async {
    var dbClient = await database;
    print('Weight Data Updated!');
    return await dbClient.update(tblName, weight.toMap(), where: '$Id = ?', whereArgs: [weight.id]);
  }

  // clear table records
  Future dropWeightTable() async {
    var dbClient = await database;
    dbClient.delete(tblName);
    print('All Weight Data Deleted!');
    return null;
  }

  // Close the db
  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}
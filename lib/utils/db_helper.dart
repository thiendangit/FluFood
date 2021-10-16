import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return db;
    }

    _db = await initialDatabase();
  }

  initialDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database database, int version) async {
    // await database.execute(
    //   // database.execute('CREATE TABLE cart(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)', version);
    // );
  }
}

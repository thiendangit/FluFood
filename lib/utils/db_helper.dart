import 'package:flufood/models/cart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static final table = 'cart';

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

  // Cart model
  // int id;
  // String name;
  // String sku;
  // String? price;
  // String? regularPrice;
  // String salePrice;
  // List<ImageType>? images;
  // int quantity;
  _onCreate(Database database, int version) async {
    await database.execute('''
        CREATE TABLE cart(
        id INTEGER PRIMARY KEY,
        name TEXT,
        sku TEXT,
        price INTEGER,
        regularPrice INTEGER,
        salePrice INTEGER,
        quantity INTEGER,
        images BLOB)
        ''');
  }

  Future<Cart?> insert(Cart cart) async {
    var dbClient = _db;
    await dbClient?.insert(table, cart.toJson());
    return cart;
  }
}

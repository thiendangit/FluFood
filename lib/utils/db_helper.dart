import 'package:flufood/models/cart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  Future<Database> get db async => _db ??= await initialDatabase();

  initialDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
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
  _onCreate(Database db, int version) {
    db.execute('''
        CREATE TABLE cart(
        id INTEGER PRIMARY KEY,
        product_id INTEGER,
        name TEXT,
        sku TEXT,
        price TEXT,
        regular_price TEXT,
        sale_price TEXT,
        images TEXT,
        quantity INTEGER)
        ''');
  }

  Future<Cart?> insert(Cart cart) async {
    Database dbClient = await instance.db;
    await dbClient.insert(
      'cart',
      cart.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return cart;
  }

  Future<Cart?> delete(int id) async {
    Database dbClient = await instance.db;
    await dbClient.delete('cart', where: 'id=?', whereArgs: [id]);
  }

  Future<Cart?> updateQuantity(int id, int qty) async {
    Database dbClient = await instance.db;
    await dbClient.update(
      'cart',
      {'quantity': qty},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<Cart?> getProductQtyByID(int id) async {
    Database dbClient = await instance.db;
    await dbClient.query(
      'cart',
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<List<Cart>> getCartList() async {
    Database dbClient = await instance.db;
    final List<Map<String, dynamic>> queryResult = await dbClient.query('cart');
    List<Cart>? result = queryResult.isNotEmpty
        ? queryResult.map((e) => Cart.fromJson(e)).toList()
        : [];
    return result;
  }
}

import 'package:ipari/data/model/wisata.dart';
import 'package:sqflite/sqflite.dart';

/*
  Credit this Screen
  SQflite => https://pub.dev/packages/sqflite
*/

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavorites = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/ipari.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavorites(
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             province TEXT,
             category TEXT,
             latitude TEXT,
             longitude TEXT,
             url_image TEXT
        )''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavorite(Wisata wisata) async {
    final db = await database;
    await db!.insert(_tblFavorites, wisata.toJson());
  }

  Future<List<Wisata>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavorites);

    return results.map((res) => Wisata.fromJson(res)).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(
      _tblFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

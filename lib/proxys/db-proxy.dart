import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:restaurant/models/restaurant-list-model.dart';

class DbProxy {
  static DbProxy? _instance;
  static Database? _database;

  DbProxy._internal() {
    _instance = this;
  }

  factory DbProxy() => _instance ?? DbProxy._internal();

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tableName = 'favorite';

  Future<Database> _initDb() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, 'restaurant_db.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          restaurant_id TEXT UNIQUE,
          name TEXT,
          description TEXT,
          picture_id TEXT,
          city TEXT,
          rating DOUBLE
        )
      ''');
      },
    );
  }

  Future<void> insertFavorite(RestaurantListModel restaurant) async {
    final db = await database;
    await db!.insert(_tableName, {
      'restaurant_id': restaurant.id,
      'name': restaurant.name,
      'description': restaurant.description,
      'picture_id': restaurant.pictureId,
      'city': restaurant.city,
      'rating': restaurant.rating,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<RestaurantListModel>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tableName);

    return results.map((res) => RestaurantListModel(
      id: res['restaurant_id'],
      name: res['name'],
      description: res['description'],
      pictureId: res['picture_id'],
      city: res['city'],
      rating: res['rating']?.toDouble(),
    )).toList();
  }

  Future<void> removeFavorite(String restaurantId) async {
    final db = await database;
    await db!.delete(
      _tableName,
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
    );
  }

  Future<bool> isFavorite(String restaurantId) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      _tableName,
      where: 'restaurant_id = ?',
      whereArgs: [restaurantId],
    );
    return results.isNotEmpty;
  }
}

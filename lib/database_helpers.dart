import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableCards = 'cards';
final String columnId = '_id';
final String columnCard = 'card';
final String columnCategory = 'category';
final String columnURL = 'url';
final String columnIsAsset = 'isAsset';



// data model class
class MyCard {

  int id;
  String card;
  String category;
  String url;
  int isAsset;
  
  MyCard();

  // convenience constructor to create a MyCard object
  MyCard.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    card = map[columnCard];
    category = map[columnCategory];
    url = map[columnURL];
    isAsset = map[columnIsAsset];

  }

  // convenience method to create a Map from this MyCard object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCard: card,
      columnCategory: category,
      columnURL: url,
      columnIsAsset: isAsset,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableCards (
                $columnId INTEGER PRIMARY KEY,
                $columnCard TEXT NOT NULL,
                $columnCategory TEXT NULL,
                $columnURL TEXT NULL,
                $columnIsAsset BOOLEAN NOT NULL DEFAULT 0
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(MyCard card) async {
    Database db = await database;
    int id = await db.insert(tableCards, card.toMap());
    return id;
  }

  Future<MyCard> queryCard(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCards,
        columns: [columnId, columnCard, columnCategory, columnURL, columnIsAsset],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return MyCard.fromMap(maps.first);
    }
    return null;
  }
  Future<List<MyCard>> queryCardsByCategory(String category) async {
    Database db = await database;

    var res = await db.query(tableCards,
                            columns: [columnId, columnCard, columnCategory, columnURL, columnIsAsset],
                            where: '$columnCategory = ?',
                            whereArgs: [category]);

    List<MyCard> list =
    res.isNotEmpty ? res.map((c) => MyCard.fromMap(c)).toList() : null;

    return list;
  }


  Future<bool> queryCheckCardExists() async {
    Database db = await database;
    var res = await db.query(tableCards, limit:1);
    return res.isNotEmpty;
  }


 Future<List<MyCard>> queryAllCards() async {
    Database db = await database;

    var res = await db.query(tableCards);

    List<MyCard> list =
    res.isNotEmpty ? res.map((c) => MyCard.fromMap(c)).toList() : null;

    return list;
  }
  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(tableCards, where:"$columnId=?",whereArgs: [id]);
  }

  Future<int> update(MyCard card) async {
    Database db = await database;
    int id = await db.update(tableCards, {columnCard:card.card,columnCategory:card.category,columnURL:card.url},where:"$columnId=?",whereArgs: [card.id]);
    return id;
  }
}

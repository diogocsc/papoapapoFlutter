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


// data model class
class MyCard {

  int id;
  String card;
  String category;
  String url;
  
  MyCard();

  // convenience constructor to create a MyCard object
  MyCard.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    card = map[columnCard];
    category = map[columnCategory];
    url = map[url];
  }

  // convenience method to create a Map from this MyCard object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCard: card,
      columnCategory: category,
      columnURL: url,
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
                $columnURL TEXT NULL

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
        columns: [columnId, columnCard, columnCategory, columnURL],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return MyCard.fromMap(maps.first);
    }
    return null;
  }

// TODO: queryAllCards()
  Future<List<MyCard>> queryAllCards() async {
    Database db = await database;

    var res = await db.query(tableCards);

    List<MyCard> list =
    res.isNotEmpty ? res.map((c) => MyCard.fromMap(c)).toList() : null;

    return list;
  }
// TODO: delete(int id)
// TODO: update(MyCard card)
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'place.dart';

class DbHelper {
  final int version = 1;
  Database db;
  List<Place> places = [];

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'mapp.db'),
          onCreate: (database, version) {
            database.execute(
                'CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, '+
                'lat DOUBLE, lon DOUBLE, image TEXT)');
          }, version: version);
    }
    return db;
  }

  Future insertMockData() async {
    db = await openDb();
    await db.execute('INSERT INTO places VALUES (1, '+
        '"아름다운 공원", 37.28315849652304, 127.06577954236695, "")');
    await db.execute('INSERT INTO places VALUES (2, '+
        '"세계 최고의 피자", 37.25310263918093, 127.07969512922185, "")');
    await db.execute('INSERT INTO places VALUES (3, '+
        '"지구 최상의 아이스크림", 37.23890638513927, 127.05551418054587, "")');
    List places = await db.rawQuery('select * from places');
    print(places[0].toString());
  }

  Future<List<Place>> getPlaces() async {
    final List<Map<String, dynamic>> maps = await db.query('places');
    this.places = List.generate(maps.length, (i) {
      return Place( maps[i]['id'],
        maps[i]['name'], maps[i]['lat'], maps[i]['lon'],
        maps[i]['image'],
      );
    });
    return places;
  }

  Future<int> insertPlace(Place place) async {
    int id = await this.db.insert('places',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> deletePlace(Place place) async {
    int result = await db.delete("places", where: "id = ?", whereArgs: [place.id]);
    return result;
  }

}
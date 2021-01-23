import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'todo.dart';

class TodoDb {
//이것은 싱글톤이어야 합니다.
  static final TodoDb _singleton = TodoDb._internal();
//private internal 생성자
  TodoDb._internal();
  DatabaseFactory dbFactory = databaseFactoryIo;
  final store = intMapStoreFactory.store('todos');
  Database _database;

  factory TodoDb() {
    return _singleton;
  }

  Future<Database> get database async {
    if (_database == null) {
      await _openDb().then((db) {
        _database = db;
      });
    }
    return _database;
  }

  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future insertTodo(Todo todo) async {
    await store.add(_database, todo.toMap());
  }

  Future updateTodo(Todo todo) async {
    //Finder는 특정 store를 검색하는 헬퍼입니다
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database, todo.toMap(), finder: finder);
  }

  Future deleteTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database, finder: finder);
  }

  Future deleteAll() async {
    // store로부터 모든 레코드를 제거합니다
    await store.delete(_database);
  }

  Future<List<Todo>> getTodos() async {
    await database;
    final finder = Finder(sortOrders: [
      SortOrder('priority'), SortOrder('id'),
    ]);
    final todosSnapshot = await store.find(_database, finder: finder);
    return todosSnapshot.map((snapshot){
      final todo = Todo.fromMap(snapshot.value);
      // id는 자동으로 생성됩니다
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }

}

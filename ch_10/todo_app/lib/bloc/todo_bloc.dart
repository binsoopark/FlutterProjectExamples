import 'dart:async';
import '../data/todo.dart';
import '../data/todo_db.dart';

class TodoBloc {
  TodoDb db;
  List<Todo> todoList;

  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();

  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  TodoBloc() {
    db = TodoDb();
    getTodos();

    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);

  }

  Future getTodos() async {
    List<Todo> todos = await db.getTodos();
    todoList = todos;
    todosSink.add(todos);
  }

  List<Todo> returnTodos (todos) {
    return todos;
  }

  void _deleteTodo(Todo todo) {
    db.deleteTodo(todo).then((result){
      getTodos();
    });
  }

  void _updateTodo(Todo todo) {
    db.updateTodo(todo).then((result){
      getTodos();
    });
  }

  void _addTodo(Todo todo) {
    db.insertTodo(todo).then((result) {
      getTodos();
    });
  }

  //dispose 메서드에서 스트림 컨트롤러를 닫아야 합니다
  void dispose() {
    _todosStreamController.close();
    _todoInsertController.close();
    _todoUpdateController.close();
    _todoDeleteController.close();
  }

}
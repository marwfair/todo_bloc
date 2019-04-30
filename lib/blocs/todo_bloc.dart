import 'dart:async';

import 'package:to_do_bloc/daos/todo_dao.dart';
import 'package:to_do_bloc/models/todo_item.dart';

class ToDoBloc {
  final ToDoDao _todoDao = ToDoDao();

  final _todoController = StreamController<List<ToDoItem>>.broadcast();

  get todoController => _todoController.stream;

  getTodos() async {
    _todoController.sink.add(await _todoDao.getToDoItems());
  }

  saveTodoItem(ToDoItem todoItem) async {
    await _todoDao.saveToDoItem(todoItem);
  }

  saveSortOrder(List<ToDoItem> todoItems) async {
    await _todoDao.saveSortOrder(todoItems);
    getTodos();
  }

  saveCompleted(ToDoItem todoItem) async {
    await _todoDao.saveCompleted(todoItem);
    getTodos();
  }

  deleteToDoItem(ToDoItem todoItem) async {
    await _todoDao.deleteToDoItem(todoItem);
    getTodos();
  }

  dispose() {
    _todoController.close();
  }
}

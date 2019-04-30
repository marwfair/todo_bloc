import 'package:flutter/material.dart';
import 'package:to_do_bloc/blocs/todo_bloc.dart';
import 'package:to_do_bloc/models/todo_item.dart';
import 'package:to_do_bloc/screens/create_item_screen.dart';
import 'package:to_do_bloc/widgets/todo_item_cell.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<ToDoItem> _items;
  ToDoBloc bloc = ToDoBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do'),
      ),
      body: StreamBuilder(
        stream: bloc.todoController,
        builder: (context, AsyncSnapshot<List<ToDoItem>> snapshot) {
          if (snapshot.hasData) {
            _items = snapshot.data;
            return Scrollbar(
              child: ReorderableListView(
                onReorder: _onReorder,
                reverse: false,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: _items.map<Widget>(buildListItem).toList(),
              ),
            );
          } else if (snapshot.hasError) {}

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        tooltip: 'Add New Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewItem() {
    Navigator.push(
            context,
            MaterialPageRoute<Map<dynamic, dynamic>>(
                builder: (BuildContext context) {
                  return CreateItemScreen();
                },
                fullscreenDialog: true))
        .then((dynamic result) {
      bloc.getTodos();
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final ToDoItem item = _items.removeAt(oldIndex);

    item.sortOrder = newIndex;
    _items.insert(newIndex, item);

    for (int i = 0; i < _items.length; i++) {
      ToDoItem todoItem = _items[i];
      todoItem.sortOrder = i;
    }

    bloc.saveSortOrder(_items);
  }

  Widget buildListItem(ToDoItem item) {
    final Widget listTile = Dismissible(
        key: Key(item.id.toString()),
        onDismissed: (DismissDirection direction) {
          bloc.deleteToDoItem(item);
          _items.remove(item);
        },
        background: Container(color: Colors.red),
        child: ToDoItemCell(toDoItem: item));

    return listTile;
  }

  @override
  void initState() {
    super.initState();

    bloc.getTodos();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

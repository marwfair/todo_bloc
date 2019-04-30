import 'package:flutter/material.dart';
import 'package:to_do_bloc/blocs/todo_bloc.dart';
import 'package:to_do_bloc/models/todo_item.dart';

class CreateItemScreen extends StatefulWidget {
  @override
  _CreateItemScreenState createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  ToDoBloc bloc = ToDoBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create New Item'),
        ),
        resizeToAvoidBottomInset: false,
        body: Builder(builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(40),
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    TextFormField(
                      controller: titleController,
                      maxLength: 40,
                      decoration: InputDecoration(hintText: 'Title'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'You must enter a title.';
                        }
                      },
                    ),
                    RaisedButton(
                        child: Center(child: const Text('Create!')),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            final ToDoItem toDoItem = ToDoItem();
                            toDoItem.title = titleController.text;
                            toDoItem.sortOrder =
                                DateTime.now().millisecondsSinceEpoch;
                            toDoItem.completed = false;

                            bloc.saveTodoItem(toDoItem);

                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: const Text('Saved successfully!')));

                            Navigator.of(context).pop();
                          } else {
                            print('Invalid data!');
                          }
                        }),
                  ])));
        }));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

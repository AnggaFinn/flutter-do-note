import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/ui/todo_input.dart';
import 'about.dart';
import 'dart:async';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/database/dbhelper.dart';

enum PageEnum { aboutPage }

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DbHelper dbHelper = DbHelper();
  List<Todo> todoList;
  int count = 0;

  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.aboutPage:
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) => AboutPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (todoList == 0) {
      todoList = List<Todo>();
      updateListView();
    }

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: Text('Do-Note App'),
        actions: <Widget>[
          PopupMenuButton<PageEnum>(
            onSelected: _onSelect,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<PageEnum>(
                  value: PageEnum.aboutPage,
                  child: ListTile(
                    leading: Icon(Icons.feedback),
                    title: Text('About'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Image.asset('images/abstract-list-is-empty.png'),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ), 
              ),
              child: ListView.builder(
                itemCount: count,
                itemBuilder: (BuildContext context, int position) {
                  return Card(
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            getPrioritasColor(this.todoList[position].prioritas),
                        child:
                            getPrioritasIcon(this.todoList[position].prioritas),
                      ),
                      title: Text(
                        this.todoList[position].judul,
                        style: titleStyle,
                      ),
                      subtitle: Text(this.todoList[position].tanggal),
                      trailing: GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () {
                          _hapus(context, todoList[position]);
                        },
                      ),
                      onTap: () {
                        navigateTodo(this.todoList[position], 'Edit Do-Note');
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Add Button Pressed');
          navigateTodo(Todo('', '', 2), 'Tambah Do-Note');
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getTodoListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPrioritasColor(this.todoList[position].prioritas),
              child: getPrioritasIcon(this.todoList[position].prioritas),
            ),
            title: Text(
              this.todoList[position].judul,
              style: titleStyle,
            ),
            subtitle: Text(this.todoList[position].tanggal),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                _hapus(context, todoList[position]);
              },
            ),
            onTap: () {
              navigateTodo(this.todoList[position], 'Edit Do-Note');
            },
          ),
        );
      },
    );
  }

  // Fungsi Membuat warna dari prioritas todo
  Color getPrioritasColor(int prioritas) {
    switch (prioritas) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // Fungsi Membuat icon dari prioritas todo
  Icon getPrioritasIcon(int prioritas) {
    switch (prioritas) {
      case 1:
        return Icon(
          Icons.info,
          color: Colors.black,
        );
        break;
      case 2:
        return Icon(
          Icons.info_outline,
          color: Colors.black,
        );
      default:
        return Icon(
          Icons.info_outline,
          color: Colors.black,
        );
    }
  }

  // Fungsi tombol hapus pada todo
  void _hapus(BuildContext context, Todo todo) async {
    int result = await dbHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Berhasil di Hapus!');
      updateListView();
    }
  }

  // Fungsi Menampilan Pesan Pop Up
  void _showSnackBar(BuildContext context, String pesan) {
    final snackBar = SnackBar(content: Text(pesan));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // Fungsi Menampilkan judul dinamis pada appbar
  void navigateTodo(Todo todo, String judul) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InputTodo(todo, judul);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // Fungsi untuk memanggil fungsi dari getTodoList yang ada pada class dbHelper
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDb();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = dbHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}

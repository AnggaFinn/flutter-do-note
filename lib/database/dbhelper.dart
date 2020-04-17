import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/model/todo.dart';

class DbHelper {

  DbHelper._buatInstance(); //Constructor membuat instance
  static final DbHelper _dbHelper = DbHelper._buatInstance(); // Membuat singleton DbHelper untuk membuat satu instance yang akan dipanggil satu kali
  static Database _database; // Singleton database

  String tbTodo = "todo";
  String colId = "id";
  String colJudul = "judul";
  String colDeskripsi = "deskripsi";
  String colTanggal = "tanggal";
  String colPrioritas = "prioritas";

  factory DbHelper(){
    return _dbHelper;
  }

  Future<Database> get database async{
    
    if(_database == null){
      _database = await initializeDb();
    }

    return _database;
  }

  Future<Database> initializeDb() async{

    // Menempatkan direktori path untuk mengambil dari database
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todo.db";

    // membuat dan membuka database
    var dbTodo = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTodo;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute(
      'CREATE TABLE $tbTodo($colId INTEGER PRIMARY KEY, $colJudul TEXT, $colDeskripsi TEXT, $colTanggal TEXT, $colPrioritas INTEGER)'
    );
  }

  // Mengambil Data dari Todo object dari database
  Future<List<Map<String, dynamic>>>  getTodoMapList() async{
    Database db = await this.database;

    var result = await db.query(tbTodo, orderBy: '$colPrioritas ASC');
    return result;
  }

  // Memasukan data dari Todo object ke dalam database
  Future<int> insertTodo(Todo todo) async{
    Database db = await this.database;
    
    var result = await db.insert(tbTodo, todo.toMap()); 
    return result;
  }

  // Update data dari Todo object yang ada di dalam database
  Future<int> updateTodo(Todo todo) async{
    var db = await this.database;
    var result = await db.update(tbTodo, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);

    return result;
  }

  // Delete data dari Todo object yang ada di dalam database
  Future<int> deleteTodo(int id) async{
    var db = await this.database;
    var result = await db.rawDelete('DELETE FROM $tbTodo WHERE $colId = $id');

    return result;
  }

  // Mencari jumlah data yang ada di database
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT * FROM $tbTodo');
    int result = Sqflite.firstIntValue(x);

    return result;
  }

  // Mengambil data dari 'Map List' [ List<Map> ] dan lalu mengkonvertnya ke 'Todo List' [ List<Todo> ]
  Future<List<Todo>> getTodoList() async{

    var todoMapList = await getTodoMapList(); // Mengambil data 'Map List' dari database
    int count = todoMapList.length; // Menghitung berapa banyaknya data dari map yang ada di tabel database

    List<Todo> todoList = List<Todo>();

    // Looping untuk membuat 'Todo List' dari 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(Todo.fromObject(todoMapList[i]));
    }

    return todoList;
  }
}
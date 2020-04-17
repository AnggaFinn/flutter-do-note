import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/database/dbhelper.dart';

class InputTodo extends StatefulWidget {

  final String judulAppBar;
  final Todo todo;

  InputTodo(this.todo, this.judulAppBar);

  @override
  State<StatefulWidget> createState() {
    return _InputTodoState(this.todo, this.judulAppBar);
  } 
  
}

class _InputTodoState extends State<InputTodo> {

  static var _prioritas = ['High', 'Low'];

  DbHelper dbHelper = DbHelper();
  String judulAppBar;
  Todo todo;

  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  _InputTodoState(this.todo ,this.judulAppBar);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    judulController.text = todo.judul;
    deskripsiController.text = todo.deskripsi;

    return Scaffold(
      appBar: AppBar(
        title: Text(judulAppBar),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _prioritas.map((String dropDownStringItem){
                  return DropdownMenuItem<String> (
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: textStyle,
                value: getPrioritasAsString(todo.prioritas),
                onChanged: (valueSelected){
                  setState(() {
                    debugPrint('Pilih $valueSelected');
                    updatePrioritasAsInt(valueSelected);
                  });
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: TextField(
                controller: judulController,
                style: textStyle,
                onChanged: (value){
                  debugPrint('Isi Judul');
                  updateJudul();
                },
                decoration: InputDecoration(
                  labelText: 'Judul',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: TextField(
                controller: deskripsiController,
                style: textStyle,
                onChanged: (value){
                  debugPrint('Isi Deskripsi');
                  updateDeskripsi();
                },
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Simpan', 
                        textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint('Save Button Pressed');
                          _simpan();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
									    textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Hapus', 
                        textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint('Delete Button Pressed');
                          _hapus();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

  /* method untuk mengkonvert variable prioritas yg bertipe data 'String' dalam form sebelum 
    disimpan ke dalam database */
  void updatePrioritasAsInt(String value){
    switch (value) {
      case 'High':
        todo.prioritas = 1;
        break;
      case 'Low':
        todo.prioritas = 2;
        break;
      default:
    }
  }

  // Fungsi untuk mengkonvert kembali var prioritas 'int' ke 'String' yang ditampilkan di dropdown
  String getPrioritasAsString(int value){
    String prioritas;
    switch (value) {
      case 1:
        prioritas = _prioritas[0]; //High
        break;
      case 2:
        prioritas = _prioritas[1]; //Low
        break;
    }

    return prioritas; 
  }

  // Method untuk mengupdate judul todo object
  void updateJudul(){
    todo.judul = judulController.text;
  }

  // Method untuk mengupdate deskripsi todo object
  void updateDeskripsi(){
    todo.deskripsi = deskripsiController.text;
  }

  // Method untuk menyimpan data ke dalam database
  void _simpan() async {

    moveToLastScreen();

    int result;
    todo.tanggal = DateFormat.yMMMMd().format(DateTime.now());

    if (todo.id != null) {
      result = await dbHelper.updateTodo(todo);
    } else {
      result = await dbHelper.insertTodo(todo);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Simpan todo Berhasil!');
    } else {
       _showAlertDialog('Status', 'Simpan todo Tidak Berhasil!');
    }
  }

  // Method hapus yang sudah ditulis di form
  void _hapus() async{

    moveToLastScreen();

    // Jika user menghapus note yang sedang dibuat dalam form
    if (todo.id == null) {
      _showAlertDialog('Status', 'Tidak ada todo yang dihapus');
      return;
    }

    // Jika User menghapus todo yang sudah ada
    int result = await dbHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Todo berhasil dihapus!');
    } else {
      _showAlertDialog('Status', 'Todo gagal terhapus!');
    }
  }

  // Method untuk menampilkan pesan saat menyimpan data
  void _showAlertDialog(String judul, String pesan){

    AlertDialog alertDialog = AlertDialog(
      title: Text(judul),
      content: Text(pesan),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}
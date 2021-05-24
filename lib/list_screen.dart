import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
  )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _toDoList = [];

  void _addToDo(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Moradores"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,

      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 17.0, 1.0),
            child: Row(
              children:<Widget> [
                Expanded(
                    child:  ListView.builder(
                      padding: EdgeInsets.only(top: 10.0),
                        itemCount: _toDoList.length,
                        itemBuilder: (context, index){
                        return ListTile(
                          title: Text(_toDoList[index]),
                        );
                        },
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async{
    String data = json.encode(_toDoList);
    final File = await _getFile();
    return File.writeAsString(data);
  }
  Future<String> _readData() async{
    try{
      final file = await _getFile();
      return file.readAsString();
    }catch(e){
      return null;
    }
  }
}


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _apController = TextEditingController();
  final _foneController = TextEditingController();
  final _dtnascController = TextEditingController();

  List _toDoList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["nome"] = _nomeController.text;
      newToDo["cpf"] = _cpfController.text;
      newToDo["ap"] = _apController.text;
      newToDo["fone"] = _foneController.text;
      newToDo["dtnasc"] = _dtnascController.text;
      _nomeController.text = "";
      _cpfController.text = "";
      _apController.text = "";
      _foneController.text = "";
      _dtnascController.text = "";
      _toDoList.add(newToDo);

      _saveData();
    });
  }

  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Morador"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 17.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                          labelText: "Nome",
                          labelStyle: TextStyle(color: Colors.blueAccent)
                      ),
                    )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 17.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: _cpfController,
                      decoration: InputDecoration(
                          labelText: "CPF",
                          labelStyle: TextStyle(color: Colors.blueAccent)
                      ),
                    )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 17.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: _apController,
                      decoration: InputDecoration(
                          labelText: "Nº Apartamento",
                          labelStyle: TextStyle(color: Colors.blueAccent)
                      ),
                    )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 17.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: _foneController,
                      decoration: InputDecoration(
                          labelText: "Telefone",
                          labelStyle: TextStyle(color: Colors.blueAccent)
                      ),
                    )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 17.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: _dtnascController,
                      decoration: InputDecoration(
                          labelText: "Data de Nascimento",
                          labelStyle: TextStyle(color: Colors.blueAccent)
                      ),
                    )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 10.0, 17.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blueAccent,
                      child: Text("Cadastrar Morador"),
                      textColor: Colors.white,
                      onPressed: _addToDo,
                    )
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 10.0, 17.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text("Para Remover um Residente deslize o nome dele para direita"),
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(onRefresh: _refresh,
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem),),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: ListTile(
        title: Text(_toDoList[index]["nome"]),
        subtitle: Text(_toDoList[index]["ap"]),
      ),
      onDismissed: (direction){
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Residente \"${_lastRemoved["nome"]}\" removida!"),
            action: SnackBarAction(label: "Desfazer",
                onPressed: () {
                  setState(() {
                    _toDoList.insert(_lastRemovedPos, _lastRemoved);
                    _saveData();
                  });
                }),
            duration: Duration(seconds: 2),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);

        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

}


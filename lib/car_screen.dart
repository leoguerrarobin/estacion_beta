import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class Car extends StatefulWidget {
  @override
  _CarState createState() => _CarState();
}

class _CarState extends State<Car> {

  final _nomeController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _placaController = TextEditingController();
  final _anoController = TextEditingController();

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
      newToDo["marca"] = _marcaController.text;
      newToDo["modelo"] = _modeloController.text;
      newToDo["placa"] = _placaController.text;
      newToDo["ano"] = _anoController.text;
      _nomeController.text = "";
      _marcaController.text = "";
      _modeloController.text = "";
      _placaController.text = "";
      _anoController.text = "";
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
        title: Text("Cadastro de Carro"),
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
                          labelText: "Nome do Morador",
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
                      controller: _marcaController,
                      decoration: InputDecoration(
                          labelText: "Marca do carro",
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
                      controller: _modeloController,
                      decoration: InputDecoration(
                          labelText: "Modelo",
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
                      controller: _placaController,
                      decoration: InputDecoration(
                          labelText: "Placa",
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
                      controller: _anoController,
                      decoration: InputDecoration(
                          labelText: "Ano",
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
                      child: Text("Cadastrar Carro"),
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
                  child: Text("Para Remover o Carro deslize o mesmo para direita"),
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
        subtitle: Text(_toDoList[index]["placa"]),
      ),
      onDismissed: (direction){
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text(" O carro \"${_lastRemoved["placa"]}\" removido!"),
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
    return File("${directory.path}/car.json");
  }

  Future<File> _saveData() async {
    String car = json.encode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(car);
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


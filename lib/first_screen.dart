import 'package:estacio_rech/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'car_screen.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu do Estacionamento"),
      ),
      body:
          Column(
            children: <Widget> [
              Container(
                padding: EdgeInsets.fromLTRB(17.0, 200.0, 17.0, 1.0),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                  Expanded(
                    child: 	RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blueAccent,
                      elevation: 20.0,
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => User()));
                      },
                      child: Text("Cadastro de Morador"),
                    ),
                  )
                  ],
                )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(17.0, 60.0, 17.0, 25.0),
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.blueAccent,
                  elevation: 20.0,

                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Car()));
                  },
                  child: Text("Cadastro de Carro"),
                ),
              ),
            ],
          )
    );
  }
}

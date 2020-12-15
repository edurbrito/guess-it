import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guess_it_app/screens/game-page/game-page.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';


class Data {
  String _playerUsername;

  Data(this._playerUsername);

  String get playerUsername => _playerUsername;
}

class PlayerConfig extends StatefulWidget {
  @override
  _PlayerConfigState createState() => _PlayerConfigState();

}

class _PlayerConfigState extends State<PlayerConfig> {
  TextEditingController _codeController = TextEditingController();
  Data data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('PlayerPage'),
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
      body: Container(
        margin: EdgeInsets.fromLTRB(40.0, 140.0, 40.0, 300.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('images/logo.jpg'),
            ),
            Text(
              'Your Nickname',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.white
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: TextField(
                key: Key('text-field'),
                textAlign: TextAlign.center,
                controller: _codeController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your nickname here',
                  suffixIcon: Icon(Icons.edit),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        child: RaisedButton(
          key: Key('ready-button'),
          color: Colors.white,
          textColor: Colors.black54,
          padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          elevation: 5,
          colorBrightness: Brightness.dark,
          onPressed: () async {
            setState(() {
              data = new Data(_codeController.text);
            });
            final response = await http.read('http://10.0.2.2:8081/new-player/'+data._playerUsername);
            if(response.toString() == "success") {
              // obtain shared preferences
              final prefs = await SharedPreferences.getInstance();

              // set value
              prefs.setString('username', data._playerUsername);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamePage(data : data)),
              );
            }
            else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Username already used"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              _codeController.clear();
            }
          },
          child: Text(
            "I AM READY!",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomPadding: false,
    );
  }
}
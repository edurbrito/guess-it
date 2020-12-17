import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guess_it_app/screens/admin-code-page/admin-code-page.dart';
import 'package:guess_it_app/screens/definitions-page/definitions-page.dart';
import 'package:guess_it_app/screens/game-page/game-page.dart';
import 'package:guess_it_app/screens/leaderboards-page/leaderboards-page.dart';
import 'package:guess_it_app/screens/player-page/player-page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LandingPanel extends StatefulWidget {
  @override
  LandingPanelState createState() => LandingPanelState();

}

class LandingPanelState extends State<LandingPanel> {
  List<User> _leaderboards = new List<User>();
  List<String> _leaders;

  @override
  Widget build(BuildContext context) {
    String response;
    return Scaffold(
      key: Key('LandingPage'),
      body:
      Column(
        children: <Widget>[
          SizedBox(height: 170),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image(
                    image: AssetImage('images/logo.jpg'),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  child: Text(
                    'GuessIt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  child: RaisedButton(
                    key: Key('play-button'),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      // Try reading data from the counter key. If it doesn't exist, return 0.
                      final username = prefs.getString('username') ?? "";

                      try{
                        response = await http.read('http://10.0.2.2:8081/get-messages/' + "anonymous");
                      }
                      catch(e){
                        prefs.remove("username");
                        return;
                      }

                      if (response == "No sessions coming" || response == "Session has ended" || response.contains("Next session starts at")) {
                        prefs.remove("username");
                        Toast.show(response, context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                        return;
                      }

                      if (username != "") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              GamePage(data: new Data(username))),
                        );
                      }

                      else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              PlayerConfig()),
                        );
                      }
                    },
                    color: Colors.white,
                    textColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
                    elevation: 5,
                    colorBrightness: Brightness.dark,
                    child: Text(
                      'PLAY',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: MaterialButton(
                onPressed: () => {},
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width:50,
                      child:
                      RaisedButton(
                        onPressed: () async {
                          response = await http.read('http://10.0.2.2:8081/get-messages/' + "anonymous");

                          if (response == "No sessions coming" || response == "Session has ended") {
                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DefinitionsPanel()),
                            );
                          }
                          else {
                            Toast.show("Not available yet", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }
                        },
                        color: Colors.white,
                        textColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        elevation: 5,
                        colorBrightness: Brightness.dark,
                        child: Icon(
                          Icons.list_alt_sharp,
                          color: Colors.black54,
                          size: 24.0,
                          semanticLabel: 'Settings',
                        ),
                      ),
                    ),
                    Container(child:
                      FlatButton(
                        key: Key('admin-button'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminCode()),
                          );
                        },
                        child: Text(
                          'Enter as Admin',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width:50,
                      child:
                      RaisedButton(
                        key: Key('leaderboard-button'),
                        onPressed: () {
                          getLeaderBoards();
                        },
                        color: Colors.white,
                        textColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        elevation: 5,
                        colorBrightness: Brightness.dark,
                        child: Icon(
                          Icons.leaderboard,
                          color: Colors.black54,
                          size: 24.0,
                          semanticLabel: 'Leaderboards',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
    );
  }
  getLeaderBoards() async {
    final response = await http.read('http://10.0.2.2:8081/get-leaderboard');

    var tagObjsJson = jsonDecode(response) as List;

    _leaderboards = tagObjsJson.map((tagJson) => User.fromJson(tagJson)).toList();
    while(_leaderboards.length<3)
    {
      _leaderboards.add(new User("", ""));

    }
    _leaders = new List<String>();
    for (var i = 3; i < _leaderboards.length; i++) {
      _leaders.add((i+1).toString() + ". " + _leaderboards[i].toString());
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Leaderboards(this._leaderboards, this._leaders)),
    );
  }
}

class User{
  String name;
  String points;

  User(this.name, this.points);

  factory User.fromJson(dynamic json) {
    return User(json['nickname'] as String, (json['points'] as int).toString());
  }

  @override
  String toString() {
    return '${this.name} - ${this.points}';
  }
}
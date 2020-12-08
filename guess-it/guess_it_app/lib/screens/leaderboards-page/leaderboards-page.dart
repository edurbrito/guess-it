import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class Leaderboards extends StatefulWidget {
  @override
  _LeaderboardsState createState() => _LeaderboardsState();

}

class User{
  final String name;
  final int points;
  User(this.name, this.points);
  factory User.fromJson(dynamic json) {
    return User(json['nickname'] as String, json['points'] as int);
  }
  @override
  String toString() {
    return '${this.name} - ${this.points}';
  }
}

class _LeaderboardsState extends State<Leaderboards> {
  List<List<TextSpan>> litems = [];

  TextEditingController _codeController = TextEditingController();
  String _codeText;
  List<User> _leaderboards = new List<User>();
  List<String> _leaders;

  _get_leaderboards() async {

    final response = await http.read('http://10.0.2.2:8081/get-leaderboard');
    var tagObjsJson = jsonDecode(response) as List;
    _leaderboards = tagObjsJson.map((tagJson) => User.fromJson(tagJson)).toList();
    while(_leaderboards.length<4)
    {
      _leaderboards.add(new User("anonimous", 0));

    }
    _leaders = new List<String>();
    for (var i = 3; i < _leaderboards.length; i++) {
      _leaders.add((i+1).toString() + ". " + _leaderboards[i].toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _get_leaderboards();
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
      body: Container(
        margin: EdgeInsets.fromLTRB(40.0, 80.0, 40.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                  Text(
                    'Leaderboards',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.white,
                      shadows: [
                      Shadow(
                      blurRadius: 5.0,
                      color: Colors.blue,
                      offset: Offset(0, 0),
                    ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.star_outline,
                    color: Colors.black54,
                    size: 24.0,
                    semanticLabel: 'Leaderboards',
                  ),
                ],
              ),
            SizedBox(height: 60),
            Container(
              height: 150.0,
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.white,
                image: const DecorationImage(
                  image: AssetImage('images/podium.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomRight,
                    child:
                    Column(
                      children: <Widget> [
                        SizedBox(height: 100),
                        Text(
                          _leaderboards[1].name,
                          textAlign: TextAlign.left,
                          style:
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.white,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _leaderboards[1].points.toString(),
                          textAlign: TextAlign.left,
                          style:
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.white,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child:
                    Column(
                      children: <Widget> [
                        SizedBox(height: 80),
                        Text(
                          _leaderboards[0].name,
                          textAlign: TextAlign.left,
                          style:
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.yellow,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _leaderboards[0].points.toString(),
                          textAlign: TextAlign.left,
                          style:
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.yellow,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child:
                        Column(
                          children: <Widget> [
                            SizedBox(height: 110),
                            Text(
                            _leaderboards[2].name,
                            textAlign: TextAlign.left,
                            style:
                            TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.brown,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.white,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              ),
                            ),
                            Text(
                              _leaderboards[2].points.toString(),
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.brown,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.white,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
            Container(
              height: 300.0,
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child:
              ListWheelScrollView(
                itemExtent: 60,
                diameterRatio: 10,
                children: _leaders.map((item) =>
                new Text(item,textAlign: TextAlign.start,style:
                TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
                )
                ).toList()
            ),
            ),
          ],
        ),
      ),
    );
  }
}
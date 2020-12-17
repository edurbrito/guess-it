import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guess_it_app/screens/landing-page/landing-page.dart';

class Leaderboards extends StatefulWidget {
  List<User> leaderboards = new List<User>();
  List<String> leaders = new List<String>();
  _LeaderboardsState leaderboardsState;

  Leaderboards(this.leaderboards, this.leaders);

  @override
  _LeaderboardsState createState() {
    this.leaderboardsState = _LeaderboardsState();
    this.leaderboardsState.setLeaderboads(this.leaderboards);
    this.leaderboardsState.setLeaders(this.leaders);
    return this.leaderboardsState;
  }
}

class _LeaderboardsState extends State<Leaderboards> {
  List<User> _leaderboards = new List<User>();
  List<String> _leaders;

  setLeaderboads(List<User> leaderboards) {
    this._leaderboards = leaderboards;
  }

  setLeaders(List<String> leaders) {
    this._leaders = leaders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('LeaderboardPage'),
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 75),
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
            SizedBox(height: 40),
            Container(
              height: 150.0,
              width: 360.0,
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
              width: 360.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black87,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child:
              ListWheelScrollView(
                itemExtent: 60,
                diameterRatio: 10,
                children: _leaders.map((item) =>
                  new Text(
                    item,
                    textAlign: TextAlign.start,
                    style: TextStyle(
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
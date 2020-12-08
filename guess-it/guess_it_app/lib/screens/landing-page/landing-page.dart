import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guess_it_app/screens/admin-code-page/admin-code-page.dart';
import 'package:guess_it_app/screens/leaderboards-page/leaderboards-page.dart';
import 'package:guess_it_app/screens/player-page/player-page.dart';

class LandingPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayerConfig()),
                      ),
                    },
                    color: Colors.white,
                    textColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
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
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Leaderboards()),
                          ),
                        },
                        color: Colors.white,
                        textColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
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
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Leaderboards()),
                          ),
                        },
                        color: Colors.white,
                        textColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
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
}
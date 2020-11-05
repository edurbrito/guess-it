import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guess_it_app/screens/admin-panel-page/admin-panel-page.dart';

class AdminCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
      body: OverallMenu(),
      floatingActionButton: Container(
        child: RaisedButton(
          color: Colors.white,
          textColor: Colors.black54,
          padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          elevation: 5,
          colorBrightness: Brightness.dark,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPanel()),
            );
          },
          child: Text(
            "LOG IN",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomPadding: false,
    );
  }
}

class OverallMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var _code;
    return Container(
      margin: EdgeInsets.fromLTRB(40.0, 140.0, 40.0, 300.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/logo.jpg'),
          ),
          Text(
            'Your Admin Code',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.white
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
            ),
            child: TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              controller: _code,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type your code here',
                suffixIcon: Icon(Icons.edit),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


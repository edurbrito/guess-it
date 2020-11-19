import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController eCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(134, 232, 214, 1.0),
      //padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 200.0,
            width: 350.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  Text(
                    'username',
                    style: TextStyle(
                      color: Color.fromRGBO(48, 159, 156, 1.0),
                      decoration: TextDecoration.none,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Some definitions here',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'Tips here',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                      fontSize: 25,
                    ),
                  ),
               ],
            ),
          ),
          Container(
            height: 300.0,
            width: 350.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'Guesses',
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50.0,
            width: 350.0,
            child: Scaffold(
              backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
              body: TextField(
                controller: eCtrl,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    hintText: 'Type your guess...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

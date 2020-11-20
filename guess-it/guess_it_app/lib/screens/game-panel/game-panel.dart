import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class GamePanel extends StatefulWidget {
  @override
  _GamePanelState createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> {
  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();
  String secretWord = "#r#mp L#st";         // Secret word. Change this to change the word!
  String userName = "Player's Username";    // The player's username.

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(134, 232, 214, 1.0),
      child: Column(
        children: [
          SizedBox(height: 75),
          Container(
            color: Colors.white,
            width: 350.0,
            height: 170.0,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Center(
                        child: Text(
                          userName,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Center(
                        child: Column(
                          children: _getTips(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 30, color: Colors.black,),
                            children: _getHiddenString(),
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 60),
          Container(
              color: Colors.white,
              height: 250.0,
              width: 350.0,
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    children: <Widget>[
                      new Expanded(
                          child: new ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: litems.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = litems[index];
                              return RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(text: userName + ": ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                    TextSpan(text: litems[index]),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                          )
                      ),
                      Divider(height: 10, thickness: 5, color: Color.fromRGBO(134, 232, 214, 1.0)),
                      TextField(
                        controller: eCtrl,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Type your guess ...",
                        ),
                        onSubmitted: (text) {
                          if(text.isNotEmpty)
                            litems.add(text);
                          eCtrl.clear();
                          setState(() {});
                        },
                      ),
                    ],
                  )
              )
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  _getTips(){
      List<String> someList = ["Define the word here!", "You can say more stuff too!"];
      return new List<Widget>.generate(someList.length, (int index) {
        return Text(
            someList[index].toString(),
            style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(100, 100, 100, 1.0),
                fontWeight: FontWeight.bold,
            )
        );
      });
  }

  /* The following function returns an array of TextSpans based on the format of the word inside the "secretWord" variable.
     '#' characters in the secret word are transformed into '__'. Any other case is left unchanged.
  */
  _getHiddenString(){
    List<TextSpan> temp = new List<TextSpan>();
    for(int i = 0; i < secretWord.length; i++){
      if(secretWord[i] == '#')
          temp.add(new TextSpan(text: "  ", style: TextStyle(decoration: TextDecoration.underline),));
      else
          temp.add(new TextSpan(text: secretWord[i]));
      if(i + 1 != secretWord.length)
          temp.add(new TextSpan(text: " "));
    }
    return temp;
  }

  _setMessageString(int index){
      String stringInQuestion = litems[index];
      List<TextSpan> temp = new List<TextSpan>();

  }

}

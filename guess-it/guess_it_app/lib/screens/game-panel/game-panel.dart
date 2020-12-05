import 'dart:async';
import 'dart:developer';

import '../../utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class GamePanel extends StatefulWidget {
  @override
  _GamePanelState createState() => _GamePanelState();
}

class _GamePanelState extends State<GamePanel> {
  List<String> litems = [];                 // User input
  final TextEditingController eCtrl = new TextEditingController();
  String realWord = "Trump Lost";           // The real word that will be used to check if the answer's close.
  String secretWord = "#r#mp L#st";         // Secret word. Change this to change the word!
  String userName = "Player's Username";    // The player's username.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
        body: Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: SingleChildScrollView(
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 75),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black87,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      width: 360.0,
                      height: 190.0,
                      child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    SizedBox(height: 35),
                    Center(child:
                      Text("GUESS THE WORD",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                        child: Column(
                              children: <Widget>[
                                Container(
                                  height: 250.0,
                                  width: 360.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black87,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: new ListView.separated(
                                        padding: const EdgeInsets.all(12),
                                        itemCount: litems.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return RichText(
                                            text: TextSpan(
                                              style: TextStyle(fontSize: 18, color: Colors.black),
                                              children: _setMessageString(index),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                                      )
                                    ),
                                Divider(height: 10, thickness: 5, color: Color.fromRGBO(134, 232, 214, 1.0)),
                                Container(
                                  width: 360.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black87,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  child: TextField(
                                    controller: eCtrl,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: "Type your guess ...",
                                    ),
                                    onSubmitted: (text) {
                                      if(text.isNotEmpty)
                                        _checkAndAdd(text);
                                      eCtrl.clear();
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            )
                        ),
                    SizedBox(height: 30),
                  ],
                ),
            ),
        ),
      ),
    );
  }

  _getTips(){
      List<String> someList = ["Define the word here!", "You can say more stuff too!", "Just ... one more! Promiiise!"];
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

  _checkAndAdd(String text){
    litems.add(text);
    Utils utils = new Utils();
    int result = utils.getLevenshteinDistance(text, realWord);

    if(result == 0)
      litems.add("YOU GOT IT!!");
    else if(result > 0 && result <= 2)
      litems.add("YOU ARE CLOSE!!");
    else
      litems.add("Wrong ...");
  }

  /* Formats the string based on its contents. */
  _setMessageString(int index){
      bool isUserMessage = index % 2 == 0;
      String stringInQuestion = litems[index];
      String authorMessage = (isUserMessage) ? userName + ": " : "Admin: ";
      List<TextSpan> temp = new List<TextSpan>();

      temp.add(new TextSpan(text: authorMessage, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)));
      if(!isUserMessage){
          switch(stringInQuestion){
            case "YOU GOT IT!!":
              temp.add(new TextSpan(text: litems[index], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)));
              break;
            case "YOU ARE CLOSE!!":
              temp.add(new TextSpan(text: litems[index], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)));
              break;
            case "Wrong ...":
              temp.add(new TextSpan(text: litems[index], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)));
              break;
          }
      }
      else{
        temp.add(TextSpan(text: litems[index]));
      }

      return temp;
  }

}

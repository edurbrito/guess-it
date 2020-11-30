import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guess_it_app/screens/player-page/player-page.dart';
import 'package:http/http.dart' as http;

class GamePage extends StatefulWidget {
  final Data data;
  _GamePageState GameState;

  GamePage({Key key, @required this.data}) : super(key: key);

  @override
  _GamePageState createState() {
    this.GameState = _GamePageState();
    this.GameState.setUsername(this.data.playerUsername);
    return this.GameState;
  }
}

class _GamePageState extends State<GamePage> {
  List<List<TextSpan>> litems = [];

  final TextEditingController eCtrl = new TextEditingController();
  String secretWord = ""; // Secret word.
  String userName; // The player's username.
  String introducedWord;
  String definition = "";
  String leaderName = "";
  bool leader = false;

  setUsername(String userName) {
    this.userName = "pedro";
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 3), (timer) async {
      final response = await http.read('http://10.0.2.2:8081/get-messages/' + this.userName);

      if (response == "No sessions comming" || response == "Session has ended" || response.contains("Next session starts at")) {
        // MUDAR PARA PAGE NOVA
        print('ACABOU');
        timer.cancel();
      }

      Map<String, dynamic> decodedMessage = jsonDecode(response);
      print('Decoded MEsssage $decodedMessage');

      litems.clear();

      leaderName = decodedMessage["leaderName"];
      definition = decodedMessage["definition"];

      if (decodedMessage["leader"]) {
        leader = true;
        secretWord = decodedMessage["word"];

      }
      else {
        leader = false;
      }

      for (int i = 0; i < decodedMessage["messages"].length; i++) {
        if (decodedMessage["messages"][i] != "") {
          List<TextSpan> listSpans = [];
          listSpans.add(TextSpan(
            text: decodedMessage["messages"][i]["nickname"],
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ));
          listSpans.add(
            TextSpan(text: decodedMessage["messages"][i]["msg"])
          );
          litems.add(listSpans);
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
      //padding: EdgeInsets.all(10),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ListTile(
                  title: Center(
                    child: Text(
                      this.leaderName,
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
                    child: _getTips()
                  ),
                ),
                ListTile(
                  title: Center(
                      child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      children: _getHiddenString(this.leader),
                    ),
                  )),
                ),
              ],
            ),
          ),
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
                          return RichText(
                            text: TextSpan(
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            children:
                              litems[index],
                        ),
                      );
                    },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                  )),
                ],
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: 350.0,
            child: Scaffold(
              backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
              resizeToAvoidBottomInset: false,
              body: TextField(
                controller: eCtrl,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Type your guess...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onSubmitted: (text) async {
                  setState(() {
                    introducedWord = eCtrl.text;
                  });
                  String add = '{"nickname": "' + this.userName + '", "message": "' + introducedWord + '"}';
                  await http.read('http://10.0.2.2:8081/new-message/' + add);

                  eCtrl.clear();

                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getTips() {
      return Text(
          this.definition,
          style: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(100, 100, 100, 1.0),
            fontWeight: FontWeight.bold,
          )
      );
  }

  /* The following function returns an array of TextSpans based on the format of the word inside the "secretWord" variable.
     '#' characters in the secret word are transformed into '__'. Any other case is left unchanged.
  */
  _getHiddenString(leader) {
    List<TextSpan> temp = new List<TextSpan>();

    if (leader) {
      for (int i = 0; i < secretWord.length; i++) {
          temp.add(new TextSpan(text: secretWord[i]));
      }
    }
    else {

    }
    return temp;
  }

  _setMessageString(int index) {
    //String stringInQuestion = litems[index];
    List<TextSpan> temp = new List<TextSpan>();
  }
}

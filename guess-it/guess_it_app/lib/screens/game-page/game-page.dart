import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guess_it_app/screens/landing-page/landing-page.dart';
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
  String secretWord = ""; // Secret word
  String userName = ""; // The player's username
  String introducedWord = "";
  String definition = "";
  String leaderName = "";
  bool leader = false;
  bool guessed = false;

  setUsername(String userName) {
    this.userName = userName;
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 2), (timer) async {
      final response =
          await http.read('http://10.0.2.2:8081/get-messages/' + this.userName);

      if (response == "No sessions coming" ||
          response == "Session has ended" ||
          response.contains("Next session starts at")) {
        timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LandingPanel()),
        );
      }

      Map<String, dynamic> decodedMessage = jsonDecode(response);

      litems.clear();

      if (leaderName != decodedMessage["leaderName"]) {
        guessed = false;
      }

      leaderName = decodedMessage["leaderName"];
      definition = decodedMessage["definition"];
      secretWord = decodedMessage["word"];
      leader = decodedMessage["leader"];

      for (int i = 0; i < decodedMessage["messages"].length; i++) {
        if (decodedMessage["messages"][i] != "") {
          List<TextSpan> listSpans = [];
          listSpans.add(TextSpan(
            text: decodedMessage["messages"][i]["nickname"],
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ));
          switch(decodedMessage["messages"][i]["msg"]){
            case "YOU GOT IT!!":
              listSpans.add(new TextSpan(text: decodedMessage["messages"][i]["msg"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)));
              break;
            case "YOU ARE CLOSE!!":
              listSpans.add(new TextSpan(text: decodedMessage["messages"][i]["msg"], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)));
              break;
            default:
              listSpans.add(new TextSpan(text: decodedMessage["messages"][i]["msg"], style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black)));
              break;
          }
          litems.add(listSpans);
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('GamePage'),
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
                          title: Center(child: _getTips()),
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
                          height: 300.0,
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
                                  children: litems[index],
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
                            onSubmitted: (text) async {
                              if (!guessed) {
                                if(eCtrl.text != "") {
                                  setState(() {
                                    introducedWord = eCtrl.text;
                                  });
                                }

                                String add = '{"nickname": "' + this.userName + '", "message": "' + introducedWord + '"}';
                                final response = await http.read('http://10.0.2.2:8081/new-message/' + add);

                                if (response == "YOU GOT IT!!")
                                  guessed = true;

                                eCtrl.clear();

                                setState(() {});
                              }
                            },
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 30),
                Container(
                  child: Text(
                    this.userName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
  _getHiddenString() {
    List<TextSpan> temp = new List<TextSpan>();

    for (int i = 0; i < secretWord.length; i++) {
      temp.add(
        new TextSpan(
            text: secretWord[i],
            style: TextStyle(letterSpacing: 2)
        )
      );
    }

    return temp;
  }
}

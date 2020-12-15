import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;

class Definitions {
  String word;
  String definition;

  Definitions(this.word, this.definition);

  factory Definitions.fromJson(dynamic json) {
    return Definitions(json['word'] as String, json['definition'] as String);
  }

  @override
  String toString() {
    return '{${this.word}, ${this.definition}}';
  }
}


class DefinitionsPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DefinitionsPanelState();
}

class _DefinitionsPanelState extends State<DefinitionsPanel> {
  List<Definitions> lDefs = [];
  List<List<TextSpan>> litems = [];

  @override
  void initState() {
    super.initState();
    getDefinitions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
      body: Container(
        margin: EdgeInsets.fromLTRB(40.0, 120.0, 40.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text(
                  'Words and Definitons Table',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
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
              ],
            ),
            SizedBox(height: 40),
            Container(
              height: 350.0,
              width: 360.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black87,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: new ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: litems.length,
                itemBuilder: (BuildContext context, int index) {
                  return RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: litems[index],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              )
            ),
          ],
        ),
      )
    );
  }
  getDefinitions() async {
    final response =
      await http.read('http://10.0.2.2:8081/get-definitions');

    var decodedMessage = jsonDecode(response) as List;
    lDefs = decodedMessage.map((defJson) => Definitions.fromJson(defJson)).toList();

    for(int i = 0; i < lDefs.length; i++) {
      List<TextSpan> listSpans = [];
      listSpans.add(TextSpan(
        text: lDefs[i].word,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ));
      listSpans.add(TextSpan(text: ' - '));
      listSpans.add(TextSpan(text: lDefs[i].definition));
      litems.add(listSpans);
    }
    setState(() {});
  }
}



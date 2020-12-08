import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if(litems == null) {
      getDefinitions();
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 250.0,
            width: 350.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                children: <Widget>[
                  new Expanded(
                      child: new ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: lDefs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 18, color: Colors.black),
                              children: litems[index],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  getDefinitions() async {
    final response =
      await http.read('http://10.0.2.2:8081/get-definitions');

    var decodedMessage = jsonDecode(response) as List;
    lDefs = decodedMessage.map((defJson) => Definitions.fromJson(defJson)).toList();
    print('Decoded MEsssage $lDefs');

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
    print('LITENS: $litems');
  }
}



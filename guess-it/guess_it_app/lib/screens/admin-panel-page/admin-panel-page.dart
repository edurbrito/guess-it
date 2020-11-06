import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guess_it_app/screens/landing-page/landing-page.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  DateTime pickedDate;
  TimeOfDay pickedTime;
  var _duration;
  List<String> litems = [];
  final TextEditingController eCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(134, 232, 214, 1.0),
      child: Column(
        children: [
          SizedBox(height: 50),
          Container(
            alignment: Alignment(-0.8, -0.8),
            child: Text(
              'Schedule:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: Colors.white,
            width: 350.0,
            height: 190.0,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                          "Date: ${pickedDate.day} / ${pickedDate.month} / ${pickedDate.year}"),
                      leading: Icon(Icons.date_range),
                      trailing: Icon(Icons.arrow_drop_down),
                      onTap: _pickDate,
                    ),
                    ListTile(
                      title: Text(
                          "Time: ${pickedTime.hour} : ${pickedTime.minute}"),
                      leading: Icon(Icons.watch_later),
                      trailing: Icon(Icons.arrow_drop_down),
                      onTap: _pickTime,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(18.0, 0.0, 10.0, 30.0),
                        child: TextField(
                          controller: _duration,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Duration (in minutes)",
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Container(
            alignment: Alignment(-0.75, 0),
            child: Text(
              'List of Words:',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
              color: Colors.white,
              height: 250.0,
              width: 350.0,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Column(
                  children: <Widget>[
                    TextField(
                      controller: eCtrl,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Add a word",
                      ),
                      onSubmitted: (text) {
                        litems.add(text);
                        eCtrl.clear();
                        setState(() {});
                      },
                    ),
                    new Expanded(
                      child: new ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: litems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = litems[index];
                          return Dismissible(
                            key: Key(item),
                            onDismissed: (direction) {
                              setState(() {
                                litems.removeAt(index);
                              });
                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(content: Text("$item deleted")));
                            },
                            background: Container(color: Colors.red),
                            child: Center(child: Text(litems[index])),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => const Divider(),
                      )
                    )
                  ],
                )
              )
          ),
          SizedBox(height: 30),
          RaisedButton(
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
                MaterialPageRoute(builder: (context) => LandingPanel()),
              );
            },
            child: Text(
              "SAVE",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: pickedDate,
    );

    if (date != null) {
      setState(() {
        pickedDate = date;
      });
    }
  }

  _pickTime() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );

    if (time != null) {
      setState(() {
        pickedTime = time;
      });
    }
  }
}

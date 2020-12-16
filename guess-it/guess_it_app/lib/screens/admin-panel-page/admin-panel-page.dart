import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guess_it_app/screens/landing-page/landing-page.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  DateTime pickedDate;
  TimeOfDay pickedTime;
  TextEditingController _durationController = TextEditingController();
  List<String> litems = [];
  List<String> lwords = [];
  final TextEditingController eCtrl = new TextEditingController();
  String hours;
  String minutes;
  String month;
  String day;

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();

    if(pickedTime.hour < 10) {
      hours = '0'+ "${pickedTime.hour}";
    }
    else {
      hours = "${pickedTime.hour}";
    }

    if(pickedTime.minute < 10) {
      minutes = '0'+ "${pickedTime.minute}";
    }
    else {
      minutes = "${pickedTime.minute}";
    }

    if(pickedDate.month < 10) {
      month = '0'+ "${pickedDate.month}";
    }
    else {
      month = "${pickedDate.month}";
    }

    if(pickedDate.day < 10) {
      day = '0'+ "${pickedDate.day}";
    }
    else {
      day = "${pickedDate.day}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Key('AdminPanel'),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
        body: Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 75),
                  Container(
                    child: Text(
                      'Schedule',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
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
                            title: Text(
                              "Date: $day / $month / ${pickedDate.year}"),
                            leading: Icon(Icons.date_range),
                            trailing: Icon(Icons.arrow_drop_down),
                            onTap: _pickDate,
                          ),
                          ListTile(
                            title: Text(
                              "Time: $hours:$minutes"),
                            leading: Icon(Icons.watch_later),
                            trailing: Icon(Icons.arrow_drop_down),
                            onTap: _pickTime,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(18.0, 0.0, 10.0, 30.0),
                            child: TextField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Duration (in minutes)",
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  Container(
                    child: Text(
                      'List of Words',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
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
                            padding: const EdgeInsets.all(8),
                            itemCount: lwords.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = lwords[index];
                              return Dismissible(
                                key: Key(item),
                                onDismissed: (direction) {
                                  setState(() {
                                    litems.removeAt(index);
                                    lwords.removeAt(index);
                                  });
                                  Toast.show("$item deleted", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                },
                                background: Container(color: Colors.red),
                                child: Center(
                                    child: Text(
                                      lwords[index],
                                      style: TextStyle(fontSize: 18, color: Colors.black, decoration: TextDecoration.none),
                                    )
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                          ),
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
                            key: Key('wordInput'),
                            controller: eCtrl,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "Type a word ...",
                            ),
                            onSubmitted: (text) async {
                              if(text != "") {
                                String word = '"' + text + '"';
                                litems.add(word);
                                lwords.add(text);
                                eCtrl.clear();
                                setState(() {});
                              }
                            }
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                    color: Colors.white,
                    textColor: Colors.black54,
                    padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                    elevation: 5,
                    colorBrightness: Brightness.dark,
                    onPressed: () async {
                      String extension = '{"dateHour": "' + pickedDate.year.toString() +
                          '-' + month + '-' + day + ' ' + hours + ':' + minutes +
                          '", "duration": ' + _durationController.text + ', "words": ' + litems.toString() +'}';
                      final response = await http.read('http://10.0.2.2:8081/new-game-session/'+ extension);
                      if(response.toString() == "success") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LandingPanel()),
                        );
                      }
                      else {
                        Toast.show("Wrong parameters", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      )
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

    if(pickedDate.month < 10) {
      month = '0'+ "${pickedDate.month}";
    }
    else {
      month = "${pickedDate.month}";
    }

    if(pickedDate.day < 10) {
      day = '0'+ "${pickedDate.day}";
    }
    else {
      day = "${pickedDate.day}";
    }
  }

  _pickTime() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: pickedTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (time != null) {
      setState(() {
        pickedTime = time;
      });
    }

    if(pickedTime.hour < 10) {
      hours = '0'+ "${pickedTime.hour}";
    }
    else {
      hours = "${pickedTime.hour}";
    }

    if(pickedTime.minute < 10) {
      minutes = '0'+ "${pickedTime.minute}";
    }
    else {
      minutes = "${pickedTime.minute}";
    }
  }
}

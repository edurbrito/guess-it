import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:guess_it_app/screens/admin-panel-page/admin-panel-page.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';


class AdminCode extends StatefulWidget {
  @override
  _AdminCodeState createState() => _AdminCodeState();

}

class _AdminCodeState extends State<AdminCode> {
  TextEditingController _codeController = TextEditingController();
  String _codeText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('AdminCode'),
      backgroundColor: Color.fromRGBO(134, 232, 214, 1.0),
      body: Container(
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
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: TextField(
                key: Key('text-field'),
                obscureText: true,
                textAlign: TextAlign.center,
                controller: _codeController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your code here',
                  suffixIcon: Icon(Icons.edit),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        child: RaisedButton(
          key: Key('login-button'),
          color: Colors.white,
          textColor: Colors.black54,
          padding: EdgeInsets.fromLTRB(80, 0, 80, 0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          elevation: 5,
          colorBrightness: Brightness.dark,
          onPressed: () async {
            setState(() {
              _codeText = _codeController.text;
            });
            final response = await http.read('http://10.0.2.2:8081/admin-code/'+_codeText);
            if(response.toString() == "success") {
              _codeController.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanel()),
              );
            }
            else {
              Toast.show("Wrong Password", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              _codeController.clear();
            }
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



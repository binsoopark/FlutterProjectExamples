import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello World Travel Title",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Hello World Travel App"),
            backgroundColor: Colors.deepPurple,),
            body: Builder(
    builder: (context) => SingleChildScrollView(
    child: Padding(

    padding: EdgeInsets.all(20),
            child: Center(
            child: Column(children: [
            Padding(
            padding: EdgeInsets.all(10),
                child: Text(
                  'Hello World Travel',
                  style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800]),
    )),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Discover the World',

                      style: TextStyle(fontSize: 20, color:
    Colors.deepPurpleAccent),
    )),
    Padding(
    padding: EdgeInsets.all(15),
    child: Image.network('https://images.freeimages.com/images/large-previews/eaa/the-beach-1464354.jpg',
    height: 350,
    )),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: RaisedButton(

                    child: Text('Contact Us'),
      onPressed: () => contactUs(context),
    )),
    ])))))));
  }

  void contactUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Us'),
          content: Text('Mail us at hello@world.com'),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}

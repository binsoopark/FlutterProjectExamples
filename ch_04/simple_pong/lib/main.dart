import 'package:flutter/material.dart';
import './pong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pong Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Simple Pong'),
            ),
            body: SafeArea(
                child: Pong()
            )

        ));
  }
}

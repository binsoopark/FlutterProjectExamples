import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/event_screen.dart';
import 'screens/launch_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // testData();

    return MaterialApp(
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LaunchScreen(),
    );
  }

  Future testData() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection('event_details').get();
    var details = data.docs.toList();

    details.forEach((d) {
      print(d.id);
    });

  }
}

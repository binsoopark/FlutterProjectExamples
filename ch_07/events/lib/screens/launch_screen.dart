import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'event_screen.dart';
import '../shared/authentication.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    Authentication auth = Authentication();
    auth.getUser().then((user) {
      MaterialPageRoute route;
      if (user != null) {
        route = MaterialPageRoute(builder: (context) => EventScreen(user.uid));
      }
      else {
        route = MaterialPageRoute(builder: (context) => LoginScreen());
      }
      Navigator.pushReplacement(context, route);
    }).catchError((err)=> print(err));
  }

}

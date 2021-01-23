import 'dart:developer';

import 'dice.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'knockout.dart';

class Single extends StatefulWidget {
  @override
  _SingleState createState() => _SingleState();
}

class _SingleState extends State<Single> {
  RiveAnimationController currentAnimation;
  Artboard _artboard;

  @override
  void initState() {
    currentAnimation = SimpleAnimation('Start');

    _loadRiveFile();
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/dice.riv');
    final file = RiveFile();
    if (file.import(bytes)) {
      setState(() => _artboard = file.mainArtboard
        ..addController(
          currentAnimation,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(appBar: AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.fitness_center),
          onPressed: () {
            MaterialPageRoute route =
              MaterialPageRoute(builder:(context)=> KnockOutScreen());
            Navigator.push(context, route);
          },
        )
      ],
    ),
    body: Center(
          child: Column(
            children: <Widget>[
              Container(
                  height: height / 1.7,
                  width: width * 0.8,
                  child: Rive(
                    fit: BoxFit.contain,
                    artboard: _artboard,
                  )),
              SizedBox(
                  width: width/2.5,
                  height: height / 10,
                  child:RaisedButton(
                    child: Text('Play'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)
                    ),
                    onPressed: () {
                      setState(() {
                        _artboard.removeController(currentAnimation);
                        currentAnimation = SimpleAnimation('Roll');
                        _artboard.addController(currentAnimation);
                      });
                      Dice.wait3seconds().then((_){
                        _artboard.removeController(currentAnimation);
                        callResult();
                        _artboard.addController(currentAnimation);
                      });},))],)),);}

  void callResult() async {
    Map<int, SimpleAnimation> animation = Dice.getRandomAnimation();
    setState(() {
      currentAnimation = animation.values.first;
      log("current: ${(currentAnimation as SimpleAnimation).animationName}");
    });
  }

}

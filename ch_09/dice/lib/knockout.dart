import 'dart:developer';

import 'single.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'dice.dart';
import 'package:flutter/services.dart' show rootBundle;

class KnockOutScreen extends StatefulWidget {
  @override
  _KnockOutScreenState createState() => _KnockOutScreenState();
}

class _KnockOutScreenState extends State<KnockOutScreen> {
  int _playerScore = 0;
  int _aiScore = 0;
  RiveAnimationController _animation1;
  RiveAnimationController _animation2;
  Artboard _artboard1;
  Artboard _artboard2;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _animation1=SimpleAnimation('Start');
    _animation2=SimpleAnimation('Start');
    _loadRiveFile();
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/dice.riv');
    final file = RiveFile();
    final file2 = RiveFile();
    if (file.import(bytes)) {
      setState(() => _artboard1 = file.mainArtboard
        ..addController(
          _animation1,
        ));
    }
    if (file2.import(bytes)) {
      setState(() => _artboard2 = file2.mainArtboard
        ..addController(
          _animation2,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.repeat_one),
              onPressed: () {
                MaterialPageRoute route =
                  MaterialPageRoute(builder: (context)=> Single());
                Navigator.push(context, route);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(24),
                child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              height: height / 3,
                              width: width / 2.5,
                              child: Rive(
                                artboard: _artboard1,
                                fit: BoxFit.contain,
                              )),
                          Container(
                              height: height / 3,
                              width: width / 2.5,
                              child: Rive(
                                artboard: _artboard2,
                                fit: BoxFit.contain,
                              )),
                        ],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GameText('Player: ', Colors.deepOrange, false),
                            GameText(_playerScore.toString(), Colors.white, true),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(height / 24),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GameText('AI: ', Colors.lightBlue, false),
                            GameText(_aiScore.toString(), Colors.white, true),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(height / 12),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                                width: width / 3,
                                height: height / 10,
                                child:RaisedButton(
                                  child: Text('Play'),
                                  color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)
                                  ),
                                  onPressed: () {
                                    play(context);
                                  },
                                )
                            ),
                            SizedBox(
                                width: width / 3,
                                height: height / 10,
                                child:RaisedButton(
                                  color: Colors.grey,
                                  child: Text('Restart'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)
                                  ),
                                  onPressed: () {
                                    reset();
                                  },
                                )
                            ),
                          ],
                        ),

                ]
                )
            )
        )
    );
  }

  void reset() {
    setState(() {
      _artboard1.removeController(_animation1);
      _artboard2.removeController(_animation2);
      _animation1 = SimpleAnimation('Start');
      _animation2 = SimpleAnimation('Start');
      _artboard1.addController(_animation1);
      _artboard2.addController(_animation2);
      _aiScore = 0;
      _playerScore = 0;
    });
  }

  Future play(BuildContext context) async {
    String message = '';

    setState(() {
      _artboard1.removeController(_animation1);
      _artboard2.removeController(_animation2);
      _animation1 = SimpleAnimation('Roll');
      _animation2 = SimpleAnimation('Roll');
      _artboard1.addController(_animation1);
      _artboard2.addController(_animation2);
    });

    Dice.wait3seconds().then((_) {
      Map<int, SimpleAnimation> animation1 = Dice.getRandomAnimation();
      Map<int, SimpleAnimation> animation2 = Dice.getRandomAnimation();
      log("animation 1: ${animation1.keys.first}");
      log("animation 2: ${animation2.keys.first}");

      int result = animation1.keys.first +1 + animation2.keys.first+1;

      int aiResult = Dice.getRandomNumber() + Dice.getRandomNumber();

      if (result == 7) result = 0;
      if (aiResult == 7) aiResult = 0;

      setState(() {
        _playerScore += result;
        _aiScore += aiResult;
        _artboard1.removeController(_animation1);
        _artboard2.removeController(_animation2);
        _animation1 = animation1.values.first;
        _animation2 = animation2.values.first;
        log("animation 1 name: ${animation1.values.first.animationName}");
        log("animation 2 name: ${animation2.values.first.animationName}");
        _artboard1.addController(_animation1);
        _artboard2.addController(_animation2);
      });

    });

    if (_playerScore >= 50 || _aiScore >= 50) {
      if (_playerScore > _aiScore) {message = 'You win!';}
      else if (_playerScore == _aiScore) {message = 'Draw!'; }
      else {message = 'You lose!';}
      showMessage(message);
    }

  }

  void showMessage (String message) {
    SnackBar snackBar = SnackBar(content: Text(message),);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


}

class GameText extends StatelessWidget {
  final String text;
  final Color color;
  final bool isBordered;

  GameText(this.text, this.color, this.isBordered);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isBordered ? Border.all() : null,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(text,
        style: TextStyle(
            fontSize: 24,
            color: color
        ),),);}
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papoapapo/cardsStorage.dart';
import 'package:papoapapo/database_helpers.dart';
import 'package:papoapapo/screens/cardList_screen.dart';
import 'package:papoapapo/screens/card_add_edit_screen.dart';
import 'package:papoapapo/screens/settings_screen.dart';
import 'package:papoapapo/screens/game_screen.dart';
import 'package:papoapapo/screens/common.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';


var myDir;


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Menu(title: title),
    );
  }
}

class Menu extends StatefulWidget {
  final String title;

  Menu({Key key, this.title}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;

  @override
  void initState() {
    super.initState();
    bootstrapCards();
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        print("Shared 1:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
        if (_sharedFiles != null) _goCardAdd((_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));

      });

    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        print("Shared 2:" + (_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));
        if (_sharedFiles != null) _goCardAdd((_sharedFiles?.map((f) => f.path)?.join(",") ?? ""));

      });

    });

  }
  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
  void _goCardAdd(path) {
    MyCard myEmptyCard = new MyCard();
    myEmptyCard.url=path;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => AddEditScreen(myCard: myEmptyCard)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: mainBackgroundColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () => _goSettings(),
            )
          ],
        ),
        body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(15),
                child: Text('Escolha um Modo de Jogo',
                  style: TextStyle(fontSize: 20.0),
                )
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                color: mainBackgroundColor,
                minWidth: 200,
                height: 50,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => _goGame('mix'),
                child: Text(
                  "Misto",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                color: mainBackgroundColor,
                minWidth: 200,
                height: 50,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => _goGame('category'),
                child: Text(
                  "Por Categoria",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 20,
              thickness: 0.3,
              indent: 60,
              endIndent: 60,
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                color: mainBackgroundColor,
                minWidth: 200,
                height: 50,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => _goCards(),
                child: Text(
                  "As Minhas Cartas",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: FlatButton(
                color: Colors.red,
                minWidth: 200,
                height: 50,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: Text(
                  "Sair",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        )
    );
  }
  void _goGame(String currentMode) {
    mode = currentMode;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => MyHomePage(title: title)),
    );
  }
  void _goSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => Settings(storage: CardsStorage(), title: title+' - Configurações')),
    );
  }
  void _goCards() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => CardList(title: title+' - Cartas')),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_cards/cardsStorage.dart';
import 'package:our_cards/screens/settings_screen.dart';
import 'package:our_cards/screens/game_screen.dart';
import 'package:our_cards/screens/common.dart';

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

  @override
  void initState() {
    super.initState();
    bootstrapCards();
    getOurCards();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: mainBackgroundColor,
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
                  "Mix",
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
            Container(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                color: mainBackgroundColor,
                minWidth: 200,
                height: 50,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () => _goSettings(),
                child: Text(
                  "Configurações",
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
}

import 'package:flutter/material.dart';
import 'package:our_cards/cardsStorage.dart';
import 'package:our_cards/cards.dart';
import 'package:our_cards/screens/cardList_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:our_cards/database_helpers.dart';
import 'package:our_cards/screens/common.dart';


readTextModeOn() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'textModeOn';
  final value = prefs.getBool(key) ?? false;
  textModeOn=value;
}

class Settings extends StatefulWidget {
  final String title;
  final CardsStorage storage;

  Settings({Key key, @required this.storage, this.title}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
    super.initState();
    readTextModeOn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          backgroundColor: mainBackgroundColor,
        ),
        body: Column(
            children: <Widget>[
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text('Modo de Texto'),
                        onPressed: () {
                          _switchTextModeOn();
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(textModeOn ? 'Ativo' : 'Inativo')
                    )
                  ]
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text('Inicializar Cartas'),
                      onPressed: () {
                        _saveToDB();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text('Listar Cartas'),
                      onPressed: () => _goCards(),
                    ),
                  ),
                ],
              ),
            ]
        )
    );
  }

  void _goCards() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => CardList(title: title+' - Cartas')),
    );
  }
  _switchTextModeOn() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'textModeOn';
    textModeOn = !textModeOn;
    final value = textModeOn;
    prefs.setBool(key, value);

    setState(() {});
  }

  _saveToDB() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    MyCard card = await helper.queryCard(2);
    print('card: $card.toString()');
    if (card == null){
      for (int i=0; i< cards.length; i++) {
        MyCard card = MyCard();
        card.card = cards[i]['card'];
        if (cards[i].containsKey('category')) {
          card.category = cards[i]['category'];
        }
        if (cards[i].containsKey('url')) {
          card.url = cards[i]['url'];
        }
        int id = await helper.insert(card);
        print('inserted row: $id');
      }
    }
  }

}
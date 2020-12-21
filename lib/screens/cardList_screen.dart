
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:our_cards/database_helpers.dart';
import 'package:our_cards/screens/common.dart';


readTextModeOn() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'textModeOn';
  final value = prefs.getBool(key) ?? false;
  textModeOn=value;
}

class CardList extends StatefulWidget {
  final String title;

  CardList({Key key, this.title}) : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {

  final _biggerFont = const TextStyle(fontSize: 18.0);
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          backgroundColor: mainBackgroundColor,
        ),
        body: FutureBuilder<List>(
          future: helper.queryAllCards(),
          initialData: List(),
          builder: (context, snapshot) {
            return snapshot.hasData ?
            new ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return _buildRow(snapshot.data[i]);
              },
            )
                : Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }

  Widget _buildRow(MyCard card) {
    return new ListTile(
      title: new Text(card.card, style: _biggerFont),
    );
  }
       /* floatingActionButton:
          FloatingActionButton(
              onPressed: () =>_goCardAdd(false,''),
              tooltip: 'Nova Carta',
              child: Icon(Icons.add),
              backgroundColor: mainBackgroundColor,
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );*/
  }

 /* void _goCardAdd() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => Settings(title: title+' - Cartas')),
    );
  }

  _readFromDB() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    MyCard card = await helper.queryCard(rowId);
    if (card == null) {
      print('read row $rowId: empty');
    } else {
      print('read row $rowId: ${card.card} - ${card.category}');
    }
  }


}*/
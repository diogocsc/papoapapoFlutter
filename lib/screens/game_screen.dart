import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:our_cards/screens/common.dart';
import 'package:our_cards/database_helpers.dart';

import 'dart:math';

int  random(min, max){
  var rn = new Random();
  return min + rn.nextInt(max - min);
}
var _cardImage;
var _fileImage;

final _emptyCardText='Não há mais cartas';
final _emptyCardTextForCategory='Não há mais cartas para esta categoria';




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int pop;
  List<MyCard> _cardsAuxQ;
  List<MyCard> _cardsAuxP;
  List<MyCard> _cardsAuxD;
  List<MyCard> _cardsAux;
  String _cardText = mode != 'category' ? 'Prima a seta em baixo para começar' : 'Escolha a categoria acima';
  bool _hasCardImage=false;
  int isAsset;


  @override
  void initState() {
    super.initState();
    getOurCards();
    _cardsAuxQ = List.from(ourCardsQ);
    _cardsAuxP = List.from(ourCardsP);
    _cardsAuxD = List.from(ourCardsD);
    _cardsAux = List.from(ourCards);
  }
  void _getFileImage (path)  {
      // Either the permission was already granted before or the user just granted it
      setState(() {
        _fileImage = FileImage(File(path));
      });
    }

  void _getCard (List<MyCard> cardList) {
    if (cardList.length == 0) {
      if (mode == 'category') {
        if (_cardsAuxD.isNotEmpty || _cardsAuxP.isNotEmpty || _cardsAuxQ.isNotEmpty) {
          _cardText = _emptyCardTextForCategory;
        }
        else _cardText = _emptyCardText;

      }
      else
        _cardText = _emptyCardText;
    }
    else {
      pop = random(0, cardList.length);
      isAsset = cardList[pop].isAsset;
      _cardText = cardList[pop].card;
      if(isAsset == 0) _getFileImage(cardList[pop].url);
      if (cardList[pop].url != null && cardList[pop].url.isNotEmpty && ! textModeOn && (isAsset == 1 || isAsset == 0 && _fileImage != null)) {
        _cardImage = PhotoView(
          imageProvider: isAsset == 1 ? AssetImage(cardList[pop].url) : _fileImage,
          backgroundDecoration: BoxDecoration(color: Colors.transparent),
          customSize: MediaQuery
              .of(context)
              .size * 1,
        );
        _hasCardImage = true;
      }
    }
  }

  void _getACard(bool isReset, String category) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _hasCardImage=false;
      if(isReset){
        if (mode == 'category'){
          _cardsAuxQ.clear();
          _cardsAuxQ.addAll(ourCardsQ);
          _cardsAuxP.clear();
          _cardsAuxP.addAll(ourCardsP);
          _cardsAuxD.clear();
          _cardsAuxD.addAll(ourCardsD);
        }
        else _cardsAux.addAll(ourCards);
        _cardText = mode != 'category' ? 'Prima a seta em baixo para começar' : 'Escolha a categoria acima';
      }
      else {
        if (mode == 'category'){
          switch(category){
            case 'Q': {
              _getCard(_cardsAuxQ);
              if (_cardsAuxQ.isNotEmpty) _cardsAuxQ.removeAt(pop);
            }
            break;
            case 'P': {
              _getCard(_cardsAuxP);
              if(_cardsAuxP.isNotEmpty) _cardsAuxP.removeAt(pop);
            }
            break;
            case 'D': {
              _getCard(_cardsAuxD);
              if(_cardsAuxD.isNotEmpty) _cardsAuxD.removeAt(pop);
            }
            break;
          }
        }
        else {
          _getCard(_cardsAux);
          if(_cardsAux.isNotEmpty) _cardsAux.removeAt(pop);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          backgroundColor: mainBackgroundColor,
        ),
        body:
        Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: mode=='category',
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: mainBackgroundColor,minimumSize: Size(50, 50)),
                        onPressed: () => _getACard(false,'Q'),
                        child: Text(
                          "Quebra \n Gelo",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: mainBackgroundColor,minimumSize: Size(50, 50)),
                        onPressed: () => _getACard(false,'P'),
                        child: Text(
                          "Profunda",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: mainBackgroundColor,minimumSize: Size(50, 50)),
                        // color: mainBackgroundColor,
                        // textColor: Colors.white,
                        // padding: EdgeInsets.all(8.0),
                        // splashColor: Colors.blueAccent,
                        onPressed: () => _getACard(false,'D'),
                        child: Text(
                          "Divertida",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    )
                  ]
              ),
            ),
            Visibility(
              visible: _hasCardImage==false,
              child:
              Container(
                padding: EdgeInsets.all(30),
                child: Text('$_cardText',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Visibility(
                visible: _hasCardImage,
                child:
                Expanded(
                    child:
                    Container(
                      child: _cardImage,
                    )
                )
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                      visible: _cardText == _emptyCardText,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: FlatButton(
                          color: mainBackgroundColor,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blueAccent,
                          onPressed: () => _getACard(true,''),
                          child: Text(
                            "Reiniciar",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      )
                  ),
                  Visibility(
                      visible:  _cardText == _emptyCardText,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: FlatButton(
                          color: mainBackgroundColor,
                          textColor: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blueAccent,
                          onPressed: ()=>SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                          child: Text(
                            "Sair",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      )
                  )
                ]
            ),
          ],
        ),
        floatingActionButton:
        Visibility(
          visible: _cardText != _emptyCardText && mode != 'category',
          child:FloatingActionButton(
            onPressed: () =>_getACard(false,''),
            tooltip: 'Próxima Carta',
            child: Icon(Icons.arrow_forward),
            backgroundColor: mainBackgroundColor,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
}
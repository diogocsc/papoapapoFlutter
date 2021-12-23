import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:papoapapo/screens/common.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:papoapapo/cardsOnline.dart';

import 'dart:math';

int  random(min, max){
  var rn = new Random();
  return min + rn.nextInt(max - min);
}
var _cardImage;
var _onlineImage;

final _emptyCardText='Não há mais cartas';
final _instructionsMix = 'Instruções \n \n '+
    '1 - Prima a seta no canto inferior direito para prosseguir com o jogo \n \n'+
    '2 - Leia em voz alta e depois Responda à pergunta ou realize a dinâmica proposta \n \n'+
    '3 - Passe a vez e o telefone ao próximo jogador \n \n'+
    '4 - O próximo jogador recomeça do passo 1 ou do passo 2, consoante quiser, ou fôr definido inicialmente pelo grupo';
final __instructionsCategory = 'Instruções \n \n'+
                                '1 - Selecione a categoria acima para prosseguir com o jogo \n \n'+
                                '2 - Responda à pergunta ou realize a dinâmica proposta \n \n'+
                                '3 - Passe a vez e o telefone ao próximo jogador \n \n'+
                                '4 - O próximo jogador recomeça do passo 1 ou do passo 2, consoante quiser, ou fôr definido inicialmente pelo grupo';



class MyOnlineGame extends StatefulWidget {
  MyOnlineGame({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  _MyOnlineGameState createState() => _MyOnlineGameState();
}

class _MyOnlineGameState extends State<MyOnlineGame> {

  int pop=0;
  List<OnlineCard> _cardsAux;
  String _cardText = mode != 'category' ? _instructionsMix : __instructionsCategory;
  bool _hasCardImage=false;
  int isAsset;
  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;
  Future<List<OnlineCard>> futureCards;



  @override
  void initState() {
    super.initState();
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            getOnlineCards().then((response){
              _cardsAux = List.from(onlineCards);
            });
          } else {
            _showDialog(); // show dialog
          }
        }).catchError((error) {
          _showDialog(); // show dialog
        });
      } on SocketException catch (_) {
        _showDialog();
        print('not connected'); // show dialog
      }
    });


  }

  void _getOnlineImage (url)  {
      // Either the permission was already granted before or the user just granted it
      setState(() {
        _onlineImage = NetworkImage(url);
      });
    }

  void _getCard (List<OnlineCard> cardList) {
    if (cardList.length == 0) {
        _cardText = _emptyCardText;
    }
    else {
      pop = random(0, cardList.length);
      _cardText = cardList[pop].card;
      if (cardList[pop].url != null && cardList[pop].url.isNotEmpty && ! textModeOn ) {
        _getOnlineImage(cardList[pop].url);
        _cardImage = PhotoView(
          imageProvider: _onlineImage,
          backgroundDecoration: BoxDecoration(color: Colors.transparent),
          customSize: MediaQuery
              .of(context)
              .size * 1,
        );
        _hasCardImage = true;
      }
    }
  }

  void _getACard(bool isReset) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _hasCardImage=false;
      if(isReset){
        _cardsAux.addAll(onlineCards);
        _cardText = mode != 'category' ? _instructionsMix : __instructionsCategory;
      }
      else if(_cardsAux != null){
         _getCard(_cardsAux);
          if(_cardsAux != null && _cardsAux.isNotEmpty) _cardsAux.removeAt(pop);
        }

    });
  }

  void _showDialog() {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Oops! Parece que está sem Internet"),
        content: Text("Pode querer sair agora da aplicação"),
        actions: <Widget>[FlatButton(child: Text("SAIR"), onPressed: ()=>SystemChannels.platform.invokeMethod('SystemNavigator.pop'))],
      ),
    );
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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () async {
                if (await Permission.storage.request().isGranted) {
                  ShareFilesAndScreenshotWidgets().shareScreenshot(
                    previewContainer,
                    originalSize,
                    "Papo a Papo",
                    "papoapapo.png",
                    "image/png",
                    text: "Jogamos ao Papo a Papo? \n $_cardText");
                }
              },
            )
          ],
        ),
        body:
    RepaintBoundary(
    key: previewContainer,
    child:
        Container(
    color:Colors.white,
    child:
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
              visible: _hasCardImage==false,
              child:
              Container(
                padding: EdgeInsets.all(30),
                child: Text('$_cardText',
                  style: _cardText != _instructionsMix && _cardText != __instructionsCategory ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.headline6,
                  textAlign: _cardText != _instructionsMix && _cardText != __instructionsCategory ? TextAlign.center : TextAlign.justify,
                ),
              ),
            ),
            Visibility(
                visible: _hasCardImage,
                child:
                Expanded(
                    child: /*FutureBuilder<List<OnlineCard>>(
                      future: fetchCards(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                  itemCount: snapshot.data.length,
                                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2,),
                                  itemBuilder:  (BuildContext context, int i){
                                    return Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0.5,color: Colors.grey)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              Text(snapshot.data[i].card,
                                                style: _cardText != _instructionsMix && _cardText != __instructionsCategory ? Theme.of(context).textTheme.headline4 : Theme.of(context).textTheme.headline6,
                                                textAlign: _cardText != _instructionsMix && _cardText != __instructionsCategory ? TextAlign.center : TextAlign.justify,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              )
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                    */Container(
                      child: _cardImage,
                    )   // By default, show a loading spinner.)
                       // return const CircularProgressIndicator();
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
                          onPressed: () => _getACard(true),
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
      ),
    ),
        floatingActionButton:
        Visibility(
          visible: _cardText != _emptyCardText && mode != 'category',
          child:FloatingActionButton(
            onPressed: () =>_getACard(false),
            tooltip: 'Próxima Carta',
            child: Icon(Icons.arrow_forward),
            backgroundColor: mainBackgroundColor,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
}

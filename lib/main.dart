import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

import 'dart:math';

int  random(min, max){
  var rn = new Random();
  return min + rn.nextInt(max - min);
}
final _cards = [
  {'card':'Se fosses um animal que animal gostavas de ser ? Porquê?',"url":"images/sefossesanimal.png",'category':'Q'},
  {'card':'Se fosses uma planta, qual serias? Porquê ?',"url":"images/sefossesplanta.png",'category':'Q'},
  {'card':'Expressa um agradecimento por algo que tenhas vivido com alguém deste grupo',"url":"images/agradecimento.png",'category':'P'},
  {'card':'Qual foi a coisa mais louca que fizeste na vida?',"url":"images/coisamaislouca.png",'category':'P'},
  {'card':'Canta ao grupo uma música que usarias para adormecer um bébé. (sem os adormecer)',"url":"images/musicaadormecerbebe.png",'category':'Q'},
  {'card':'Conta ao grupo por gestos como aprendeste a andar de bicicleta',"url":"images/comoaprendestebicicleta.png",'category':'D'},
  {'card':'Conta ao grupo como chegaste aqui hoje. Depois pede ao grupo para contar esta história contigo',"url":"images/comochegasteaquihoje.png",'category':'D'},
  {'card':'Como nasceste?',"url":"images/comonasceste.png",'category':'P'},
  {'card':'Como é que foi o teu brimeiro beijo?',"url":"images/comoprimeirobeijo.png",'category':'D'},
  {'card':'Como te estás a sentir neste momento?',"url":"images/comotesentes.png",'category':'Q'},
  {'card':'Convida alguém do grupo para cantar contigo uma canção de que gostes. Podem improvisar instrumentos.',"url":"images/convidacantarcontigo.png",'category':'D'},
  {'card':'Representa com o teu corpo uma situação em que te sentes bloqueado na tua vida atual',"url":"images/corposituacaobloqueado.png",'category':'P'},
  {'card':'Inventa uma dança com sons. Podes envolver mais pessoas do grupo',"url":"images/dancacomsons.png",'category':'D'},
  {'card':'Faz uma dança em que moves 3 partes do corpo em simultâneo',"url":"images/dancatrespartescorpo.png",'category':'D'},
  {'card':'Imita um animal de que gostes sem revelar qual é',"url":"images/imitaanimal.png",'category':'D'},
  {'card':'Faz uma massagem nos ombros da pessoa que está À tua direita',"url":"images/massagemadireita.png",'category':'Q'},
  {'card':'Convida todo o grupo a fazer uma massagem coletiva.',"url":"images/massagemcoletiva.png",'category':'Q'},
  {'card':'Qual foi o momento mais alegre que viveste nos últimos sete dias?',"url":"images/momentomaisalegre.png",'category':'P'},
  {'card':'Qual foi o momento mais desafiante que viveste nos últimos cinco anos?',"url":"images/momentomaisdesafiante.png",'category':'P'},
  {'card':'Qual foi o momento mais divertido que viveste no último ano?',"url":"images/momentomaisdivertidoano.png",'category':'D'},
  {'card':'Qual foi o momento mais divertido que viveste na última semana?',"url":"images/momentomaisdivertidosemana.png",'category':'D'},
  {'card':'Qual foi o momento + triste que viveste nos últimos 3 meses?',"url":"images/momentomaistriste.png",'category':'P'},
  {'card':'Mostra ao grupo o que guardas na tua carteira.',"url":"images/oqueguardascarteira.png",'category':'Q'},
  {'card':'?',"url":"images/Surprise.png"},
  {'card':'?',"url":"images/Surprise.png"},
  {'card':'O que é que te faz corar?',"url":"images/oquetefazcorar.png",'category':'D'},
  {'card':'O que perguntarias a Deus?',"url":"images/perguntaadeus.png",'category':'P'},
  {'card':'Qual é a pergunta que gostavas que te fizessem?',"url":"images/perguntatefizessem.png",'category':'P'},
  {'card':'Qual é a primeira coisa que fazes ao acordar ?',"url":"images/primeiracoisaacordar.png",'category':'Q'},
  {'card':'Que pergunta gostavas de fazer à pessoa que está à tua frente ? Porquê ?',"url":"images/queperguntapessoafrente.png",'category':'Q'},
  {'card':'Conta ao grupo algo que gostarias de realizar nos próximos 2 anos.',"url":"images/realizarproximosdoisanos.png",'category':'P'},
  {'card':'Se fosses um jornalista, quem gostarias de entrevistar? Porquê ?',"url":"images/sefossesjornalista.png",'category':'Q'},
  {'card':'Se fosses um objeto deste lugar, qual serias? Porquê ?',"url":"images/sefossesobjeto.png",'category':'Q'},
  {'card':'Conta uma situação marcante que viveste com uma pessoa deste grupo.',"url":"images/situacaomarcante.png",'category':'P'},
  {'card':'Tens a tua sobrevivência garantida. Em que te ocupas?',"url":"images/sobrevivenciagarantida.png",'category':'P'},
  {'card':'Quais são os teus três maiores valores ?',"url":"images/tresmaioresvalores.png",'category':'P'},
  {'card':'Alguma vez viste a tua vida andar para trás?',"url":"images/vidaandarparatras.png",'category':'P'},
  {'card':'Partilha um momento em que sentiste raiva. Como agiste?',"url":"images/momentoraiva.png",'category':'P'},
  {'card':'Se fosses um livro, que livro serias? Porquê?','category':'Q'}
];
final _cardsQ = [
  {'card':'Se fosses um animal que animal gostavas de ser ? Porquê?',"url":"images/sefossesanimal.png",'category':'Q'},
  {'card':'Se fosses uma planta, qual serias? Porquê ?',"url":"images/sefossesplanta.png",'category':'Q'},
  {'card':'Canta ao grupo uma música que usarias para adormecer um bébé. (sem os adormecer)',"url":"images/musicaadormecerbebe.png",'category':'Q'},
  {'card':'Como te estás a sentir neste momento?',"url":"images/comotesentes.png",'category':'Q'},
  {'card':'Faz uma massagem nos ombros da pessoa que está À tua direita',"url":"images/massagemadireita.png",'category':'Q'},
  {'card':'Convida todo o grupo a fazer uma massagem coletiva.',"url":"images/massagemcoletiva.png",'category':'Q'},
  {'card':'Mostra ao grupo o que guardas na tua carteira.',"url":"images/oqueguardascarteira.png",'category':'Q'},
  {'card':'?',"url":"images/Surprise.png"},
  {'card':'Qual é a primeira coisa que fazes ao acordar ?',"url":"images/primeiracoisaacordar.png",'category':'Q'},
  {'card':'Que pergunta gostavas de fazer à pessoa que está à tua frente ? Porquê ?',"url":"images/queperguntapessoafrente.png",'category':'Q'},
  {'card':'Se fosses um jornalista, quem gostarias de entrevistar? Porquê ?',"url":"images/sefossesjornalista.png",'category':'Q'},
  {'card':'Se fosses um objeto deste lugar, qual serias? Porquê ?',"url":"images/sefossesobjeto.png",'category':'Q'},
  {'card':'Se fosses um livro, que livro serias? Porquê?','category':'Q'}
];
final _cardsP = [
  {'card':'Expressa um agradecimento por algo que tenhas vivido com alguém deste grupo',"url":"images/agradecimento.png",'category':'P'},
  {'card':'Qual foi a coisa mais louca que fizeste na vida?',"url":"images/coisamaislouca.png",'category':'P'},
  {'card':'Como nasceste?',"url":"images/comonasceste.png",'category':'P'},
  {'card':'Representa com o teu corpo uma situação em que te sentes bloqueado na tua vida atual',"url":"images/corposituacaobloqueado.png",'category':'P'},
  {'card':'Qual foi o momento mais alegre que viveste nos últimos sete dias?',"url":"images/momentomaisalegre.png",'category':'P'},
  {'card':'Qual foi o momento mais desafiante que viveste nos últimos cinco anos?',"url":"images/momentomaisdesafiante.png",'category':'P'},
  {'card':'Qual foi o momento + triste que viveste nos últimos 3 meses?',"url":"images/momentomaistriste.png",'category':'P'},
  {'card':'?',"url":"images/Surprise.png"},
  {'card':'O que perguntarias a Deus?',"url":"images/perguntaadeus.png",'category':'P'},
  {'card':'Qual é a pergunta que gostavas que te fizessem?',"url":"images/perguntatefizessem.png",'category':'P'},
  {'card':'Conta ao grupo algo que gostarias de realizar nos próximos 2 anos.',"url":"images/realizarproximosdoisanos.png",'category':'P'},
  {'card':'Conta uma situação marcante que viveste com uma pessoa deste grupo.',"url":"images/situacaomarcante.png",'category':'P'},
  {'card':'Tens a tua sobrevivência garantida. Em que te ocupas?',"url":"images/sobrevivenciagarantida.png",'category':'P'},
  {'card':'Quais são os teus três maiores valores ?',"url":"images/tresmaioresvalores.png",'category':'P'},
  {'card':'Alguma vez viste a tua vida andar para trás?',"url":"images/vidaandarparatras.png",'category':'P'},
  {'card':'Partilha um momento em que sentiste raiva. Como agiste?',"url":"images/momentoraiva.png",'category':'P'}
];
final _cardsD = [
  {'card':'Conta ao grupo por gestos como aprendeste a andar de bicicleta',"url":"images/comoaprendestebicicleta.png",'category':'D'},
  {'card':'Conta ao grupo como chegaste aqui hoje. Depois pede ao grupo para contar esta história contigo',"url":"images/comochegasteaquihoje.png",'category':'D'},
  {'card':'Como é que foi o teu brimeiro beijo?',"url":"images/comoprimeirobeijo.png",'category':'D'},
  {'card':'Convida alguém do grupo para cantar contigo uma canção de que gostes. Podem improvisar instrumentos.',"url":"images/convidacantarcontigo.png",'category':'D'},
  {'card':'Inventa uma dança com sons. Podes envolver mais pessoas do grupo',"url":"images/dancacomsons.png",'category':'D'},
  {'card':'Faz uma dança em que moves 3 partes do corpo em simultâneo',"url":"images/dancatrespartescorpo.png",'category':'D'},
  {'card':'Imita um animal de que gostes sem revelar qual é',"url":"images/imitaanimal.png",'category':'D'},
  {'card':'Qual foi o momento mais divertido que viveste no último ano?',"url":"images/momentomaisdivertidoano.png",'category':'D'},
  {'card':'Qual foi o momento mais divertido que viveste na última semana?',"url":"images/momentomaisdivertidosemana.png",'category':'D'},
  {'card':'?',"url":"images/Surprise.png"},
  {'card':'O que é que te faz corar?',"url":"images/oquetefazcorar.png",'category':'D'}
];
var _mode='ncategory';
var _cardImage;
final _mainBackgroundColor= Color(0xff6378a2);
final _emptyCardText='Não há mais cartas';
final _emptyCardTextForCategory='Não há mais cartas para esta categoria';

final _title= 'Papo a Papo';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Menu(title: _title),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: _mainBackgroundColor,
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
                  color: _mainBackgroundColor,
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
                      color: _mainBackgroundColor,
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
    _mode = currentMode;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MyHomePage(title: _title)),
    );
  }
}




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
  List<Map<String, String>> _cardsAuxQ = List.from(_cardsQ);
  List<Map<String, String>> _cardsAuxP = List.from(_cardsP);
  List<Map<String, String>> _cardsAuxD = List.from(_cardsD);
  List<Map<String, String>> _cardsAux = List.from(_cards);
  String _cardText = _mode != 'category' ? 'Prima a seta em baixo para começar' : 'Escolha a categoria acima';


  bool _hasCardImage=false;
//  @override
 // void initState() {
 //   _cardsAux = List.from(_cards);
 //   super.initState();
 // }
  void _getCard (List<Map<String, String>> cardList) {
    if (cardList.length == 0) {
      if (_mode == 'category') {
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
      _cardText = cardList[pop]['card'];
      if (cardList[pop].containsKey('url')) {
        _cardImage = PhotoView(
          imageProvider: AssetImage(cardList[pop]['url']),
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
        if (_mode == 'category'){
          _cardsAuxQ.clear();
          _cardsAuxQ.addAll(_cardsQ);
          _cardsAuxP.clear();
          _cardsAuxP.addAll(_cardsP);
          _cardsAuxD.clear();
          _cardsAuxD.addAll(_cardsD);
        }
        else _cardsAux.addAll(_cards);
        _cardText = _mode != 'category' ? 'Prima a seta em baixo para começar' : 'Escolha a categoria acima';
      }
      else {
          if (_mode == 'category'){
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
        backgroundColor: _mainBackgroundColor,
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
            visible: _mode=='category',
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: _mainBackgroundColor,minimumSize: Size(50, 50)),
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
                          style: ElevatedButton.styleFrom(primary: _mainBackgroundColor,minimumSize: Size(50, 50)),
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
                      style: ElevatedButton.styleFrom(primary: _mainBackgroundColor,minimumSize: Size(50, 50)),
                      // color: _mainBackgroundColor,
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
                        color: _mainBackgroundColor,
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
                        color: _mainBackgroundColor,
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
            visible: _cardText != _emptyCardText && _mode != 'category',
            child:FloatingActionButton(
            onPressed: () =>_getACard(false,''),
            tooltip: 'Próxima Carta',
            child: Icon(Icons.arrow_forward),
            backgroundColor: _mainBackgroundColor,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
}

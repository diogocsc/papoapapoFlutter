import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papoapapo/cardsStorage.dart';
import 'package:papoapapo/database_helpers.dart';
import 'package:papoapapo/screens/cardList_screen.dart';
import 'package:papoapapo/screens/card_add_edit_screen.dart';
import 'package:papoapapo/screens/settings_screen.dart';
import 'package:papoapapo/screens/game_screen.dart';
import 'package:papoapapo/screens/gameOnline_screen.dart';
import 'package:papoapapo/screens/common.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
/// -----------------------------------
///          External Packages
/// -----------------------------------

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


final FlutterAppAuth appAuth = FlutterAppAuth();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

var myDir;

/// -----------------------------------
///           Auth0 Variables
/// -----------------------------------

var AUTH0_DOMAIN = dotenv.env['AUTH0_DOMAIN'];
var AUTH0_CLIENT_ID = dotenv.env['AUTH0_CLIENT_ID'];

const AUTH0_REDIRECT_URI = 'com.papoapapo://login-callback';
var AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

/// -----------------------------------
///           Profile Widget
/// -----------------------------------

class Profile extends StatelessWidget {
  final logoutAction;
  final String name;
  final String picture;

  Profile(this.logoutAction, this.name, this.picture);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 4.0),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(picture ?? ''),
            ),
          ),
        ),
        SizedBox(height: 24.0),
        Text('Nome: $name'),
        SizedBox(height: 48.0),
        RaisedButton(
          onPressed: () {
            logoutAction();
          },
          child: Text('Terminar Sessão'),
        ),
      ],
    );
  }
}


void _showDialog(context) {
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
/// -----------------------------------
///            Login Widget
/// -----------------------------------

class Login extends StatelessWidget {
  final loginAction;
  final String loginError;

  const Login(this.loginAction, this.loginError);





  /*getCoverImage(context){
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return
          } else {
            _showDialog(context); // show dialog
          }
        }).catchError((error) {
          _showDialog(context); // show dialog
        });
      } on SocketException catch (_) {
        _showDialog(context);
        print('not connected'); // show dialog
      }
  } */

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       // Image.network('https://www.papoapapo.com/images/capa.png', height: 300), //getCoverImage(context),
        Container(
          height: 300,
        child: CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
            imageUrl:
            'https://www.papoapapo.com/images/capa.png',
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width*0.8,
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color:Color(0xFFF5B536),
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Text('Ao registar-se nesta aplicação autoriza o envio de emails ocasionais com eventos, produtos e notícias referentes ao Papo a Papo. A qualquer momento poderá pedir para suspender o envio de emails enviando email para papoapapo2020@gmail.com')
        ),
        RaisedButton(
          onPressed: () {
            loginAction();
          },
          child: Text('Entrar'),
        ),
        Text(loginError != null && loginError.isNotEmpty ? 'Ocorreu um erro ao ligar-se ao servidor de autenticação. Por favor certifique-se de que está ligado à Internet.': ''),
      ],
    );
  }


}

/// -----------------------------------
///            Menu Widget
/// -----------------------------------

class MenuLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
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
            onPressed: () => _goGame('online', context),
            child: Text(
              "Misto Online",
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
            onPressed: () => _goGame('mix', context),
            child: Text(
              "Misto Local",
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
            onPressed: () => _goGame('category', context),
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
            onPressed: () => _goCards(context),
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
    );
  }
  void _goGame(String currentMode, context) {
    mode = currentMode;
    if (mode == 'online') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) => MyOnlineGame(title: title)),
      );
    }
    else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (BuildContext context) => MyHomePage(title: title)),
      );
    }
  }
  void _goCards(context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => CardList(title: title+' - Cartas')),
    );
  }
}

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
  bool isBusy = false;
  bool isLoggedIn = false;
  String errorMessage;
  String name;
  String picture;

  @override
  void initState() {
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            initAction();

          } else {
            _showDialog(context); // show dialog
          }
        }).catchError((error) {
          _showDialog(context); // show dialog
        });
      } on SocketException catch (_) {
        _showDialog(context);
        print('not connected'); // show dialog
      }
    });
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
  void initAction() async {
    final storedRefreshToken = await secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) return;

    setState(() {
      isBusy = true;
    });

    try {
      final response = await appAuth.token(TokenRequest(
        AUTH0_CLIENT_ID,
        AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        refreshToken: storedRefreshToken,
      ));

      final idToken = parseIdToken(response.idToken);
      final profile = await getUserDetails(response.accessToken);

      secureStorage.write(key: 'refresh_token', value: response.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      logoutAction();
    }
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
        body: Center(
          child: isBusy
              ? CircularProgressIndicator()
              : isLoggedIn
              ? MenuLayout()// Profile(logoutAction, name, picture)
              : Login(loginAction, errorMessage),
        ),

    );
  }
  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }
  Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }
  Future<void> loginAction() async {
    setState(() {
      isBusy = true;
      errorMessage = '';
    });

    try {
      final AuthorizationTokenResponse result =
      await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: ['openid', 'profile', 'offline_access'],
          // promptValues: ['login'] // ignore any existing session; force interactive login prompt
        ),
      );

      final idToken = parseIdToken(result.idToken);
      final profile = await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });
    } catch (e, s) {
      print('login error: $e - stack: $s');

      setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });
    }
  }
  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
    setState(() {
      isLoggedIn = false;
      isBusy = false;
    });
  }

  void _goSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => Settings(storage: CardsStorage(), title: title+' - Configurações')),
    );
  }

}
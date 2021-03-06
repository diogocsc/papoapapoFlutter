import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:papoapapo/screens/common.dart';
import 'package:papoapapo/database_helpers.dart';
import 'package:papoapapo/screens/cardList_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';




class AddEditScreen extends StatefulWidget {
  final MyCard myCard;
  AddEditScreen({Key key,@required this.myCard}) : super(key: key);

  @override
  _AddEditScreenState createState() {
    return _AddEditScreenState(myCard);
  }

}

class _AddEditScreenState extends State<AddEditScreen> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cardController;
  TextEditingController _categoryController;
  TextEditingController _urlController;
  MyCard myCard;
  PickedFile image;

  _AddEditScreenState(this.myCard){
    _cardController = TextEditingController(text:myCard != null ? myCard.card : '');
    _categoryController = TextEditingController(text: myCard != null ? myCard.category : '');
    _urlController = TextEditingController(text: myCard != null ? myCard.url : '');
  }

  @override
  void initState() {
    super.initState();
    // Copies file from cache to external directory, if file is coming from an externalApp
    // which is defined by having card text empty and url filled
    if (_cardController.text == '' && _urlController.text !='') copyFile();
   }

   copyFile() async {
//     print('About to copy file');
     File img = File(myCard.url);
     if (img != null) {
       final _dir = await getExternalStorageDirectory();
       String filename = basename(img.path);
       File file;
       if (await Permission.storage.request().isGranted) {
         file = await File(img.path).copy(_dir.path +'/$filename');
       }
       setState(() {
         _urlController.text = file.path;
       });

     }
   }

  galleryConnect() async {
    print('Picker is Called');
    ImagePicker picker = new ImagePicker();
    PickedFile img = await picker.getImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      final _dir = await getExternalStorageDirectory();
      String filename = basename(img.path);
      File file;
      if (await Permission.storage.request().isGranted) {
        file = await File(image.path).copy(_dir.path +'/$filename');
      }
      setState(() {
        _urlController.text = file.path;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _cardController.dispose();
    _categoryController.dispose();
    _urlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title+ ' - Carta'),
        backgroundColor: mainBackgroundColor,
      ),
      body: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                // Add TextFormFields and ElevatedButton here.
                TextFormField(
                  controller: _cardController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.sd_card_alert_rounded),
                    hintText: 'Texto da Carta',
                    labelText: 'Texto *',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Campo obrgatório';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  //initialValue: widget.myCard.category,
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.category),
                    hintText: 'Q, P ou D',
                    labelText: 'Categoria',
                  ),
                ),
                ElevatedButton(
                    child: Text('Selecionar Imagem'),
                    onPressed: () {
                      galleryConnect();
                    },
                ),
                Expanded(
                  child: image == null
                      ? _urlController.text == ''
                          ? Text('Nenhuma imagem selecionada.')
                          : _urlController.text.substring(0,1)=='i'
                              ? Image.asset(_urlController.text)
                              : Image.file(File(_urlController.text))
                      : new Image.file(File(image.path)),
                ),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.http),
                    hintText: '/images/nomedaimagem.png',
                    labelText: 'URL da Imagem',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      _saveRecord(widget.myCard != null && widget.myCard.id != null ? widget.myCard.id : 0, _cardController.text, _categoryController.text, _urlController.text, context);
                    }
                  },
                  child: Text('Submeter'),
                ),
                Visibility(
                  visible: widget.myCard != null && widget.myCard.id != null,
                  child:ElevatedButton(
                    onPressed: () {
                        _deleteRecord(widget.myCard.id, context);
                    },
                    child: Text('Apagar'),
                  ),
                ),
              ]
          )
      ),
    );
  }
  _saveRecord(int id, String card, String category, String url, BuildContext context) async{
    DatabaseHelper helper = DatabaseHelper.instance;
    MyCard myCard = id == 0 ? new MyCard() : await helper.queryCard(id);
    myCard.card = card;
    myCard.category = category;
    myCard.url = url;
    // if url starts with i, it is implied that it starts with images, and so isAsset should be one
    myCard.isAsset = url == ''
                      ? 0
                      : url.substring(0,1) == 'i' ? 1 : 0;
    if (id==0) await helper.insert(myCard);
    else await helper.update(myCard);
    Navigator.push(context,
      MaterialPageRoute(
          builder: (BuildContext context) => CardList(title: title+' - Cartas')),
    );
    getOurCards();
  }
  _deleteRecord(int id, BuildContext context) async{
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.delete(id);
    Navigator.push(context,
      MaterialPageRoute(
          builder: (BuildContext context) => CardList(title: title+' - Cartas')),
    );
  }

}


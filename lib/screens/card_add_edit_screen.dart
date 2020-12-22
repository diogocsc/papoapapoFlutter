import 'package:flutter/material.dart';
import 'package:our_cards/screens/common.dart';
import 'package:our_cards/database_helpers.dart';
import 'package:our_cards/screens/cardList_screen.dart';




class AddEdit extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title+ ' - Carta'),
        backgroundColor: mainBackgroundColor,
      ),
      body: AddEditForm(),
    );
  }
}

class AddEditForm extends StatefulWidget {
  @override
  _AddEditFormState createState() {
    return _AddEditFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class _AddEditFormState extends State<AddEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final cardTextController = TextEditingController();
  final cardCategoryController = TextEditingController();
  final cardURLController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    cardTextController.dispose();
    cardCategoryController.dispose();
    cardURLController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              // Add TextFormFields and ElevatedButton here.
              TextFormField(
                controller: cardTextController,
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
                controller: cardCategoryController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.category),
                  hintText: 'Q, P ou D',
                  labelText: 'Categoria',
                ),
              ),
              TextFormField(
                controller: cardURLController,
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
                  _saveRecord(cardTextController.text, cardCategoryController.text, cardURLController.text);
                  }
                },
                child: Text('Submit'),
              )
            ]
        )
    );
  }
  _saveRecord(String card, String category, String url) async{
    DatabaseHelper helper = DatabaseHelper.instance;
    MyCard mycard = MyCard();
    mycard.card = card;
    mycard.category = category;
    mycard.url = url;
    await helper.insert(mycard);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (BuildContext context) => CardList(title: title+' - Cartas')),
    );
  }

}
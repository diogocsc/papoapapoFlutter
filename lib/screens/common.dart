
import 'package:flutter/material.dart';
import 'package:papoapapo/database_helpers.dart';
import 'package:papoapapo/cards.dart';


bool textModeOn= false;
final mainBackgroundColor= Color(0xff6378a2);

var mode='ncategory';

final title= 'Papo a Papo';
List<MyCard> ourCards;
List<MyCard> ourCardsP;
List<MyCard> ourCardsQ;
List<MyCard> ourCardsD;

bootstrapCards() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  bool _cardExists = await helper.queryCheckCardExists();
  if (!_cardExists){
    for (int i=0; i< cards.length; i++) {
      MyCard card = MyCard();
      card.card = cards[i]['card'];
      if (cards[i].containsKey('category')) {
        card.category = cards[i]['category'];
      }
      if (cards[i].containsKey('url')) {
        card.url = cards[i]['url'];
      }
      card.isAsset = 1;
      int id = await helper.insert(card);
      print('inserted row: $id');
    }
  }
}

getOurCards() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  ourCards = await helper.queryAllCards();
  ourCardsP = await helper.queryCardsByCategory('P');
  ourCardsQ = await helper.queryCardsByCategory('Q');
  ourCardsD = await helper.queryCardsByCategory('D');
}
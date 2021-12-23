import 'dart:convert';

import 'package:http/http.dart' as http;

List<OnlineCard> onlineCards;


class OnlineCard {
  final String card;
  final String url;

  OnlineCard({
    this.card,
    this.url,
  });

  factory OnlineCard.fromJson(Map<String, dynamic> json) {
    return OnlineCard(
      card: json['cardText'],
      url: json['url'],
    );
  }
}

Future<List<OnlineCard>> fetchCards() async {
  final response = await http
      .get(Uri.parse('https://cardx.vercel.app/api/public/decks/Papo a Papo'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((card) => new OnlineCard.fromJson(card)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

getOnlineCards() async {
  onlineCards = await fetchCards();
}
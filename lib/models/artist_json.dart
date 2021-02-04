import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


Future<List<ArtistCategory>> fetchartistcategory(http.Client client) async {
  final response = await client.get('https://jsonkeeper.com/b/BOZ2');
  return compute(parseArtistCategory, response.body);

}

List<ArtistCategory> parseArtistCategory(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ArtistCategory>((json) => ArtistCategory.fromJson(json)).toList();
}

class ArtistCategory {
  final String title;
  final String image;
  final String emotion;

  ArtistCategory({ this.title, this.image,this.emotion});

  factory ArtistCategory.fromJson(Map<String, dynamic> json) {
    return ArtistCategory(
      title: json['title'],
      image: json['image'],
      emotion: json['emotion'],
    );
  }
}


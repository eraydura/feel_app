import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<AlbumCategory>> fetchcategory(http.Client client) async {
  final response = await client.get('https://jsonkeeper.com/b/6ABY');
  return compute(parseCategory, response.body);

}

List<AlbumCategory> parseCategory(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<AlbumCategory>((json) => AlbumCategory.fromJson(json)).toList();
}
class AlbumCategory {
  final String title;
  final String image;
  final String album;

  AlbumCategory({ this.title, this.image,this.album});

  factory AlbumCategory.fromJson(Map<String, dynamic> json) {
    return AlbumCategory(
      title: json['title'],
      image: json['image'],
      album: json['album'],
    );
  }
}